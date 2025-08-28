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

    <!-- 일간, 연간 총매출 -->
    <div class="row mb-4 text-center">
        <div class="col-md-6">
            <h4>일간 총매출: <span id="dailyTotalAmount">로딩중...</span> 원</h4>
        </div>
        <div class="col-md-6">
            <h4>연간 총매출: <span id="yearlyTotalAmount">로딩중...</span> 원</h4>
        </div>
    </div>

    <!-- 차트 전환 버튼 -->
    <div class="mb-4 text-center">
        <button class="btn btn-primary mx-1" onclick="loadChart('daily')">일별</button>
        <button class="btn btn-success mx-1" onclick="loadChart('monthly')">월별</button>
        <button class="btn btn-warning mx-1" onclick="loadChart('yearly')">연도별</button>
    </div>

    <!-- 연도 + 월 선택 드롭다운 -->
    <div class="mb-3 text-center" id="monthSelectDiv" style="display:none;">
        <label for="yearSelect">연도 선택: </label>
        <select id="yearSelect" class="form-select d-inline-block w-auto" onchange="filterMonthYear()">
            <option value="">전체</option>
            <option value="2023">2023년</option>
            <option value="2024">2024년</option>
            <option value="2025">2025년</option>
        </select>

        <label for="monthSelect" class="ms-3">월 선택: </label>
        <select id="monthSelect" class="form-select d-inline-block w-auto" onchange="filterMonthYear()">
            <option value="">전체</option>
            <option value="01">1월</option>
            <option value="02">2월</option>
            <option value="03">3월</option>
            <option value="04">4월</option>
            <option value="05">5월</option>
            <option value="06">6월</option>
            <option value="07">7월</option>
            <option value="08">8월</option>
            <option value="09">9월</option>
            <option value="10">10월</option>
            <option value="11">11월</option>
            <option value="12">12월</option>
        </select>
    </div>

    <canvas id="salesChart" width="1000" height="500"></canvas>

    <%
        String jdbcUrl = "jdbc:oracle:thin:@localhost:1521:xe";
        String dbUser = "night";
        String dbPass = "night";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        StringBuilder dailyLabels = new StringBuilder();
        StringBuilder dailyData = new StringBuilder();
        StringBuilder monthlyLabels = new StringBuilder();
        StringBuilder monthlyData = new StringBuilder();
        StringBuilder yearlyLabels = new StringBuilder();
        StringBuilder yearlyData = new StringBuilder();

        double dailyTotalAmount = 0;
        double yearlyTotalAmount = 0;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPass);

            // 일별 매출
            String sqlDaily = "SELECT b.category AS label, SUM(pi.price * pi.quantity) AS total_amount " +
                    "FROM payment_items pi JOIN book b ON pi.title = b.title " +
                    "WHERE TO_CHAR(pi.sale_date,'YYYY-MM-DD') = TO_CHAR(SYSDATE,'YYYY-MM-DD') " +
                    "GROUP BY b.category ORDER BY total_amount DESC";
            pstmt = conn.prepareStatement(sqlDaily);
            rs = pstmt.executeQuery();
            boolean first = true;
            while(rs.next()){
                if(!first){
                    dailyLabels.append(",");
                    dailyData.append(",");
                }
                dailyLabels.append("'").append(rs.getString("label")).append("'");
                dailyData.append(rs.getDouble("total_amount"));
                dailyTotalAmount += rs.getDouble("total_amount");
                first = false;
            }
            rs.close();
            pstmt.close();

            // 월별 매출
            String sqlMonthly = "SELECT TO_CHAR(pi.sale_date,'YYYY-MM') AS label, SUM(pi.price * pi.quantity) AS total_amount " +
                    "FROM payment_items pi GROUP BY TO_CHAR(pi.sale_date,'YYYY-MM') ORDER BY label";
            pstmt = conn.prepareStatement(sqlMonthly);
            rs = pstmt.executeQuery();
            first = true;
            while(rs.next()){
                if(!first){
                    monthlyLabels.append(",");
                    monthlyData.append(",");
                }
                monthlyLabels.append("'").append(rs.getString("label")).append("'");
                monthlyData.append(rs.getDouble("total_amount"));
                first = false;
            }
            rs.close();
            pstmt.close();

            // 연도별 매출
            String sqlYearly = "SELECT TO_CHAR(pi.sale_date,'YYYY') AS label, SUM(pi.price * pi.quantity) AS total_amount " +
                    "FROM payment_items pi GROUP BY TO_CHAR(pi.sale_date,'YYYY') ORDER BY label";
            pstmt = conn.prepareStatement(sqlYearly);
            rs = pstmt.executeQuery();
            first = true;
            while(rs.next()){
                if(!first){
                    yearlyLabels.append(",");
                    yearlyData.append(",");
                }
                yearlyLabels.append("'").append(rs.getString("label")).append("'");
                yearlyData.append(rs.getDouble("total_amount"));
                yearlyTotalAmount += rs.getDouble("total_amount");
                first = false;
            }
        } catch(Exception e){
            out.println("<p class='text-danger'>DB 오류: "+e.getMessage()+"</p>");
        } finally {
            try{if(rs!=null)rs.close();}catch(Exception ignore){}
            try{if(pstmt!=null)pstmt.close();}catch(Exception ignore){}
            try{if(conn!=null)conn.close();}catch(Exception ignore){}
        }
    %>

    <script>
        let chart;
        const chartData = {
            daily: { labels: [<%= dailyLabels.toString() %>], data: [<%= dailyData.toString() %>] },
            monthly: { labels: [<%= monthlyLabels.toString() %>], data: [<%= monthlyData.toString() %>] },
            yearly: { labels: [<%= yearlyLabels.toString() %>], data: [<%= yearlyData.toString() %>] }
        };

        // 천 단위 콤마 표시
        document.getElementById('dailyTotalAmount').innerText = <%= dailyTotalAmount %>.toLocaleString();
        document.getElementById('yearlyTotalAmount').innerText = <%= yearlyTotalAmount %>.toLocaleString();

        function loadChart(type){
            const ctx = document.getElementById('salesChart').getContext('2d');
            let labels = [...chartData[type].labels];
            let values = [...chartData[type].data];

            const monthSelectDiv = document.getElementById('monthSelectDiv');
            if(type==='monthly'){
                monthSelectDiv.style.display='block';
                document.getElementById('monthSelect').value="";
                document.getElementById('yearSelect').value="";
                filterMonthYear(); // 초기 전체 월별 차트
                return;
            } else {
                monthSelectDiv.style.display='none';
            }

            if(type==='daily' || type==='yearly'){
                if(chart) chart.destroy();
                const chartConfig = {
                    type: type==='daily'?'doughnut':'bar',
                    data: {
                        labels: labels,
                        datasets: type==='daily'? [{
                            label: `책별 ${type} 판매량`,
                            data: values,
                            backgroundColor: ['#FF6384','#36A2EB','#FFCE56','#4BC0C0','#9966FF','#FF9F40'],
                            borderColor:'#fff',
                            borderWidth:1
                        }] : [
                            {
                                label: `책별 ${type} 판매량 (막대)`,
                                data: values,
                                backgroundColor:'rgba(54,162,235,0.6)'
                            },
                            {
                                label: `책별 ${type} 판매량 (꺾은선)`,
                                data: values,
                                fill:false,
                                borderColor:'rgba(75,192,192,1)',
                                tension:0.1,
                                type:'line'
                            }
                        ]
                    },
                    options:{responsive:true, plugins:{legend:{display:true}}}
                };
                chart = new Chart(ctx, chartConfig);
            }
        }

        function filterMonthYear(){
            const selectedYear = document.getElementById('yearSelect').value;
            const selectedMonth = document.getElementById('monthSelect').value;

            const labels = [];
            const values = [];

            chartData['monthly'].labels.forEach((label,i)=>{
                const [yearPart, monthPart] = label.split('-');
                if((!selectedYear || yearPart===selectedYear) && (!selectedMonth || monthPart===selectedMonth)){
                    labels.push(label);
                    values.push(chartData['monthly'].data[i]);
                }
            });

            if(chart) chart.destroy();
            const ctx = document.getElementById('salesChart').getContext('2d');
            chart = new Chart(ctx,{
                type:'bar',
                data:{
                    labels:labels,
                    datasets:[
                        {
                            label:'책별 월별 판매량 (막대)',
                            data:values,
                            backgroundColor:'rgba(54,162,235,0.6)'
                        },
                        {
                            label:'책별 월별 판매량 (꺾은선)',
                            data:values,
                            fill:false,
                            borderColor:'rgba(75,192,192,1)',
                            tension:0.1,
                            type:'line'
                        }
                    ]
                },
                options:{responsive:true, plugins:{legend:{display:true}}}
            });
        }

        // 초기 차트: 일별
        loadChart('daily');
    </script>
</main>
<%@ include file="footer.jsp" %>
</body>
</html>
