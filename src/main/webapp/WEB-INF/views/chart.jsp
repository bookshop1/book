<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, chart.*, chart.ChartService" %>
<%@ page import="org.springframework.web.context.WebApplicationContext"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils"%>

<%
	WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(application);
	ChartService chartService = ctx.getBean(ChartService.class);

    String[] categories = chartService.getCategories();

    Map<String,List<TopSalesDTO>> top5Map = chartService.getTopSalesMap();
    Map<String,List<TopScoreDTO>> scoreTop5Map = chartService.getTopScoreMap();
    int[] scoreCounts = chartService.getScoreCounts();
    ReviewAvgDTO reviewAvg = chartService.getReviewAvg();

    SalesDTO todaySales = chartService.getTodaySales();
    List<SalesDTO> dailySales = chartService.getDailySales();
    List<SalesDTO> monthlySales = chartService.getMonthlySales();
    List<SalesDTO> yearlySales = chartService.getYearlySales();
%>

<!DOCTYPE html>
<html>
<%@ include file="header.jsp" %>
<head>
    <meta charset="UTF-8">
    <title>책별 판매량/별점 통계</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<main class="container py-5">

<h2 class="mb-5 text-center">책별 판매량 통계</h2>

<!-- 일간, 연간 총매출 -->
<div class="row mb-4 text-center">
    <%
	    java.text.DecimalFormat df = new java.text.DecimalFormat("#,###");
	
	    String dailyTotal = todaySales != null ? df.format(todaySales.getTotalAmount()) : "0";
	    
	    int yearlyTotalInt = 0;
	    if(yearlySales != null){
	        for(SalesDTO y : yearlySales) yearlyTotalInt += y.getTotalAmount();
	    }
	    String yearlyTotal = df.format(yearlyTotalInt);
	%>
	
	<div class="col-md-6">
	    <h4>일간 총매출: <span id="dailyTotalAmount"><%= dailyTotal %></span> 원</h4>
	</div>
	<div class="col-md-6">
	    <h4>연간 총매출: <span id="yearlyTotalAmount"><%= yearlyTotal %></span> 원</h4>
	</div>
</div>

<div style="display: flex; flex-direction: column; gap: 20px; width: 100%;">

    <!-- 상단: 판매량 차트 + Top5 -->
    <div style="display: flex; gap: 20px; width: 100%;">
        <!-- 차트 -->
        <div class="chart-container" style="flex: 1; border: 2px solid #000; padding: 10px; height: 450px;">
            <div class="text-center mb-2">
                <button class="btn btn-primary mx-1" onclick="loadChart('daily')">일별</button>
                <button class="btn btn-success mx-1" onclick="loadChart('monthly')">월별</button>
                <button class="btn btn-warning mx-1" onclick="loadChart('yearly')">연도별</button>
            </div>
            <div class="text-center mb-2" id="monthSelectDiv" style="display:none;">
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
                    <% for(int m=1; m<=12; m++){ %>
                        <option value="<%= String.format("%02d", m) %>"><%= m %>월</option>
                    <% } %>
                </select>
            </div>
            <canvas id="salesChart" width="600" height="350"></canvas>
        </div>

        <!-- Top5 판매량 -->
        <div class="sales-top5" style="flex: 1; border: 2px solid #000; padding: 10px; height: 450px;">
            <h4>판매량 Top5 도서</h4>
            <div class="mb-2 text-center">
                <% for(String cat : categories){ %>
                    <button class="btn btn-sm mx-1" onclick="showTop5('<%=cat%>')"><%=cat%></button>
                <% } %>
            </div>
            <ul class="list-group" id="top5List">
                <% 
                    List<TopSalesDTO> list = top5Map.get("전체");
                    if(list != null){
                        for(TopSalesDTO t : list){ 
                %>
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <%= t.getTitle() %>
                        <span class="badge bg-primary rounded-pill"><%= t.getTotalQty() %></span>
                    </li>
                <% 
                        }
                    } 
                %>
            </ul>
        </div>
    </div>

    <!-- 하단: 별점 차트 + Top5 별점 -->
    <div style="display: flex; gap: 20px; width: 100%; margin-top: 20px;">
        <!-- 별점 차트 -->
        <div class="comments-container" style="flex:1; border:2px solid #000; padding:10px; height:450px;">
            <h4>전체 평균 별점</h4>
            <canvas id="scoreChart" width="600" height="350"></canvas>
            <div id="avgScoreText" style="margin-top:10px; font-size:24px; font-weight:bold;">
                전체 평균: <%= reviewAvg != null ? reviewAvg.getAvgScore() : 0 %>/5 (<%= reviewAvg != null ? reviewAvg.getReviewCount() : 0 %>개 리뷰)
            </div>
        </div>

        <!-- Top5 별점 -->
        <div class="score-top5" style="flex:1; border:2px solid #000; padding:10px; height:450px;">
            <h4>별점 Top5 도서</h4>
            <div class="mb-2 text-center">
                <% for(String cat : categories){ %>
                    <button class="btn btn-sm mx-1" onclick="showTop5Score('<%=cat%>')"><%=cat%></button>
                <% } %>
            </div>
            <ul class="list-group" id="top5ScoreList">
                <% 
                    List<TopScoreDTO> ratingList = scoreTop5Map.get("전체");
                    if(ratingList != null){
                        for(TopScoreDTO t : ratingList){
                            int fullStars = (int)t.getAvgScore();
                            boolean halfStar = (t.getAvgScore() - fullStars) >= 0.5;
                            int emptyStars = 5 - fullStars - (halfStar ? 1 : 0);
                            StringBuilder stars = new StringBuilder();
                            for(int i=0;i<fullStars;i++) stars.append("★");
                            if(halfStar) stars.append("☆");
                            for(int i=0;i<emptyStars;i++) stars.append("☆");
                %>
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <%= t.getTitle() %>
                        <span>
                            <span style="color: gold; font-size:18px;"><%= stars %></span>
                            (<%= t.getAvgScore() %>/5, 리뷰 <%= t.getReviewCount() %>개)
                        </span>
                    </li>
                <% 
                        }
                    } 
                %>
            </ul>
        </div>
    </div>
