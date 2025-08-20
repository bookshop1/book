package chart;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface ChartMapper {

    // 📊 책별 일별 판매량
    @Select("SELECT title, TO_CHAR(p.pay_date, 'YYYY-MM-DD') AS saleDate, SUM(pi.price * pi.quantity) AS totalSales " +
            "FROM payment_items pi " +
            "JOIN payments p ON pi.payment_id = p.id " +
            "GROUP BY title, TO_CHAR(p.pay_date, 'YYYY-MM-DD') " +
            "ORDER BY saleDate")
    List<SalesDTO> getDailySales();

    // 📊 책별 월별 판매량
    @Select("SELECT title, TO_CHAR(p.pay_date, 'YYYY-MM') AS saleDate, SUM(pi.price * pi.quantity) AS totalSales " +
            "FROM payment_items pi " +
            "JOIN payments p ON pi.payment_id = p.id " +
            "GROUP BY title, TO_CHAR(p.pay_date, 'YYYY-MM') " +
            "ORDER BY saleDate")
    List<SalesDTO> getMonthlySales();

    // 📊 책별 연도별 판매량
    @Select("SELECT title, TO_CHAR(p.pay_date, 'YYYY') AS saleDate, SUM(pi.price * pi.quantity) AS totalSales " +
            "FROM payment_items pi " +
            "JOIN payments p ON pi.payment_id = p.id " +
            "GROUP BY title, TO_CHAR(p.pay_date, 'YYYY') " +
            "ORDER BY saleDate")
    List<SalesDTO> getYearlySales();
}
