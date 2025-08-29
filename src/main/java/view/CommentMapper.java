package view;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface CommentMapper {

    @Insert("INSERT INTO comments (id, b_id, writer, content, score) " +
            "VALUES (comments_seq.nextval, #{b_id}, #{writer}, #{content}, #{score})")
    void insertComment(Comment comment);

    @Select("SELECT id, b_id, writer, content, score, reg_date AS regDate " +
            "FROM comments WHERE b_id = #{b_id} ORDER BY reg_date DESC")
    List<Comment> selectCommentsByBookId(int b_id);

  
}
