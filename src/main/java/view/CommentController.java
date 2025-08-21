package view;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CommentController {
	
	@Autowired
	private CommentService service;
	
	@PostMapping("/comments/add")
	public String addComment(Comment comment) {
		service.addComment(comment);
		return "redirect:/view/detail?id=" + comment.getB_id();
	}

}
