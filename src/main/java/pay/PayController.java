package pay;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
public class PayController {
	
	@GetMapping("/pay")
	public String pay(@RequestParam String title,
			 @RequestParam(required = false, defaultValue = "0") int price,
			 @RequestParam(required = false, defaultValue = "1") int qty,
            Model model) {

		int total = price * qty;
		
		model.addAttribute("title", title);
		model.addAttribute("price", price);
		model.addAttribute("qty", qty);
		model.addAttribute("total", total);
		
		return "pay"; // pay.jsp
	}
	
	@PostMapping("/pay")
	public String payForm(@RequestParam List<String> title,
            @RequestParam List<Integer> price,
            @RequestParam List<Integer> qty,
            Model model) {

		List<Map<String, Object>> orderList = new ArrayList<>();
	    int total = 0;

	    for (int i = 0; i < title.size(); i++) {
	        int itemTotal = price.get(i) * qty.get(i);
	        total += itemTotal;

	        Map<String, Object> item = new HashMap<>();
	        item.put("title", title.get(i));
	        item.put("price", price.get(i));
	        item.put("qty", qty.get(i));
	        item.put("total", itemTotal);
	        orderList.add(item);
	    }

	    model.addAttribute("orderList", orderList);
	    model.addAttribute("total", total);

	    return "pay"; // pay.jsp
	}
}
