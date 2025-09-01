package chart;

public class ReviewAvgDTO {
    private double avgScore;     // 평균 별점
    private int reviewCount;     // 리뷰 수

    // getter/setter
    public double getAvgScore() { return avgScore; }
    public void setAvgScore(double avgScore) { this.avgScore = avgScore; }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }
}

