package view;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import chart.ReviewAvgDTO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CommentService {

    private final CommentMapper mapper;

    public void addComment(Comment comment) {
        mapper.insertComment(comment);
    }

    public List<Comment> getCommentsByBookId(@Param("b_id") int b_id) {
        return mapper.selectCommentsByBookId(b_id);
    }

    public ReviewAvgDTO getReviewAvgByBookId(int b_id) {
        return mapper.getReviewAvgByBookId(b_id);
    }
}
