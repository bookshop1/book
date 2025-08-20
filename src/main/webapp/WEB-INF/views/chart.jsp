<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<%@ include file="header.jsp" %>
<head>
    <meta charset="UTF-8">
    <title>책별 판매량 차트</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<main class="container py-5">

<h2 class="mb-5 text-center">책별 판매량 통계</h2>

<!-- 버튼으로 일/월/연 전환 -->
<div class="mb-4 text-center">
    <button class="btn btn-primary mx-1" onclick="loadChart('daily')">일별</button>
    <button class="btn btn-success mx-1" onclick="loadChart('monthly')">월별</button>
    <button class="btn btn-warning mx-1" onclick="loadChart('yearly')">연도별</button>
</div>

<canvas id="salesChart" width="1000" height="500"></canvas>

<%
    String jdbcUrl = "jdbc:oracle:thin:@localhost:1521:xe";
    String dbUser = "test";
    String dbPass = "1111";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    StringBuilder dailyLabels = new StringBuilder();
    StringBuilder dailyData = new StringBuilder();
    StringBuilder monthlyLabels = new StringBuilder();
    StringBuilder monthlyData = new StringBuilder();
    StringBuilder yearlyLabels = new StringBuilder();
    StringBuilder yearlyData = new StringBuilder();

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPass);

        // 📌 일별
        String sqlDaily = 
            "SELECT title || ' (' || TO_CHAR(sale_date,'YYYY-MM-DD') || ')' AS label, " +
            "       SUM(price*quantity) AS total_amount, " +
            "       TRUNC(sale_date, 'DD') AS grp_date " +
            "FROM payment_items " +
            "GROUP BY title, TRUNC(sale_date, 'DD'), TO_CHAR(sale_date,'YYYY-MM-DD') " +
            "ORDER BY grp_date";
        pstmt = conn.prepareStatement(sqlDaily);
        rs = pstmt.executeQuery();
        boolean first = true;
        while(rs.next()) {
            if(!first) { dailyLabels.append(","); dailyData.append(","); }
            dailyLabels.append("'").append(rs.getString("label")).append("'");
            dailyData.append(rs.getDouble("total_amount"));
            first = false;
        }
        rs.close(); pstmt.close();

        // 📌 월별
        String sqlMonthly = 
            "SELECT title || ' (' || TO_CHAR(sale_date,'YYYY-MM') || ')' AS label, " +
            "       SUM(price*quantity) AS total_amount, " +
            "       TRUNC(sale_date, 'MM') AS grp_date " +
            "FROM payment_items " +
            "GROUP BY title, TRUNC(sale_date, 'MM'), TO_CHAR(sale_date,'YYYY-MM') " +
            "ORDER BY grp_date";
        pstmt = conn.prepareStatement(sqlMonthly);
        rs = pstmt.executeQuery();
        first = true;
        while(rs.next()) {
            if(!first) { monthlyLabels.append(","); monthlyData.append(","); }
            monthlyLabels.append("'").append(rs.getString("label")).append("'");
            monthlyData.append(rs.getDouble("total_amount"));
            first = false;
        }
        rs.close(); pstmt.close();

        // 📌 연도별
        String sqlYearly = 
            "SELECT title || ' (' || TO_CHAR(sale_date,'YYYY') || ')' AS label, " +
            "       SUM(price*quantity) AS total_amount, " +
            "       TRUNC(sale_date, 'YYYY') AS grp_date " +
            "FROM payment_items " +
            "GROUP BY title, TRUNC(sale_date, 'YYYY'), TO_CHAR(sale_date,'YYYY') " +
            "ORDER BY grp_date";
        pstmt = conn.prepareStatement(sqlYearly);
        rs = pstmt.executeQuery();
        first = true;
        while(rs.next()) {
            if(!first) { yearlyLabels.append(","); yearlyData.append(","); }
            yearlyLabels.append("'").append(rs.getString("label")).append("'");
            yearlyData.append(rs.getDouble("total_amount"));
            first = false;
        }
    } catch(Exception e) {
        out.println("<p class='text-danger'>DB 오류: " + e.getMessage() + "</p>");
    } finally {
        try { if(rs != null) rs.close(); } catch(Exception ignore){}
        try { if(pstmt != null) pstmt.close(); } catch(Exception ignore){}
        try { if(conn != null) conn.close(); } catch(Exception ignore){}
    }
%>

<script>
let chart;

const chartData = {
    daily: { labels: [<%= dailyLabels.toString() %>], data: [<%= dailyData.toString() %>] },
    monthly: { labels: [<%= monthlyLabels.toString() %>], data: [<%= monthlyData.toString() %>] },
    yearly: { labels: [<%= yearlyLabels.toString() %>], data: [<%= yearlyData.toString() %>] }
};

function loadChart(type) {
    const ctx = document.getElementById('salesChart').getContext('2d');
    const labels = chartData[type].labels;
    const values = chartData[type].data;

    if(chart) chart.destroy();

    chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: `책별 ${type} 판매량`,
                data: values,
                backgroundColor: 'rgba(54, 162, 235, 0.6)'
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { display: false }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: { stepSize: 5000 }
                }
            }
        }
    });
}

// 초기 실행: 일별
loadChart('daily');
</script>

</main>
 <%@ include file="footer.jsp" %>
</body>
</html>
