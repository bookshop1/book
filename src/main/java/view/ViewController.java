package view;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import chart.ReviewAvgDTO;

@Controller
@RequestMapping("view")
public class ViewController {
	
	@Autowired
	ViewService service;
	
	@Autowired
	CommentService commentService;

	@GetMapping("/detail")
	public String detail(@RequestParam("id") int id, Model model) {
		View view = service.getDetail(id);
		List<Comment> comments = commentService.getCommentsByBookId(id);
		
		model.addAttribute("view", view);
		model.addAttribute("comments", comments);
		
		ReviewAvgDTO reviewAvg = commentService.getReviewAvgByBookId(id);
		model.addAttribute("reviewAvg", reviewAvg);
		
		return "detail";
	}
}