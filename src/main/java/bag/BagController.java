package bag;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("bag")
public class BagController {
	@Autowired
	private BagService service;
	 
	@GetMapping("/bagform")
	public String bagForm(Model model, HttpSession session) {
	    try {
	        Integer u_id = (Integer) session.getAttribute("userId");
	        List<BagBook> bagItems;
	        int totalPrice = 0;

	        if (u_id != null) {
	            // 로그인 사용자 - DB 장바구니
	            bagItems = service.getBagItems(u_id);
	            totalPrice = service.totalPrice(u_id);
	        } else {
	            // 비로그인 사용자 - 세션에서 가져오기
	            bagItems = (List<BagBook>) session.getAttribute("guestCart");
	            if (bagItems == null) bagItems = new java.util.ArrayList<>();
	            for (BagBook item : bagItems) {
	                totalPrice += item.getPrice() * item.getQuantity();
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

	@PostMapping("/add")
	public String addToBag(@RequestParam("b_id") int b_id,
	                       @RequestParam(value = "quantity", defaultValue = "1") int quantity,
	                       HttpSession session) {
	    try {
	        Integer u_id = (Integer) session.getAttribute("userId");
	        if (u_id != null) {
	            // 로그인 상태 - DB에 저장
	            service.addOrUpdateBag(u_id, b_id, quantity);
	        } else {
	            // 비로그인 상태 - 세션에 저장
	            List<BagBook> guestCart = (List<BagBook>) session.getAttribute("guestCart");
	            if (guestCart == null) guestCart = new java.util.ArrayList<>();

	            // 이미 같은 책 있으면 수량만 변경
	            boolean found = false;
	            for (BagBook item : guestCart) {
	                if (item.getB_id() == b_id) {
	                    item.setQuantity(item.getQuantity() + quantity);
	                    found = true;
	                    break;
	                }
	            }
	            if (!found) {
	                BagBook book = service.getBookById(b_id); // 책 정보 가져오기
	                book.setQuantity(quantity);
	                guestCart.add(book);
	            }

	            session.setAttribute("guestCart", guestCart);
	        }
	        return "redirect:/bag/bagform";
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "error";
	    }
	}
	/*
 CREATE TABLE bag (
    u_id NUMBER,        -- 사용자
    b_id NUMBER,        -- 책
    quantity NUMBER,    -- 수량
    PRIMARY KEY (u_id, b_id),
    FOREIGN KEY (u_id) REFERENCES users(u_id),
    FOREIGN KEY (b_id) REFERENCES book(b_id)
);
INSERT INTO bag (u_id, b_id, quantity) VALUES (1, 1, 2);
INSERT INTO bag (u_id, b_id, quantity) VALUES (1, 2, 3);
확인용 테이블
	*/
	@PostMapping("/bagdelete")
	public String deleteItem(@RequestParam int b_id, HttpSession session) {
		Integer userId = (Integer) session.getAttribute("userId");
		if (userId != null) {
		    service.deleteBag(userId, b_id);
		} else {
		    List<BagBook> guestCart = (List<BagBook>) session.getAttribute("guestCart");
		    if (guestCart != null) {
		        guestCart.removeIf(item -> item.getB_id() == b_id);
		        session.setAttribute("guestCart", guestCart);
		    }
		}
	    return "redirect:/bag/bagform";
	}
	
	@GetMapping("/login-success")
	public String loginSuccess(HttpSession session) {
	    Integer u_id = (Integer) session.getAttribute("userId");

	    // 1. 기존 게스트 카트 DB 반영
	    List<BagBook> guestCart = (List<BagBook>) session.getAttribute("guestCart");
	    if (guestCart != null && u_id != null) {
	        for (BagBook item : guestCart) {
	            service.addOrUpdateBag(u_id, item.getB_id(), item.getQuantity());
	        }
	        session.removeAttribute("guestCart");
	    }

	    // 2. 로그인 전 결제 시도 정보 반영
	    List<Map<String, Integer>> guestCartForPay = 
	            (List<Map<String, Integer>>) session.getAttribute("guestCartForPay");
	    if (guestCartForPay != null && u_id != null) {
	        for (Map<String, Integer> item : guestCartForPay) {
	            service.addOrUpdateBag(u_id, item.get("b_id"), item.get("quantity"));
	        }
	        session.removeAttribute("guestCartForPay");
	    }

	    return "redirect:/bag/bagform";
	}
	
	@PostMapping("/bag/update-guest-quantity")
	@ResponseBody
	public String updateGuestQuantity(@RequestParam("b_id") Integer bId,
	                                  @RequestParam("quantity") Integer quantity,
	                                  HttpSession session) {
	    List<BagBook> guestCart = (List<BagBook>) session.getAttribute("guestCart");
	    if (guestCart != null) {
	        for (BagBook item : guestCart) {
	            if (item.getB_id() == bId) {
	                item.setQuantity(quantity); // 세션에 반영
	                break;
	            }
	        }
	        session.setAttribute("guestCart", guestCart);
	    }
	    return "ok";
	}
}
