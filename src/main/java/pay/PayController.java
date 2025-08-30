package pay;

import bag.BagBook;
import bag.BagBookListWrapper;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class PayController {
    
    @Autowired
    PayService service;

    /** ✅ 현재 로그인한 userId 가져오기 */
    private Integer getLoginUserId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth == null || auth.getPrincipal().equals("anonymousUser")) {
            return null;
        }
        
        String username = auth.getName();
        Integer uId = service.findUIdByUsername(username); 
        return uId;
    }

    /** 장바구니 → 결제 페이지 */
    @PostMapping("/pay")
    public String payForm(
            @RequestParam(name="b_id", required = false) List<Integer> bIds,
            @RequestParam(name="quantity", required = false) List<Integer> quantities,
            HttpSession session,
            HttpServletRequest request,
            HttpServletResponse response,
            Model model) {

        Integer u_id = getLoginUserId();

        // 1️⃣ 비로그인 사용자: 무조건 로그인 페이지로 리다이렉트
        if (u_id == null) {
            // ✅ 추가된 로직: 로그인 성공 후 돌아갈 경로를 세션에 저장
            session.setAttribute("redirectUrl", "/bag/bagform");
            session.setAttribute("prevUrl", "/pay");

            // 쿠키에서 guestCart 데이터를 읽어와 세션에 임시 저장
            List<Map<String, Integer>> guestCartData = getGuestCartDataFromCookie(request);
            if(guestCartData == null) {
                guestCartData = new ArrayList<>();
            }
            session.setAttribute("guestCartForPay", guestCartData);

            return "redirect:/login/loginform";
        }
        
        // 3️⃣ 로그인 & 장바구니 있음 → 결제 페이지로
        List<Map<String, Object>> orderList = new ArrayList<>();
        int total = 0;

        for (int i = 0; i < bIds.size(); i++) {
            BagBook book = service.getBookById(bIds.get(i));
            if (book != null) {
                int qty = quantities.get(i);
                int itemTotal = book.getPrice() * qty;
                total += itemTotal;
                
                Map<String, Object> item = new HashMap<>();
                item.put("b_id", book.getB_id());
                item.put("title", book.getTitle());
                item.put("price", book.getPrice());
                item.put("quantity", qty);
                item.put("total", itemTotal);
                orderList.add(item);
            }
        }
        
        model.addAttribute("orderList", orderList);
        model.addAttribute("total", total);

        return "pay";
    }

    /** 결제 성공 */
    @PostMapping("/paySuccess")
    public String payment(@ModelAttribute Payment payment,
                          @ModelAttribute BagBookListWrapper wrapper) {
        
        Integer userId = getLoginUserId();
        payment.setUserId(userId);

        List<BagBook> bagItems = wrapper.getBagItems();
        
        service.payment(payment, userId, bagItems);

        if (userId != null) {
            service.deleteBag(userId);
        }

        return "redirect:/paymentComplete";
    }

    @GetMapping("/paymentComplete")
    public String paymentComplete() {
        return "paymentComplete";
    }

    @GetMapping("/paymentHistory")
    public String viewPaymentHistory(Model model) {
        Integer userId = getLoginUserId();
        
        List<Payment> paymentList = service.getPaymentHistoryByUserId(userId);
        model.addAttribute("paymentList", paymentList);

        return "paymentHistory";
    }
    
    @GetMapping("/chart")
    public String chart() {
        return "chart";
    }

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
}