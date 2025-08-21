package pay;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import bag.BagBook;
import bag.BagBookListWrapper;

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

        // 로그인한 username (users.id 컬럼 값)
        String username = auth.getName();

        // username으로 DB 조회해서 u_id만 꺼냄
        Integer uId = service.findUIdByUsername(username); 
        return uId;
    }

    /** 장바구니 → 결제 페이지 */
    @PostMapping("/pay")
    public String payForm(@RequestParam(name="b_id") List<Integer> bIds,
                          @RequestParam(name="quantity") List<Integer> quantities,
                          HttpSession session,
                          Model model) {

        Integer u_id = getLoginUserId(); // 로그인 유저 ID 확인

        // 1️⃣ 비로그인 처리
        if (u_id == null) {
            List<Map<String, Integer>> guestCartForPay = new ArrayList<>();
            for (int i = 0; i < bIds.size(); i++) {
                Map<String, Integer> item = new HashMap<>();
                item.put("b_id", bIds.get(i));
                item.put("quantity", quantities.get(i));
                guestCartForPay.add(item);
            }
            session.setAttribute("guestCartForPay", guestCartForPay);

            return "redirect:/login/loginform"; // 로그인 페이지로
        }

        // 2️⃣ 로그인했지만 장바구니 비어 있는 경우
        if (bIds == null || bIds.isEmpty()) {
            // 알림 페이지로 redirect하거나 에러 페이지
            model.addAttribute("errorMsg", "장바구니가 비어 있습니다.");
            return "redirect:/main"; // cartEmpty.jsp 같은 페이지 생성
        }

        // 3️⃣ 로그인 & 장바구니 있음 → 주문 처리
        List<Map<String, Object>> orderList = new ArrayList<>();
        int total = 0;

        for (int i = 0; i < bIds.size(); i++) {
            BagBook book = service.getBookById(bIds.get(i));
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

        model.addAttribute("orderList", orderList);
        model.addAttribute("total", total);

        return "pay"; // pay.jsp
    }

    /** 결제 성공 */
    @PostMapping("/paySuccess")
    public String payment(@ModelAttribute Payment payment,
                          @ModelAttribute BagBookListWrapper wrapper) {
        
        Integer userId = getLoginUserId();
        payment.setUserId(userId);

        List<BagBook> bagItems = wrapper.getBagItems();
        
        service.payment(payment, userId, bagItems);

        // ✅ DB 장바구니 비우기
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
}