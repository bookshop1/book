<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
double avgScore = 0;
int totalReviews = 0;
int[] scoreCounts = new int[5];

//전체 판매량 Top5
List<Map<String,Object>> overallSalesTop5 = new ArrayList<>();

// 모든 카테고리 Top5 가져오기
String[] categories = {"전체", "essay", "humanities", "novel", "health", "economy"};
Map<String,List<String>> top5Map = new HashMap<>();
Map<String,List<String>> scoreTop5Map = new HashMap<>();
try{
    Class.forName("oracle.jdbc.driver.OracleDriver");
    conn = DriverManager.getConnection(jdbcUrl,dbUser,dbPass);

    for(String cat : categories){
        List<String> list = new ArrayList<>();
        String sql;
        if("전체".equals(cat)){
            sql = "SELECT * FROM (SELECT b.title, SUM(pi.quantity) AS total_qty " +
                  "FROM book b JOIN payment_items pi ON b.title = pi.title " +
                  "GROUP BY b.title ORDER BY total_qty DESC) WHERE ROWNUM <= 5";
            pstmt = conn.prepareStatement(sql);
        } else {
            sql = "SELECT * FROM (SELECT b.title, SUM(pi.quantity) AS total_qty " +
                  "FROM book b JOIN payment_items pi ON b.title = pi.title " +
                  "WHERE b.category=? GROUP BY b.title ORDER BY total_qty DESC) WHERE ROWNUM <= 5";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, cat);
        }
        rs = pstmt.executeQuery();
        while(rs.next()){
            list.add(rs.getString("title") + " (" + rs.getInt("total_qty") + ")");
        }
        top5Map.put(cat, list);
        rs.close(); pstmt.close();
    }
    
    String sqlScore = "SELECT score, COUNT(*) AS cnt FROM comments GROUP BY score ORDER BY score";
    pstmt = conn.prepareStatement(sqlScore);
    rs = pstmt.executeQuery();
    while(rs.next()){
        int score = rs.getInt("score");
        int count = rs.getInt("cnt");
        if(score >=1 && score <=5){
        	scoreCounts[score-1] = count;
            totalReviews += count;
            avgScore += score * count;
        }
    }
    if(totalReviews > 0) avgScore = Math.round((avgScore/totalReviews)*10)/10.0;
    
    rs.close();
    pstmt.close();
    
    
    String sqlReview = "SELECT ROUND(AVG(score),2) AS avg_score, COUNT(*) AS review_count FROM comments";
    pstmt = conn.prepareStatement(sqlReview);
    rs = pstmt.executeQuery();
    if(rs.next()){
        avgScore = rs.getDouble("avg_score");
        totalReviews = rs.getInt("review_count");
    }
    rs.close();
	pstmt.close();

    
    for (String cat : categories) {
        List<String> list = new ArrayList<>();
        String sql;

        if ("전체".equals(cat)) {
            sql = "SELECT * FROM (" +
                  "SELECT b.title, ROUND(AVG(c.score),2) AS avg_score, COUNT(c.score) AS review_count " +
                  "FROM book b JOIN comments c ON b.b_id = c.b_id " +
                  "GROUP BY b.title ORDER BY avg_score DESC" +
                  ") WHERE ROWNUM <= 5";
            pstmt = conn.prepareStatement(sql);
        } else {
            sql = "SELECT * FROM (" +
                  "SELECT b.title, ROUND(AVG(c.score),2) AS avg_score, COUNT(c.score) AS review_count " +
                  "FROM book b JOIN comments c ON b.b_id = c.b_id " +
                  "WHERE b.category = ? " +
                  "GROUP BY b.title ORDER BY avg_score DESC" +
                  ") WHERE ROWNUM <= 5";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, cat);
        }

        rs = pstmt.executeQuery();
        while (rs.next()) {
        	list.add(rs.getString("title") + "|" + rs.getDouble("avg_score") + "|" + rs.getInt("review_count"));
        }
        scoreTop5Map.put(cat, list);
        rs.close();
        pstmt.close();
    }
    
    rs.close();
    pstmt.close();
    conn.close();
    
} catch(Exception e){ e.printStackTrace(); }

%>

