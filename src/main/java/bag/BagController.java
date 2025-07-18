package bag;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("bag")
public class BagController {
	@Autowired
	private BagService service;
	 
	@GetMapping("/bagform")
	public String bagForm(Model model, HttpSession session) {
		try {
			Integer u_id = (Integer) session.getAttribute("userId");
	        if (u_id == null) return "redirect:/login/loginform";
	        System.out.println("u_id = " + u_id);
	        
	        List<BagBook> bagItems = service.getBagItems(u_id);
	        System.out.println(bagItems.toString());

	        int totalPrice = service.totalPrice(u_id);
	        System.out.println(totalPrice);
	        
	        model.addAttribute("bagItems", bagItems);
	        model.addAttribute("totalPrice", totalPrice);

	        return "bagform"; // your JSP file name without extension
		}catch(Exception e) {
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
	        if (u_id == null) return "redirect:/login/loginform";

	        service.addOrUpdateBag(u_id, b_id, quantity);
	        return "redirect:/bag/bagform";
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "error";
	    }
	}

	    @PostMapping("/bagdelete")
	    public String deleteItem(@RequestParam int b_id, HttpSession session) {
	        Integer userId = (Integer) session.getAttribute("userId");
	        if (userId != null) {
	            service.deleteBag(userId, b_id);
	        }
	        return "redirect:/bag/bagform";
	    }
}
