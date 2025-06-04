<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, dao.*, bean.*" %>
<%@ include file="userCheck.jspf" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>履歴一括表示</title>
<link rel="icon" href="GRAPHICS/favicon1.ico">
<link rel="stylesheet" href="history.css">
<link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

<%
  // 年月取得
  int year = request.getParameter("year") != null ? Integer.parseInt(request.getParameter("year")) : Calendar.getInstance().get(Calendar.YEAR);
  int month = request.getParameter("month") != null ? Integer.parseInt(request.getParameter("month")) : Calendar.getInstance().get(Calendar.MONTH) + 1;

  int prevMonth = month - 1, nextMonth = month + 1;
  int prevYear = year, nextYear = year;
  if (prevMonth < 1) { prevMonth = 12; prevYear--; }
  if (nextMonth > 12) { nextMonth = 1; nextYear++; }

  Calendar cal = Calendar.getInstance();
  cal.set(year, month - 1, 1);
  int daysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

  // ★セッションからログインユーザーIDを取得
// この行は削除してください。すでにuserは定義済みです
// User user = (User) session.getAttribute("user");
String userId = user.getU_ID(); // これはOK

  // DAO呼び出しによるデータ取得
  Map<Integer, Double> weightMap = new WeightDAO().getWeightMapByMonth(userId, year, month);
  Map<Integer, Double> intakeMap = new Menu_DataDAO().getIntakeMapByMonth(userId, year, month);
  Map<Integer, Double> burnMap = new Exer_DataDAO().getBurnMapByMonth(userId, year, month);

  Calendar today = Calendar.getInstance();
  int todayYear = today.get(Calendar.YEAR);
  int todayMonth = today.get(Calendar.MONTH) + 1;
  int todayDate = today.get(Calendar.DAY_OF_MONTH);

  // グラフ用データを日数分生成
  List<String> dayLabels = new ArrayList<>();
  List<String> weightValues = new ArrayList<>();
  List<String> intakeValues = new ArrayList<>();
  List<String> burnValues = new ArrayList<>();

  for (int d = 1; d <= daysInMonth; d++) {
    dayLabels.add("\"" + d + "\"");
    weightValues.add(weightMap.containsKey(d) ? weightMap.get(d).toString() : "null");
    intakeValues.add(intakeMap.containsKey(d) ? intakeMap.get(d).toString() : "null");
    burnValues.add(burnMap.containsKey(d) ? burnMap.get(d).toString() : "null");
  }
%>

<!-- ホームボタン -->
<div class="home-button">
  <a href="<%= request.getContextPath() %>/Home"><img src="GRAPHICS/homebutton.png" alt="ホーム"></a>
</div>

<!-- 月移動ボタン -->
<div class="category-buttons">
  <a href="?year=<%= prevYear %>&month=<%= prevMonth %>"><button><img src="GRAPHICS/prev.png" alt="前月"></button></a>
  <a href="?year=<%= Calendar.getInstance().get(Calendar.YEAR) %>&month=<%= Calendar.getInstance().get(Calendar.MONTH) + 1 %>"><button><img src="GRAPHICS/current.png" alt="今月に戻る"></button></a>
  <a href="?year=<%= nextYear %>&month=<%= nextMonth %>"><button><img src="GRAPHICS/next.png" alt="次月"></button></a>
</div>

<!-- 表形式ビュー -->
<div id="tableView" class="dish-table">
  <div class="table-scroll-wrapper">
    <table class="calendar-table">
      <thead>
        <tr><th colspan="4" class="calendar-title"><%= year %>年 <%= month %>月の記録</th></tr>
        <tr><th>日付</th><th>体重（kg）</th><th>摂取カロリー（kcal）</th><th>消費カロリー（kcal）</th></tr>
      </thead>
      <tbody>
        <%
          for (int d = 1; d <= daysInMonth; d++) {
            boolean isToday = (year == todayYear && month == todayMonth && d == todayDate);
            out.println("<tr" + (isToday ? " class='today'" : "") + ">");
            out.println("<td>" + d + "日</td>");
            out.println("<td>" + (weightMap.getOrDefault(d, null) != null ? weightMap.get(d) : "") + "</td>");
            out.println("<td>" + (intakeMap.getOrDefault(d, null) != null ? intakeMap.get(d) : "") + "</td>");
            out.println("<td>" + (burnMap.getOrDefault(d, null) != null ? burnMap.get(d) : "") + "</td>");
            out.println("</tr>");
          }
        %>
      </tbody>
    </table>
  </div>
</div>

<!-- グラフビュー -->
<div id="graphView" class="dish-table" style="display: none;">
  <div class="table-scroll-wrapper">
    <h2 class="calendar-title"><%= year %>年 <%= month %>月の記録（グラフ）</h2>
    <canvas id="weightChart"></canvas>
  </div>
</div>

<!-- ▼バナーとボタンを別要素に -->
<div class="bottom-area">
  <div class="banner-container">
    <img class="banner-image" src="GRAPHICS/historytag.png" alt="履歴バナー">
  </div>
  <div class="buttons-container">
    <button id="showTable"><img src="GRAPHICS/mesabutton.png" alt="表形式"></button>
    <button id="showGraph"><img src="GRAPHICS/graphbutton.png" alt="グラフ表示"></button>
  </div>
</div>

<!-- Chart.jsグラフ描画 -->
<script>
  document.addEventListener("DOMContentLoaded", function () {
    const tableView = document.getElementById("tableView");
    const graphView = document.getElementById("graphView");
    const showTableBtn = document.getElementById("showTable");
    const showGraphBtn = document.getElementById("showGraph");

    showTableBtn.addEventListener("click", () => {
      tableView.style.display = "block";
      graphView.style.display = "none";
    });

    showGraphBtn.addEventListener("click", () => {
      tableView.style.display = "none";
      graphView.style.display = "block";
    });

    const ctx = document.getElementById('weightChart').getContext('2d');
    new Chart(ctx, {
      type: 'line',
      data: {
        labels: [<%= String.join(",", dayLabels) %>],
        datasets: [{
          label: '体重（kg）',
          data: [<%= String.join(",", weightValues) %>],
          borderColor: 'rgba(255, 152, 0, 1)',
          fill: false,
          tension: 0.3,
          spanGaps: true,
          yAxisID: 'y1'
        }, {
          label: '摂取カロリー（kcal）',
          data: [<%= String.join(",", intakeValues) %>],
          borderColor: 'rgba(0, 255, 0, 1)',
          fill: false,
          tension: 0.3,
          spanGaps: true,
          yAxisID: 'y2'
        }, {
          label: '消費カロリー（kcal）',
          data: [<%= String.join(",", burnValues) %>],
          borderColor: 'rgba(255, 0, 0, 1)',
          fill: false,
          tension: 0.3,
          spanGaps: true,
          yAxisID: 'y2'
        }]
      },
      options: {
        responsive: true,
        animation: false,
        scales: {
          y1: {
            type: 'linear',
            position: 'left',
            title: { display: true, text: '体重（kg）' }
          },
          y2: {
            type: 'linear',
            position: 'right',
            title: { display: true, text: 'カロリー（kcal）' },
            grid: { drawOnChartArea: false }
          }
        }
      }
    });
  });
</script>

</body>
</html>
