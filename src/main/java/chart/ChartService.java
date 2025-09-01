package chart;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ChartService {

	@Autowired
    private ChartMapper chartMapper;

    private final String[] categories = {"전체", "essay", "humanities", "novel", "health", "economy"};

    // 전체/카테고리별 Top5 판매량
    public Map<String, List<TopSalesDTO>> getTopSalesMap() {
        Map<String, List<TopSalesDTO>> map = new HashMap<>();
        for(String cat : categories) {
            map.put(cat, chartMapper.getTopSales(cat));
        }
        return map;
    }

    // 전체/카테고리별 Top5 별점
    public Map<String, List<TopScoreDTO>> getTopScoreMap() {
        Map<String, List<TopScoreDTO>> map = new HashMap<>();
        for(String cat : categories) {
            map.put(cat, chartMapper.getTopScore(cat));
        }
        return map;
    }

    // 별점 통계
    public int[] getScoreCounts() {
        int[] scoreCounts = new int[5]; // 1~5점
        List<ScoreDTO> list = chartMapper.getScoreCount();
        if(list != null) {
            for(ScoreDTO s : list) {
                if(s != null) {
                    int idx = s.getScore() - 1;
                    scoreCounts[idx] = s.getCount();
                }
            }
        }
        return scoreCounts;
    }

    public ReviewAvgDTO getReviewAvg() {
        return chartMapper.getReviewAvg();
    }

    // 매출
    public SalesDTO getTodaySales() { return chartMapper.getTodaySales(); }
    public List<SalesDTO> getDailySales() { return chartMapper.getDailySales(); }
    public List<SalesDTO> getMonthlySales() { return chartMapper.getMonthlySales(); }
    public List<SalesDTO> getYearlySales() { return chartMapper.getYearlySales(); }

    // 카테고리 배열 제공
    public String[] getCategories() { return categories; }
}


