package view;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CommentController {

    private final CommentService service;

    @PostMapping("/comments/add")
    public String addComment(Comment comment) {
        service.addComment(comment);
        return "redirect:/view/detail?id=" + comment.getB_id();
    }
  
}
