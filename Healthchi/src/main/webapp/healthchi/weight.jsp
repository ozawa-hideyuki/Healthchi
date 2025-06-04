<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="dao.WeightDAO" %>
<%@ include file="userCheck.jspf" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>体重管理</title>
  <link rel="icon" href="GRAPHICS/favicon1.ico">
  <link rel="stylesheet" href="weight.css">
  <link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<!-- なぜかグラフの表示はこっちじゃないとうまくいきません -->
<style>
  .graph-scroll-wrapper {
    max-height: 60vh;
    overflow-y: auto;
    overflow-x: hidden;
    scrollbar-color: #ffe5b4 #fff3e0;
    scrollbar-width: thin;
    background-image: url('GRAPHICS/frame.png');
    background-size: cover;
    background-position: center;
    border-radius: 15px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    padding: 2vh;
    width: 80%;
    margin: 0 auto;
  }

  .graph-scroll-wrapper::-webkit-scrollbar {
    width: 8px;
  }

  .graph-scroll-wrapper::-webkit-scrollbar-thumb {
    background-color: #ffe5b4;
    border-radius: 4px;
  }

  .graph-scroll-wrapper::-webkit-scrollbar-track {
    background-color: #fff3e0;
  }

  .graph-title {
    /* ← 固定解除！ */
    background-color: #ffe0b2;
    font-weight: bold;
    font-size: clamp(16px, 1.8vw, 20px);
    color: #471906;
    border-bottom: 2px solid #e0a96d;
    text-align: center;
    padding: 1.2vh;
    width: 95%;
    margin: 0 auto 1vh auto;
    box-sizing: border-box;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
  }

  .chart-wrapper {
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 1vh 1vw;
    text-align: center;
  }

  #weightChart {
    width: 80% !important;
    height: auto !important;
  }
</style>


</head>
<body>

<!-- 以下省略（以前のコードと同様） -->

<!-- 以下省略（以前のコードと同様） -->


  <!-- ホームボタン -->
  <div class="home-button">
        <a href="<%= request.getContextPath() %>/Home"><img src="GRAPHICS/homebutton.png" alt="ホーム"></a>
    </div>

  <%
    int year = request.getParameter("year") != null ? Integer.parseInt(request.getParameter("year")) : Calendar.getInstance().get(Calendar.YEAR);
    int month = request.getParameter("month") != null ? Integer.parseInt(request.getParameter("month")) : Calendar.getInstance().get(Calendar.MONTH) + 1;

    Calendar cal = Calendar.getInstance();
    cal.set(year, month - 1, 1);
    int startDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
    int daysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

    int prevMonth = month - 1, nextMonth = month + 1;
    int prevYear = year, nextYear = year;
    if (prevMonth < 1) { prevMonth = 12; prevYear--; }
    if (nextMonth > 12) { nextMonth = 1; nextYear++; }
	
    // サンプルデータ
    /*
    Map<Integer, Double> weightMap = new TreeMap<>();
    weightMap.put(1, 55.2);
    weightMap.put(3, 54.9);
    weightMap.put(6, 55.1);
    weightMap.put(15, 54.6);
    weightMap.put(20, 54.3);
    */
    Map<Integer, Double> weightMap = new HashMap<>();
    try{
    if(user == null) {
    	 // テスト用の仮ログイン処理（本番では削除またはコメントアウト）
    	user = new User();
        user.setU_ID("test123");
        user.setU_NAME("テストユーザー");
        user.setU_RATINGVALUE(5); // ← 必要に応じて進化段階など設定
        session.setAttribute("user", user);
    } 
    
    
    WeightDAO dao = new WeightDAO(); 
    
    weightMap = dao.getWeightMapByMonth(user.getU_ID(), year, month);

    }catch(Exception e) {
    	e.printStackTrace();
    }
    Calendar today = Calendar.getInstance();
    int todayYear = today.get(Calendar.YEAR);
    int todayMonth = today.get(Calendar.MONTH) + 1;
    int todayDate = today.get(Calendar.DAY_OF_MONTH);
  %>

  <!-- 月移動ボタン -->
  <div class="category-buttons">
    <a href="?year=<%=prevYear%>&month=<%=prevMonth%>"><button><img src="GRAPHICS/prev.png" alt="前月"></button></a>
    <a href="?year=<%=Calendar.getInstance().get(Calendar.YEAR)%>&month=<%=Calendar.getInstance().get(Calendar.MONTH) + 1%>"><button><img src="GRAPHICS/current.png" alt="今月に戻る"></button></a>
    <a href="?year=<%=nextYear%>&month=<%=nextMonth%>"><button><img src="GRAPHICS/next.png" alt="次月"></button></a>
  </div>

  <!-- カレンダー -->
  <div class="dish-table" id="calendarArea">
    <div class="table-scroll-wrapper">
      <table class="calendar-table">
        <thead>
          <tr><th colspan="7" class="calendar-title"><%= year %>年 <%= month %>月の体重記録</th></tr>
          <tr><th>日</th><th>月</th><th>火</th><th>水</th><th>木</th><th>金</th><th>土</th></tr>
        </thead>
        <tbody>
          <%
            int day = 1;
            boolean started = false;
            for (int week = 0; week < 6; week++) {
              out.println("<tr>");
              for (int dow = 1; dow <= 7; dow++) {
                if (!started && dow == startDayOfWeek) started = true;
                if (started && day <= daysInMonth) {
                  boolean isToday = (year == todayYear && month == todayMonth && day == todayDate);
                  out.print("<td" + (isToday ? " class='today'" : "") + ">");
                  out.print(day);
                  if (weightMap.containsKey(day)) {
                    out.print("<br>" + weightMap.get(day) + "kg");
                  }
                  out.println("</td>");
                  day++;
                } else {
                  out.print("<td></td>");
                }
              }
              out.println("</tr>");
              if (day > daysInMonth) break;
            }
          %>
        </tbody>
      </table>
    </div>
  </div>

