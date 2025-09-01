package chart;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface ChartMapper {

    // 1. 전체/카테고리별 Top5 판매량
    List<TopSalesDTO> getTopSales(@Param("category") String category);

    // 2. 각 별점 개수
    List<ScoreDTO> getScoreCount();

    // 3. 총 별점 평균
    ReviewAvgDTO getReviewAvg();

    // 4. 전체/카테고리별 Top5 별점
    List<TopScoreDTO> getTopScore(@Param("category") String category);

    // 5. 오늘 날짜 판매량
    SalesDTO getTodaySales();

    // 6. 일별 판매량
    List<SalesDTO> getDailySales();

    // 7. 월별 판매량
    List<SalesDTO> getMonthlySales();

    // 8. 연도별 판매량
    List<SalesDTO> getYearlySales();
}

