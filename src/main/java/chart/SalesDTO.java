package chart;

import lombok.Data;

@Data
public class SalesDTO {
    private String title;     // 책 제목
    private String saleDate;  // 판매 날짜 (일/월/연도 단위)
    private int totalSales;   // 총 판매량
}