<!-- グラフエリア（非表示） -->
<div id="graphArea" style="display: none;">
  <div class="graph-scroll-wrapper">
    <div class="graph-title"><%= year %>年 <%= month %>月の記録（グラフ）</div>
    <div class="chart-wrapper">
      <canvas id="weightChart"></canvas>
    </div>
  </div>
</div>


<!-- ▼バナーとボタンを別要素に -->
<div class="bottom-area">
  <div class="banner-container">
    <img class="banner-image" src="GRAPHICS/weighttag.png" alt="体重管理バナー">
  </div>
  <div class="buttons-container">
    <button id="toggleView"><img src="GRAPHICS/cal_or_graph.png" alt="カレンダー/グラフ切替"></button>
    <button id="openModalBtn"><img src="GRAPHICS/weightadd.png" alt="今日の体重を登録する"></button>
  </div>
</div>


  <!-- モーダルポップアップ -->
  <div id="weightModal" class="modal">
    <div class="modal-content">
      <span class="close-btn">&times;</span>
      <h2>今日の体重を登録</h2>
      
        
        <label for="weight">体重（kg）(範囲:0.0~999.9)：</label>
        <input type="number" id="weight" step="0.1" min="0" max="999.9" required><br><br>
        
        <div id="error" ></div>
       <button id="addBtn">登録</button>
      
    </div>
  </div>
  
  <!-- 登録完了の画面（ポップアップ） -->
<div id="added" class="modal">
	<div class="modal-content">
    
    <h1>登録完了しました。</h1>
    
    <button id="addClose">閉じる</button>
    </div>
