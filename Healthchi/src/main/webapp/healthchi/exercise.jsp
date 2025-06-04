<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>運動管理</title>
    <link rel="icon" href="GRAPHICS/favicon1.ico">
    <link rel="stylesheet" href="exercise.css">
    <link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">

</head>
<body>
    <!-- ホームボタン -->
    <div class="home-button">
        <a href="<%= request.getContextPath() %>/Home"><img src="GRAPHICS/homebutton.png" alt="ホーム"></a>
    </div>

    <!-- 分類ボタン -->
    <div class="category-buttons">
        <button><img src="GRAPHICS/all.png" alt="すべて" id="all" onclick="clickClassId(event)"></button>
        <button><img src="GRAPHICS/exercise.png" alt="日常生活" id="日常生活" onclick="clickClassId(event)"></button>
        <button><img src="GRAPHICS/exercise_person.png" alt="運動:個人" id="運動:個人" onclick="clickClassId(event)"></button>
        <button><img src="GRAPHICS/exercise_team.png" alt="運動:チーム" id="運動:チーム" onclick="clickClassId(event)"></button>
    </div>

    <!-- 検索フォーム -->
    <div class="search-form">
        <input type="text" id="searchInput" onkeydown="enterSearch()" placeholder="運動名を入力">
            <button type="button" onclick="searchMenu()">検索する</button>
    </div>

    <!-- 仮の運動データ表示 -->
    <div class="dish-table">
      <div class="table-scroll-wrapper">
          <table>
              <thead>
                  <tr>
                  <th>追加</th>
                      <th>運動名</th>
                      <th>ジャンル</th>
                      <th>消費カロリー</th>
                      <th>運動の説明</th>
                      
                  </tr>
              </thead>
               <!-- ここに検索結果の表が出る -->
              <tbody id="resultTable">

              </tbody>
          </table>
      </div>
    </div>

   <!-- ▼バナーとボタンを別要素に -->
<div class="bottom-area">
  <div class="banner-container">
    <img class="banner-image" src="GRAPHICS/exercisetag.png" alt="運動管理バナー">
  </div>
  <div class="buttons-container">
    <button id="listOrDataId"><img src="GRAPHICS/history_or_menu.png" alt="履歴/メニュー切替"></button>
    <button id="openModalBtn"><img src="GRAPHICS/exerciseadd.png" alt="行った運動を登録する"></button>
  </div>
</div>

    <!-- 確実画面のポップアップ -->
<div id="exerModal" class="modal">
  <div class="modal-content">
    <span class="close-btn">&times;</span>

    <h2>確認画面</h2>

      <div class="dish-table">
        <div class="table-scroll-wrapper">
            <table>
                <thead>
              <tr>
              <th>削除</th>
                  <th>運動名</th>
                      <th>カロリー</th>
                  
              </tr>
           </thead>
              <tbody id="cartTable">

          </tbody>
          <td colspan="3">
            <div id = "caltable"></div>
          </td>
            </table>

        </div>
      </div>

       <div id=modalerror></div>
        <button id="registerCart" class="register-button">登録</button>

  </div>
</div>
<!-- 登録完了の画面（ポップアップ） -->
<div class="modal-content" id="rateModal">

    <h1>登録完了しました。</h1>
    <h1><div id = "rateTable"></div></h1>

    <h1><div id = "rating"></div></h1>
    <h1><div id = "nowCal"></div></h1>
    <button id="close" class="register-button">登録を続ける</button>
    <form action="<%= request.getContextPath() %>/Home" method="get">
  <button class="register-button">ホームに戻る</button>
</form>
</div>


    <script type="text/javascript" src="exercise.js"></script>
</body>
</html>
