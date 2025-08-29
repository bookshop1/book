package view;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CommentService {

    private final CommentMapper mapper;

    public void addComment(Comment comment) {
        mapper.insertComment(comment);
    }

    public List<Comment> getCommentsByBookId(int b_id) {
        return mapper.selectCommentsByBookId(b_id);
    }

  
}
