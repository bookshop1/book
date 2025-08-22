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
    
    <!-- 일간, 연간 총매출 통계 표시 -->
    <div class="row mb-4 text-center">
        <div class="col-md-6">
            <h4>일간 총매출: <span id="dailyTotalAmount">로딩중...</span> 원</h4>
        </div>
        <div class="col-md-6">
            <h4>연간 총매출: <span id="yearlyTotalAmount">로딩중...</span> 원</h4>
        </div>
    </div>

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
        
        // 일간, 연간 총매출 변수 선언
        double dailyTotalAmount = 0;
        double yearlyTotalAmount = 0;

        try { 
            Class.forName("oracle.jdbc.driver.OracleDriver"); 
            conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPass); 
            
            // 📌 일별 매출 (카테고리별) 계산
            String sqlDaily = "SELECT b.category AS label, " + 
                              " SUM(pi.price * pi.quantity) AS total_amount " + 
                              "FROM payment_items pi " +
                              "JOIN book b ON pi.title = b.title " +  // title을 기준으로 JOIN
                              "WHERE TO_CHAR(pi.sale_date, 'YYYY-MM-DD') = TO_CHAR(SYSDATE, 'YYYY-MM-DD') " +  // 오늘 날짜 필터링
                              "GROUP BY b.category " + 
                              "ORDER BY total_amount DESC"; 
            pstmt = conn.prepareStatement(sqlDaily); 
            rs = pstmt.executeQuery(); 
            boolean first = true; 
            while(rs.next()) { 
                if(!first) { 
                    dailyLabels.append(","); 
                    dailyData.append(","); 
                } 
                dailyLabels.append("'").append(rs.getString("label")).append("'"); 
                dailyData.append(rs.getDouble("total_amount")); 
                dailyTotalAmount += rs.getDouble("total_amount"); // 일간 총매출 합산
                first = false; 
            } 
            rs.close(); 
            pstmt.close(); 
            
            // 📌 월별 매출 계산
            String sqlMonthly = "SELECT TO_CHAR(pi.sale_date, 'YYYY-MM') AS label, " + 
                                " SUM(pi.price * pi.quantity) AS total_amount " + 
                                "FROM payment_items pi " + 
                                "GROUP BY TO_CHAR(pi.sale_date, 'YYYY-MM') " + 
                                "ORDER BY label"; 
            pstmt = conn.prepareStatement(sqlMonthly); 
            rs = pstmt.executeQuery(); 
            first = true; 
            while(rs.next()) { 
                if(!first) { 
                    monthlyLabels.append(","); 
                    monthlyData.append(","); 
                } 
                monthlyLabels.append("'").append(rs.getString("label")).append("'"); 
                monthlyData.append(rs.getDouble("total_amount")); 
                first = false; 
            } 
            rs.close(); 
            pstmt.close(); 

            // 📌 연도별 매출 계산
            String sqlYearly = "SELECT TO_CHAR(pi.sale_date, 'YYYY') AS label, " + 
                               " SUM(pi.price * pi.quantity) AS total_amount " + 
                               "FROM payment_items pi " + 
                               "GROUP BY TO_CHAR(pi.sale_date, 'YYYY') " + 
                               "ORDER BY label"; 
            pstmt = conn.prepareStatement(sqlYearly); 
            rs = pstmt.executeQuery(); 
            first = true; 
            while(rs.next()) { 
                if(!first) { 
                    yearlyLabels.append(","); 
                    yearlyData.append(","); 
                } 
                yearlyLabels.append("'").append(rs.getString("label")).append("'"); 
                yearlyData.append(rs.getDouble("total_amount")); 
                yearlyTotalAmount += rs.getDouble("total_amount"); // 연간 총매출 합산
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
            daily: { 
                labels: [<%= dailyLabels.toString() %>], 
                data: [<%= dailyData.toString() %>] 
            }, 
            monthly: { 
                labels: [<%= monthlyLabels.toString() %>], 
                data: [<%= monthlyData.toString() %>] 
            }, 
            yearly: { 
                labels: [<%= yearlyLabels.toString() %>], 
                data: [<%= yearlyData.toString() %>] 
            } 
        };

        // 일간, 연간 총매출 표시
        document.getElementById('dailyTotalAmount').innerText = <%= dailyTotalAmount %>;
        document.getElementById('yearlyTotalAmount').innerText = <%= yearlyTotalAmount %>;

        function loadChart(type) { 
            const ctx = document.getElementById('salesChart').getContext('2d'); 
            const labels = chartData[type].labels; 
            const values = chartData[type].data; 
            if(chart) chart.destroy(); 
            
            let chartConfig = {
                type: 'doughnut', // 기본 차트는 도넛 차트 (일별)
                data: {
                    labels: labels,
                    datasets: [{
                        label: `책별 ${type} 판매량`,
                        data: values,
                        backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40'],
                        hoverBackgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40']
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: { display: true }
                    }
                }
            };

            if (type !== 'daily') { // 일별이 아니면
                chartConfig.type = 'bar'; // 기본 차트는 막대 차트 (월별, 연도별)
                chartConfig.data.datasets = [
                    {
                        label: `책별 ${type} 판매량 (막대)`,
                        data: values,
                        backgroundColor: 'rgba(54, 162, 235, 0.6)',
                    },
                    {
                        label: `책별 ${type} 판매량 (꺾은선)`,
                        data: values,
                        fill: false,
                        borderColor: 'rgba(75, 192, 192, 1)',
                        tension: 0.1,
                        type: 'line',
                    }
                ];
            }

            // 차트 생성
            chart = new Chart(ctx, chartConfig);
        }

        // 초기 실행: 일별 차트 로드
        loadChart('daily'); 
    </script> 
</main> 
<%@ include file="footer.jsp" %> 
</body> 
</html>
