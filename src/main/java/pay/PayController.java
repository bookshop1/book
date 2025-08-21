package pay;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import bag.BagBook;
import bag.BagBookListWrapper;
import join.JoinService; // 1. JoinService (또는 UserService) import
import join.UserVO;     // 1. UserVO import

@Controller
public class PayController {
    
    @Autowired
    private PayService service;
    
    @Autowired
    private JoinService joinService; // 2. JoinService (또는 UserService) 주입
    
    // "바로 구매" 시 결제 페이지
    @GetMapping("/pay")
    public String pay(@RequestParam String title,
                      @RequestParam(required = false, defaultValue = "0") int price,
                      @RequestParam(required = false, defaultValue = "1") int quantity,
                      Model model, HttpSession session) { // 3. HttpSession 파라미터 추가

        // 4. 세션에서 사용자 정보를 가져와 모델에 추가하는 로직
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login/loginform";
        }
        UserVO loginUser = joinService.findUserById(userId); // DB에서 사용자 정보 조회
        model.addAttribute("loginUser", loginUser);

        // (기존 로직) 바로 구매 상품 정보를 List<Map> 형태로 만들어 JSP와 통일
        List<Map<String, Object>> orderList = new ArrayList<>();
        Map<String, Object> item = new HashMap<>();
        item.put("title", title);
        item.put("price", price);
        item.put("quantity", quantity);
        item.put("total", price * quantity);
        orderList.add(item);
        
        model.addAttribute("orderList", orderList);
        model.addAttribute("total", price * quantity);
        
        return "pay"; // pay.jsp
    }
    
    // "장바구니에서 결제" 시 결제 페이지
    @PostMapping("/pay")
    public String payForm(@RequestParam List<String> title,
                          @RequestParam List<Integer> price,
                          @RequestParam List<Integer> quantity,
                          Model model, HttpSession session) { // 5. HttpSession 파라미터 추가

        // 6. 세션에서 사용자 정보를 가져와 모델에 추가하는 로직
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login/loginform";
        }
        UserVO loginUser = joinService.findUserById(userId); // DB에서 사용자 정보 조회
        model.addAttribute("loginUser", loginUser);

        // (기존 로직) 장바구니 상품 목록 처리
        List<Map<String, Object>> orderList = new ArrayList<>();
        int total = 0;

        for (int i = 0; i < title.size(); i++) {
            int itemTotal = price.get(i) * quantity.get(i);
            total += itemTotal;

            Map<String, Object> item = new HashMap<>();
            item.put("title", title.get(i));
            item.put("price", price.get(i));
            item.put("quantity", quantity.get(i));
            item.put("total", itemTotal);
            orderList.add(item);
        }

        model.addAttribute("orderList", orderList);
        model.addAttribute("total", total);

        return "pay"; // pay.jsp
    }
    
    // (참고) 나머지 메소드는 수정할 필요 없습니다.
    
    @PostMapping("/paySuccess")
    public String payment(HttpSession session,    
                          @ModelAttribute Payment payment,    
                          @ModelAttribute BagBookListWrapper wrapper) {
        
        Integer userId = (Integer) session.getAttribute("userId");
        payment.setUserId(userId); 

        List<BagBook> bagItems = wrapper.getBagItems();
        
        service.payment(payment, userId, bagItems);
        service.deletebag(userId);

        return "redirect:/paymentComplete";
    }
    
    @GetMapping("/paymentComplete")
    public String paymentComplete() {
        return "paymentComplete";
    }
    
    @GetMapping("/paymentHistory")
    public String viewPaymentHistory(HttpSession session, Model model) {
        int userId = (int) session.getAttribute("userId");

        List<Payment> paymentList = service.getPaymentHistoryByUserId(userId);
        model.addAttribute("paymentList", paymentList);

        return "paymentHistory";
    }
    
    @GetMapping("/chart")
    public String chart() {
        return "chart";
    }
}