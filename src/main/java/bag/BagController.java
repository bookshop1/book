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
	        Integer u_id = 1;//(Integer) session.getAttribute("userId");
	        //실행되는지 확인용으로 u_id는 1로 고정
	        if (u_id == null) return "redirect:/login";
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
	        }
	        return "bagform";
	    }
}