<!DOCTYPE html>
<html>
<%@ include file="header.jsp" %>
<head>
    <meta charset="UTF-8">
    <title>책별 판매량 차트</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
    
	 // JSP에서 생성한 top5Map을 JS 객체로 변환
	    const top5Data = {};
	    <% for(String cat : categories){ %>
	        top5Data["<%=cat%>"] = [
	        <% 
	            List<String> list = top5Map.get(cat);
	            if(list != null){
	                for(int i=0;i<list.size();i++){
	                    out.print("'"+list.get(i)+"'");
	                    if(i<list.size()-1) out.print(",");
	                }
	            }
	        %>
	        ];
	    <% } %>
	    
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
	</script>
	
	<script>
	function showTop5Score(category){
	    var scoreMap = {
	        <% 
	            for(String cat : categories){ 
	                List<String> slist = scoreTop5Map.get(cat);
	                if(slist != null){ 
	        %>
	        "<%=cat%>": [
	            <% for(int i=0; i<slist.size(); i++){ %>
	                "<%=slist.get(i)%>"<%= (i < slist.size()-1 ? "," : "") %>
	            <% } %>
	        ]<%= (cat.equals(categories[categories.length-1]) ? "" : ",") %>
	        <% 
	                }
	            } 
	        %>
	    };

	    var list = scoreMap[category];
	    var ul = document.getElementById("top5ScoreList");
	    ul.innerHTML = "";

	    if(list){
	        list.forEach(function(item){
	        	var parts = item.split("|");
	        	var title = parts[0].trim();
	        	var score = parseFloat(parts[1].trim());
	        	var reviews = parseInt(parts[2].trim());

	        	// 별점 변환
	        	var fullStars = Math.floor(score);
	        	var halfStar = (score - fullStars) >= 0.5;
	        	var emptyStars = 5 - fullStars - (halfStar ? 1 : 0);

	        	var stars = "";
	        	for(var i=0; i<fullStars; i++) stars += "★";
	        	if(halfStar) stars += "☆";
	        	for(var i=0; i<emptyStars; i++) stars += "☆";

	        	var li = document.createElement("li");
	        	li.className = "list-group-item d-flex justify-content-between align-items-center";
	        	li.innerHTML = title + 
	        	    '<span><span style="color: gold; font-size: 18px;">' + stars + 
	        	    '</span> (' + score + '/5, 리뷰 ' + reviews + '개)</span>';
	        	ul.appendChild(li);
	        });
	    } else {
	        ul.innerHTML = "<li class='list-group-item'>데이터 없음</li>";
	    }
	}

	</script>
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
    
    <!-- 전체 컨테이너 -->
    <div style="display: flex; flex-direction: column; gap: 20px; width: 100%;">
    
    <!-- 상단 박스 -->
    <div style="display: flex; gap: 20px; width: 100%;">

		<div class="chart-container" style="display: flex; flex-direction: column; align-items: center; flex: 1; justify-content: space-between; 
									border: 2px solid #000; padding: 10px; box-sizing: border-box; height: 450px">

	        <div style="width: 100%;">
		        <div class="chart-buttons" style="text-align: center; margin-bottom: 5px;">
		            <button class="btn btn-primary mx-1" onclick="loadChart('daily')">일별</button>
		            <button class="btn btn-success mx-1" onclick="loadChart('monthly')">월별</button>
		            <button class="btn btn-warning mx-1" onclick="loadChart('yearly')">연도별</button>
		        </div>
		
		        <div class="month-select text-center" id="monthSelectDiv" style="display:none; margin-bottom: 0;">
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
		    </div>
	        <div style="width: 100%; display: flex; justify-content: center;">
		        <canvas id="salesChart" width="600" height="350"></canvas>
		    </div>
	    </div>
	    
	    <div class="sales-top5" style="flex: 1;  border: 2px solid #000; padding: 10px; box-sizing: border-box; display: flex; 
		    									flex-direction: column; align-items: center; justify-content: flex-start; height: 450px;">
	            <h4>판매량 Top5 도서</h4>
	            <div class="mb-3 text-center" style="margin-top: 10px;">
				    <button class="btn btn-primary btn-sm mx-1" onclick="showTop5('전체')">전체 Top5</button>
				    <button class="btn btn-info btn-sm mx-1" onclick="showTop5('essay')">에세이</button>
				    <button class="btn btn-warning btn-sm mx-1" onclick="showTop5('humanities')">인문</button>
				    <button class="btn btn-success btn-sm mx-1" onclick="showTop5('novel')">소설</button>
				    <button class="btn btn-danger btn-sm mx-1" onclick="showTop5('health')">건강</button>
				    <button class="btn btn-secondary btn-sm mx-1" onclick="showTop5('economy')">경제</button>
				</div>

			    <div class="card" style="flex: 1; width: 100%; margin-top: 20px;">

			        <ul class="list-group" id="top5List">
				        <!-- 초기값: 전체 Top5 -->
				        <%
				            List<String> list = top5Map.get("전체");
				            if(list != null){
				                for(String item : list){
				                    String[] parts = item.split("\\(");
				                    String title = parts[0].trim();
				                    String qty = parts[1].replace(")","").trim();
				        %>
				        <li class="list-group-item d-flex justify-content-between align-items-center">
				            <%=title%>
				            <span class="badge bg-primary rounded-pill"><%=qty%></span>
				        </li>
				        <%
				                }
				            }
				        %>
				    </ul>
			    </div>
	        </div>
	    </div>
	</div>

    
    <!-- 하단 박스 -->
    <div style="display: flex; gap: 20px; width: 100%; margin-top: 20px;">

		<div class="comments-container" style="display: flex; flex-direction: column; align-items: center; 
                                     flex: 1; justify-content: flex-start; border: 2px solid #000; 
                                     padding: 10px; box-sizing: border-box; height: 450px;">

	        <h4>전체 평균 별점</h4>
	        <canvas id="scoreChart"></canvas>
			<div id="avgScoreText" style="margin-top: 10px; font-size: 24px; font-weight: bold;"></div>
		</div>
		    
	    <div class="score-top5" style="flex: 1; border: 2px solid #000; padding: 10px; box-sizing: border-box; display: flex; 
	                               flex-direction: column; align-items: center; justify-content: flex-start; height: 450px;">
	    <h4>별점 Top5 도서</h4>
	    <div style="margin-top: 10px;">
	        <button class="btn btn-primary btn-sm mx-1" onclick="showTop5Score('전체')">전체 Top5</button>
	        <button class="btn btn-info btn-sm mx-1" onclick="showTop5Score('essay')">에세이</button>
	        <button class="btn btn-warning btn-sm mx-1" onclick="showTop5Score('humanities')">인문</button>
	        <button class="btn btn-success btn-sm mx-1" onclick="showTop5Score('novel')">소설</button>
	        <button class="btn btn-danger btn-sm mx-1" onclick="showTop5Score('health')">건강</button>
	        <button class="btn btn-secondary btn-sm mx-1" onclick="showTop5Score('economy')">경제</button>
	    </div>
	    
	    <div class="card" style="flex: 1; width: 100%; margin-top: 20px;">
	        <ul class="list-group" id="top5ScoreList">
				<%
				    List<String> ratingList = scoreTop5Map.get("전체");
				    if(ratingList != null){
				        for(String item : ratingList){
				            String[] parts = item.split("\\|"); // title | avg_score | review_count
				            String title = parts[0].trim();
				            double score = Double.parseDouble(parts[1].trim());
				            int reviews = Integer.parseInt(parts[2].trim());
				
				            int fullStars = (int)score;
				            boolean halfStar = (score - fullStars) >= 0.5;
				            int emptyStars = 5 - fullStars - (halfStar ? 1 : 0);
				
				            StringBuilder stars = new StringBuilder();
				            for(int i=0;i<fullStars;i++) stars.append("★");
				            if(halfStar) stars.append("☆");
				            for(int i=0;i<emptyStars;i++) stars.append("☆");
				%>
				<li class="list-group-item d-flex justify-content-between align-items-center">
				    <%=title%>
				    <span>
				        <span style="color: gold; font-size: 18px;"><%=stars.toString()%></span>
				        (<%= (int)Math.round(score) %>/5, 리뷰 <%=reviews%>개)
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

    <%
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		    conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPass);
		    
		    String sqlToday = "SELECT SUM(pi.price * pi.quantity) AS total_amount " +
	                  "FROM payment_items pi " +
	                  "WHERE TRUNC(pi.sale_date) = TRUNC(SYSDATE)";
			pstmt = conn.prepareStatement(sqlToday);
			rs = pstmt.executeQuery();
			if(rs.next()){
			    dailyTotalAmount = rs.getDouble("total_amount");
			}
			rs.close();
			pstmt.close();
	    
            // 일별 매출
            String sqlDailyAll = "SELECT TO_CHAR(pi.sale_date,'YY/MM/DD') AS label, SUM(pi.price * pi.quantity) AS total_amount " +
                     "FROM payment_items pi " +
                     "GROUP BY TO_CHAR(pi.sale_date,'YY/MM/DD') " +
                     "ORDER BY label";
			pstmt = conn.prepareStatement(sqlDailyAll);
			rs = pstmt.executeQuery();
            boolean first = true;
            while(rs.next()){
                if(!first){
                    dailyLabels.append(",");
                    dailyData.append(",");
                }
                dailyLabels.append("'").append(rs.getString("label")).append("'");
                dailyData.append(rs.getDouble("total_amount"));
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

           

        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            if(rs != null) rs.close();
            if(pstmt != null) pstmt.close();
            if(conn != null) conn.close();
        }
    %>

    <script>
    document.getElementById('dailyTotalAmount').innerText = <%= dailyTotalAmount %>.toLocaleString();
    document.getElementById('yearlyTotalAmount').innerText = <%= yearlyTotalAmount %>.toLocaleString();
    let chart;

    // daily, monthly, yearly 데이터 (JSP 변수로부터)
    const chartData = {
        daily: { labels: [<%= dailyLabels.toString() %>], data: [<%= dailyData.toString() %>] },
        monthly: { labels: [<%= monthlyLabels.toString() %>], data: [<%= monthlyData.toString() %>] },
        yearly: { labels: [<%= yearlyLabels.toString() %>], data: [<%= yearlyData.toString() %>] }
    };

    // 초기 차트: 일별
    window.onload = function() {
        loadChart('daily');
    };

    function loadChart(type){
        const ctx = document.getElementById('salesChart').getContext('2d');
        let labels = [...chartData[type].labels];
        let values = [...chartData[type].data];

        const monthSelectDiv = document.getElementById('monthSelectDiv');
        if(type === 'monthly'){
            monthSelectDiv.style.display = 'block';
            document.getElementById('monthSelect').value = "";
            document.getElementById('yearSelect').value = "";
            filterMonthYear(); // 초기 전체 월별 차트
            return;
        } else {
            monthSelectDiv.style.display = 'none';
        }

        if(chart) chart.destroy();

        chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: `${type} 판매량`,
                    data: values,
                    backgroundColor: 'rgba(54, 162, 235, 0.6)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: { y: { beginAtZero: true } }
            }
        });
    }

    // 년월 선택 시 해당 월의 일별 판매량 표시
    function filterMonthYear() {
        const selectedYear = parseInt(document.getElementById('yearSelect').value, 10);
        const selectedMonth = parseInt(document.getElementById('monthSelect').value, 10);

        const labels = [];
        const values = [];

        chartData['daily'].labels.forEach((label, i) => {
            const parts = label.split('/'); // YY/MM/DD
            let yearPart = parseInt(parts[0]);
            if(yearPart < 100) yearPart += 2000; // 25 -> 2025
            const monthPart = parseInt(parts[1]);

            if(yearPart === selectedYear && monthPart === selectedMonth){
                labels.push(label);
                values.push(chartData['daily'].data[i]);
            }
        });

        if(labels.length === 0){
            labels.push("데이터 없음");
            values.push(0);
        }

        if(chart) chart.destroy();

        const ctx = document.getElementById('salesChart').getContext('2d');
        chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: `${selectedYear}년 ${selectedMonth}월 일별 판매량`,
                    data: values,
                    backgroundColor: 'rgba(54, 162, 235, 0.6)'
                }]
            },
            options: {
                responsive: true,
                scales: { y: { beginAtZero: true } }
            }
        });
    }
</script>





<script>
    const ctx = document.getElementById('scoreChart').getContext('2d');

    const scoreCounts = [
        <%=scoreCounts[0]%>,
        <%=scoreCounts[1]%>,
        <%=scoreCounts[2]%>,
        <%=scoreCounts[3]%>,
        <%=scoreCounts[4]%>
    ];

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['1점', '2점', '3점', '4점', '5점'],
            datasets: [{
                label: '별점 개수',
                data: scoreCounts,
                backgroundColor: 'rgba(255, 206, 86, 0.7)',
                borderColor: 'rgba(255, 206, 86, 1)',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function(context){
                            return context.dataset.label + ": " + context.raw + "개";
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        stepSize: 1
                    }
                }
            }
        }
    });
    
    const avgScore = <%=avgScore%>;
    const totalReviews = <%=totalReviews%>;
    document.getElementById('avgScoreText').innerText = "전체 평균: " + avgScore + "/5 (" + totalReviews + "개 리뷰)";
</script>
</main>
<%@ include file="footer.jsp" %>
</body>
</html>
