package pay;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import bag.BagBook;
import join.UserVO;


@Controller
public class PayController {
	
	@Autowired
	PayService service;
	
	@GetMapping("/pay")
	public String pay(@RequestParam String title,
			 @RequestParam(required = false, defaultValue = "0") int price,
			 @RequestParam(required = false, defaultValue = "1") int quantity,
            Model model) {

		int total = price * quantity;
		
		model.addAttribute("title", title);
		model.addAttribute("price", price);
		model.addAttribute("quantity", quantity);
		model.addAttribute("total", total);
		
		return "pay"; // pay.jsp
	}
	
	@PostMapping("/pay")
	public String payForm(@RequestParam List<String> title,
            @RequestParam List<Integer> price,
            @RequestParam List<Integer> quantity,
            Model model) {

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
	
	@PostMapping("/paySuccess")
    public String payment(HttpSession session, @ModelAttribute Payment payment, List<BagBook> bagItems) {
		
		Integer userId = (Integer) session.getAttribute("userId");
	    payment.setUserId(userId);  // 세션에서 넣어주기

	    service.payment(payment, userId, bagItems);

	    return "redirect:/paymentComplete";
    }
	
	
}
