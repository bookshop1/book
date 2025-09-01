package chart;

public class TopScoreDTO {
    private String title;        // 책 제목
    private double avgScore;     // 평균 별점
    private int reviewCount;     // 리뷰 수

    // getter/setter
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public double getAvgScore() { return avgScore; }
    public void setAvgScore(double avgScore) { this.avgScore = avgScore; }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }
}