</div>

<script>
    // Chart.js 데이터
    const chartData = {
        daily: { labels: [<%
            for(int i=0;i<dailySales.size();i++){ out.print("'" + dailySales.get(i).getLabel() + "'"); if(i<dailySales.size()-1) out.print(","); } %>],
            data: [<% for(int i=0;i<dailySales.size();i++){ out.print(dailySales.get(i).getTotalAmount()); if(i<dailySales.size()-1) out.print(","); } %>]
        },
        monthly: { labels: [<% for(int i=0;i<monthlySales.size();i++){ out.print("'" + monthlySales.get(i).getLabel() + "'"); if(i<monthlySales.size()-1) out.print(","); } %>],
            data: [<% for(int i=0;i<monthlySales.size();i++){ out.print(monthlySales.get(i).getTotalAmount()); if(i<monthlySales.size()-1) out.print(","); } %>]
        },
        yearly: { labels: [<% for(int i=0;i<yearlySales.size();i++){ out.print("'" + yearlySales.get(i).getLabel() + "'"); if(i<yearlySales.size()-1) out.print(","); } %>],
            data: [<% for(int i=0;i<yearlySales.size();i++){ out.print(yearlySales.get(i).getTotalAmount()); if(i<yearlySales.size()-1) out.print(","); } %>]
        }
    };

    const top5Data = {};
    <% for(String cat : categories){ %>
        top5Data["<%=cat%>"] = [
        <% 
            List<TopSalesDTO> saleList = top5Map.get(cat);
            if(saleList != null){
                for(int i=0;i<saleList.size();i++){
                    TopSalesDTO dto = saleList.get(i);
                    out.print("'"+dto.getTitle()+" ("+dto.getTotalQty()+")'");
                    if(i<saleList.size()-1) out.print(",");
                }
            }
        %>
        ];
    <% } %>

    const scoreTop5Data = {};
    <% for(String cat : categories){ %>
        scoreTop5Data["<%=cat%>"] = [
        <% 
            List<TopScoreDTO> scoreList = scoreTop5Map.get(cat);
            if(scoreList != null){
                for(int i=0;i<scoreList.size();i++){
                    TopScoreDTO dto = scoreList.get(i);
                    // "제목|평균별점|리뷰수"
                    out.print("'" + dto.getTitle() + "|" + dto.getAvgScore() + "|" + dto.getReviewCount() + "'");
                    if(i < scoreList.size()-1) out.print(",");
                }
            }
        %>
        ];
    <% } %>
    console.log(scoreTop5Data);

    // 판매량 차트
    const ctx = document.getElementById('salesChart').getContext('2d');
    let salesChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: chartData.daily.labels,
            datasets: [{
                label: '총 매출',
                data: chartData.daily.data,
                backgroundColor: 'rgba(75, 192, 192, 0.7)'
            }]
        },
        options: { responsive:false, maintainAspectRatio:false }
    });

    function loadChart(type){
        salesChart.data.labels = chartData[type].labels;
        salesChart.data.datasets[0].data = chartData[type].data;
        salesChart.update();
        document.getElementById('monthSelectDiv').style.display = (type==='monthly') ? 'block':'none';
    }

    function showTop5(category){
        const list = top5Data[category];
        const ul = document.getElementById("top5List");
        ul.innerHTML = "";
        if(list && list.length > 0){
            list.forEach(item => {
                const parts = item.split("(");
                const title = parts[0].trim();
                const qty = parts[1].replace(")","").trim();

                const li = document.createElement("li");
                li.className = "list-group-item d-flex justify-content-between align-items-center";
                li.textContent = title;

                const span = document.createElement("span");
                span.className = "badge bg-primary rounded-pill";
                span.textContent = qty + "권";

                li.appendChild(span);
                ul.appendChild(li);
            });
        } else {
            ul.innerHTML = "<li class='list-group-item text-center'>데이터 없음</li>";
        }
    }

    function showTop5Score(category){
    	console.log("Clicked category:", category);
        const list = scoreTop5Data[category];
        const ul = document.getElementById("top5ScoreList");
        ul.innerHTML = "";

        if(list && list.length > 0){
            list.forEach(item => {
                const parts = item.split("|");
                const title = parts[0].trim();
                const score = parseFloat(parts[1]);
                const reviews = parseInt(parts[2]);

                let fullStars = Math.floor(score);
                let halfStar = (score - fullStars) >= 0.5;
                let emptyStars = 5 - fullStars - (halfStar ? 1 : 0);

                let stars = "";
                for(let i=0;i<fullStars;i++) stars += "★";
                if(halfStar) stars += "☆";
                for(let i=0;i<emptyStars;i++) stars += "☆";

                const li = document.createElement("li");
                li.className = "list-group-item d-flex justify-content-between align-items-center";
                li.innerHTML = title + 
                    '<span><span style="color: gold; font-size: 18px;">' + stars + 
                    '</span> (' + score.toFixed(1) + '/5, 리뷰 ' + reviews + '개)</span>';

                ul.appendChild(li);
            });
        } else {
            ul.innerHTML = "<li class='list-group-item text-center'>데이터 없음</li>";
        }
    }

    function filterMonthYear(){
        const year = document.getElementById('yearSelect').value;
        const month = document.getElementById('monthSelect').value;
        const data = chartData.monthly;
        const labels = [];
        const values = [];
        for(let i=0;i<data.labels.length;i++){
            if((!year || data.labels[i].startsWith(year)) && (!month || data.labels[i].split("-")[1]===month)){
                labels.push(data.labels[i]);
                values.push(data.data[i]);
            }
        }
        salesChart.data.labels = labels;
        salesChart.data.datasets[0].data = values;
        salesChart.update();
    }
    
    const scoreCtx = document.getElementById('scoreChart').getContext('2d');
    const scoreChart = new Chart(scoreCtx, {
        type: 'bar',
        data: {
            labels: ['1점', '2점', '3점', '4점', '5점'],
            datasets: [{
                label: '별점 개수',
                data: [<%= scoreCounts != null ? scoreCounts[0] : 0 %>,
                       <%= scoreCounts != null ? scoreCounts[1] : 0 %>,
                       <%= scoreCounts != null ? scoreCounts[2] : 0 %>,
                       <%= scoreCounts != null ? scoreCounts[3] : 0 %>,
                       <%= scoreCounts != null ? scoreCounts[4] : 0 %>],
                backgroundColor: 'rgba(255, 206, 86, 0.7)',
                borderColor: 'rgba(255, 206, 86, 1)',
                borderWidth: 1
            }]
        },
        options: {
            responsive: false,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: { stepSize: 1 }
                }
            }
        }
    });
    
    
</script>
</main>
  <%@ include file="footer.jsp" %>
</body>
</html>