</div> 	

  <!-- JavaScript -->
  <script>
    document.addEventListener("DOMContentLoaded", function () {
      const modal = document.getElementById("weightModal");
      const openBtn = document.getElementById("openModalBtn");
      const closeBtn = document.querySelector(".close-btn");
      const calendar = document.getElementById("calendarArea");
      const graph = document.getElementById("graphArea");
      const toggleBtn = document.getElementById("toggleView");
      const addModal = document.getElementById("added");

      openBtn.addEventListener("click", () => modal.style.display = "block");
      closeBtn.addEventListener("click", () => modal.style.display = "none");
      
            

      toggleBtn.addEventListener("click", function () {
        if (calendar.style.display !== "none") {
          calendar.style.display = "none";
          graph.style.display = "block";
          drawGraph();
        } else {
          calendar.style.display = "block";
          graph.style.display = "none";
        }
      });

      function drawGraph() {
    	    const ctx = document.getElementById("weightChart").getContext("2d");

    	    const totalDays = <%= daysInMonth %>; // 月の日数（JSPで受け取り済み）
    	    
    	    // ラベル（日付 1〜月末）
    	    const labels = [];
    	    for (let i = 1; i <= totalDays; i++) {
    	        labels.push(i.toString());
    	    }

    	    // データ（登録されてる日だけ値、それ以外はnull）
    	    const rawData = {
    	      <% for (Map.Entry<Integer, Double> entry : weightMap.entrySet()) { %>
    	          <%= entry.getKey() %>: <%= entry.getValue() %>,
    	      <% } %>
    	    };

    	    const data = labels.map(day => rawData[day] ?? null); // dayがなければnull

    	    new Chart(ctx, {
    	        type: "line",
    	        data: {
    	            labels: labels,
    	            datasets: [{
    	                label: "体重（kg）",
    	                data: data,
    	                borderColor: "rgba(255, 152, 0, 1)",
    	                backgroundColor: "rgba(255, 152, 0, 0.1)",
    	                fill: false,
    	                tension: 0.3,
    	                spanGaps: true // ← これを指定するとnullが飛ばされて線がきれいに繋がります
    	            }]
    	        },
    	        options: {
    	            responsive: true,
    	            maintainAspectRatio: true,
    	            scales: {
    	                y: {
    	                    beginAtZero: false,
    	                    title: {
    	                        display: true,
    	                        text: "体重（kg）"
    	                    }
    	                }
    	            }
    	        }
    	    });
      }

      // URLのクエリパラメータを取得
      const urlParams = new URLSearchParams(window.location.search);
	
	 
	let toggle = urlParams.get("toggle");
	console.log("toggle=", toggle);
	//toggleがString型として見られているため"true"で判定
	//上のconsole.logでString型に変えられているかも
	if(toggle === "true" || toggle === null){
	  console.log("カレンダー");
	  calendar.style.display = "block";
	  graph.style.display = "none";
	}else{
	  console.log("グラフ");
	  calendar.style.display = "none";
	  graph.style.display = "block";
	  drawGraph();
	}
      
      
    document.getElementById("addBtn").addEventListener("click", addWeight);
    async function addWeight() {
        const weight = parseFloat(document.getElementById("weight").value); // 入力値を取得し、浮動小数点に変換
        const resultElement = document.getElementById("error");
		console.log(weight);
        // 範囲判定
        if (weight >= 0.0 && weight <= 999.9) {
            const regex = /^[0-9]+(\.[0-9]{1})?$/;
            if(regex.test(weight)){
	        	response = await fetch('addWeight?weight=' + encodeURIComponent(weight) );
	  			if (response.ok) {
	  				let text = await response.text();   
	  				if(text){
		    		addModal.style.display = "block";
	  				}else{
	  					resultElement.textContent = "エラー：SQLエラーが発生しました。";
						throw new Error(`HTTPエラー: ${response.status}`);
		  			}
	  				
	  			}else{
	    			resultElement.textContent = "エラー：実行エラーが発生しました。";
					throw new Error(`HTTPエラー: ${response.status}`);
				} 
			
  			}else {
  	            resultElement.textContent = "小数点以下は1桁までです。";
  	        }
        } else {
            resultElement.textContent = "入力された値は範囲外です。";
        }
    }
    
    const addCloBtn = document.getElementById("addClose");
    console.log(addCloBtn);
	addCloBtn.addEventListener("click", function () {
		console.log("addClose");
		
		const tdisplay = window.getComputedStyle(calendar).display;
		if(tdisplay === "block"){
			toggle = true;
		}else{
			toggle = false;	
		}
		
      	window.location.href = "weight.jsp?toggle=" + encodeURIComponent(toggle);
    });

});
  </script>

</body>
</html>
