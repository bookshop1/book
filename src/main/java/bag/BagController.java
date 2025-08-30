package bag;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
@RequestMapping("bag")
public class BagController {
    @Autowired
    private BagService service;

    // 장바구니 페이지
    @GetMapping("/bagform")
    public String bagForm(Model model, HttpSession session, HttpServletRequest request) {
        try {
            Integer u_id = (Integer) session.getAttribute("userId");
            List<BagBook> bagItems = new ArrayList<>();
            int totalPrice = 0;

            if (u_id != null) {
                // 로그인 사용자: DB에서 장바구니 가져오기
                bagItems = service.getBagItems(u_id);
                totalPrice = service.totalPrice(u_id);
            } else {
                // 비로그인 사용자: 쿠키에서 b_id와 quantity만 가져와서 나머지 정보는 DB에서 조회
                List<Map<String, Integer>> guestCartData = getGuestCartDataFromCookie(request);
                if (guestCartData != null) {
                    for (Map<String, Integer> item : guestCartData) {
                        int bId = item.get("b_id");
                        int quantity = item.get("quantity");

                        BagBook book = service.getBookById(bId);
                        if (book != null) {
                            book.setQuantity(quantity);
                            bagItems.add(book);
                            totalPrice += book.getPrice() * quantity;
                        }
                    }
                }
            }

            model.addAttribute("bagItems", bagItems);
            model.addAttribute("totalPrice", totalPrice);
            return "bagform";
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }

    // 장바구니에 상품 추가
    @PostMapping("/add")
    public String addToBag(@RequestParam("b_id") int b_id,
                           @RequestParam(value = "quantity", defaultValue = "1") int quantity,
                           HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        try {
            Integer u_id = (Integer) session.getAttribute("userId");
            if (u_id != null) {
                // 로그인 상태: DB에 저장
                service.addOrUpdateBag(u_id, b_id, quantity);
            } else {
                // 비로그인 상태: 쿠키에 저장
                List<Map<String, Integer>> guestCartData = getGuestCartDataFromCookie(request);
                if (guestCartData == null) {
                    guestCartData = new ArrayList<>();
                }

                boolean found = false;
                for (Map<String, Integer> item : guestCartData) {
                    if (item.get("b_id") == b_id) {
                        item.put("quantity", item.get("quantity") + quantity);
                        found = true;
                        break;
                    }
                }
                if (!found) {
                    Map<String, Integer> newItem = new HashMap<>();
                    newItem.put("b_id", b_id);
                    newItem.put("quantity", quantity);
                    guestCartData.add(newItem);
                }
                saveGuestCartDataToCookie(guestCartData, response);
            }
            return "redirect:/bag/bagform";
        } catch (Exception e) {
            e.printStackTrace();
            return "error";
        }
    }

    // 장바구니 상품 삭제
    @PostMapping("/bagdelete")
    public String deleteItem(@RequestParam int b_id, HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId != null) {
            // 로그인 상태: DB에서 삭제
            service.deleteBag(userId, b_id);
        } else {
            // 비로그인 상태: 쿠키에서 삭제
            List<Map<String, Integer>> guestCartData = getGuestCartDataFromCookie(request);
            if (guestCartData != null) {
                guestCartData.removeIf(item -> item.get("b_id") == b_id);
                saveGuestCartDataToCookie(guestCartData, response);
            }
        }
        return "redirect:/bag/bagform";
    }

    // 로그인 성공 후 장바구니 병합
    @GetMapping("/login-success")
    public String loginSuccess(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        Integer u_id = (Integer) session.getAttribute("userId");
        
        // 쿠키에 있는 장바구니 정보를 DB에 병합
        List<Map<String, Integer>> guestCartData = getGuestCartDataFromCookie(request);
        if (guestCartData != null && u_id != null) {
            for (Map<String, Integer> item : guestCartData) {
                service.addOrUpdateBag(u_id, item.get("b_id"), item.get("quantity"));
            }
            // 병합 후 쿠키 삭제
            deleteBagItemsCookie(response);
        }
        
        // ✅ 수정된 로직: 세션에 저장된 경로로 리다이렉트
        String redirectUrl = (String) session.getAttribute("redirectUrl");
        session.removeAttribute("redirectUrl"); // 사용 후 세션에서 제거
        if (redirectUrl != null) {
            return "redirect:" + redirectUrl;
        }
        
        return "redirect:/main";
    }

    // 비로그인 상태에서 수량 변경
    @PostMapping("/update-guest-quantity")
    @ResponseBody
    public String updateGuestQuantity(@RequestParam("b_id") Integer bId,
                                      @RequestParam("quantity") Integer quantity,
                                      HttpServletRequest request, HttpServletResponse response) {
        List<Map<String, Integer>> guestCartData = getGuestCartDataFromCookie(request);
        if (guestCartData != null) {
            for (Map<String, Integer> item : guestCartData) {
                if (item.get("b_id") == bId) {
                    item.put("quantity", quantity);
                    break;
                }
            }
            saveGuestCartDataToCookie(guestCartData, response);
        }
        return "ok";
    }
    
    // ** 헬퍼 메서드 **
    /** 쿠키에서 b_id와 quantity 데이터(JSON)를 읽어와 List<Map>으로 변환 */
    private List<Map<String, Integer>> getGuestCartDataFromCookie(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("guestCart".equals(cookie.getName())) {
                    try {
                        String decodedValue = URLDecoder.decode(cookie.getValue(), StandardCharsets.UTF_8.toString());
                        ObjectMapper mapper = new ObjectMapper();
                        return mapper.readValue(decodedValue, new TypeReference<List<Map<String, Integer>>>() {});
                    } catch (Exception e) {
                        e.printStackTrace();
                        return new ArrayList<>();
                    }
                }
            }
        }
        return null;
    }

    /** b_id와 quantity 데이터 List<Map>을 JSON으로 변환하여 쿠키에 저장 */
    private void saveGuestCartDataToCookie(List<Map<String, Integer>> cartData, HttpServletResponse response) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            String jsonCart = mapper.writeValueAsString(cartData);
            String encodedValue = URLEncoder.encode(jsonCart, StandardCharsets.UTF_8.toString());
            
            Cookie cookie = new Cookie("guestCart", encodedValue);
            cookie.setMaxAge(60 * 60 * 24 * 7); // 7일 동안 유지
            cookie.setPath("/");
            response.addCookie(cookie);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /** 장바구니 쿠키 삭제 */
    private void deleteBagItemsCookie(HttpServletResponse response) {
        Cookie cookie = new Cookie("guestCart", null);
        cookie.setMaxAge(0); // 쿠키 만료
        cookie.setPath("/");
        response.addCookie(cookie);
    }
    
    @PostMapping("/save-bag-items")
    @ResponseBody
    public String saveBagItems(@RequestBody List<BagBook> bagItems, HttpSession session) {
        Integer uId = (Integer) session.getAttribute("userId");
        if (uId == null) {
            return "not_logged_in";
        }

        try {
            service.updateAllBagItems(uId, bagItems); // 수정된 서비스 메서드 호출
            return "success";
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }
}