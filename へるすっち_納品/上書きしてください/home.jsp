<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="bean.CharacterInfo" %>
<%@ page import="bean.User" %>
<%@ include file="userCheck.jspf" %>
<%
  String msg = (String) request.getAttribute("randomMessage");
  if (msg == null) msg = "むにゃむにゃ…";

  CharacterInfo info = (CharacterInfo) request.getAttribute("characterInfo");
  String basePath = request.getContextPath() + "/healthchi/";

  String characterImage = basePath + "CHARAimage/default.png";
  if (info != null && info.getImagePath() != null) {
    characterImage = basePath + info.getImagePath();
  }
  String effectImage = (info != null && info.getEffectPath() != null) ? basePath + info.getEffectPath() : null;

  String settingMessage = (String) session.getAttribute("settingMessage");
  if (settingMessage != null) {
    session.removeAttribute("settingMessage");  // 一度表示したら消す
  }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>へるすっち</title>
  <link rel="icon" href="<%= basePath %>GRAPHICS/favicon1.ico">
  <link rel="stylesheet" href="<%= basePath %>home.css">
  <link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
</head>
<body>
<audio id="bgm" autoplay loop>
  <source src="BGM/088_long_BPM130.mp3" type="audio/mp3">
</audio>

<div class="container">

  <!-- 吹き出し -->
  <div class="speech-wrapper">
    <img src="<%= basePath %>GRAPHICS/fukidashi.png" alt="吹き出し" class="speech-img">
    <div class="speech-text"><%= msg %></div>
  </div>

  <!-- キャラクター -->
  <img src="<%= characterImage %>" alt="キャラ" class="character">

  <!-- エフェクト -->
  <% if (effectImage != null) { %>
    <img src="<%= effectImage %>" alt="エフェクト" class="effect" id="effect">
  <% } %>

  <!-- HPバー -->
  <%
  String hpBarPath = (String) request.getAttribute("hpBarPath");
%>
<div class="hp-bar">
  <img src="<%= basePath %><%= hpBarPath %>" alt="HPバー">
</div>

  <!-- メニュー -->
  <div class="button-area">
    <form onsubmit="return playMenuSound(this)" action="<%= basePath %>weight.jsp"><button class="img-button"><img src="<%= basePath %>GRAPHICS/weightbutton.png" alt="体重"></button></form>
    <form onsubmit="return playMenuSound(this)" action="<%= basePath %>food.jsp"><button class="img-button"><img src="<%= basePath %>GRAPHICS/foodbutton.png" alt="食事"></button></form>
    <form onsubmit="return playMenuSound(this)" action="<%= basePath %>exercise.jsp"><button class="img-button"><img src="<%= basePath %>GRAPHICS/exercisebutton.png" alt="運動"></button></form>
    <form onsubmit="return playMenuSound(this)" action="<%= basePath %>history.jsp"><button class="img-button"><img src="<%= basePath %>GRAPHICS/historybutton.png" alt="履歴"></button></form>
  </div>

  <!-- 歯車 -->
  <div class="settings-icon">
    <img src="<%= basePath %>GRAPHICS/settingbutton.png" alt="設定" onclick="toggleSettings()">
  </div>

  <!-- ポップアップ -->
  <div id="settings-popup" class="popup">
    <h3>設定</h3>

    <form method="post" action="<%= basePath %>updateSettings">
      <label>ユーザーID</label>
      <input type="text" value="<%= user.getU_ID() %>" disabled><br>

      <label>パスワード</label>
      <input type="password" name="password" placeholder="新しいパスワード" value="<%= user.getU_PASS() %>"><br>

      <label>ユーザー名</label>
      <input type="text" name="username" placeholder="新しいユーザー名" value="<%= user.getU_NAME() %>"><br>

      <input type="hidden" name="userId" value="<%= user.getU_ID() %>">

      <% if (settingMessage != null) { %>
        <div class="popup-message"><%= settingMessage %></div>
      <% } %>

      <div class="popup-buttons">
        <button type="submit">変更を保存</button>
        <button type="button" onclick="logout()">ログアウト</button>
      </div>
    </form>
  </div>

  <!-- 日時表示 -->
  <div class="datetime" id="datetime">
    <span id="year"></span>
    <span id="month"></span>
    <span id="day"></span>
    <span id="time"></span>
  </div>
  
  <audio id="jumpSound" src="<%= basePath %>BGM/charButton.mp3" preload="auto"></audio>
  <audio id="menuSound" src="<%= basePath %>BGM/PopupButton.mp3" preload="auto"></audio>

<script>
//ページ遷移を0.3秒遅らせて効果音をしっかり鳴らす
function playMenuSound(form) {
  const menuSound = document.getElementById("menuSound");
  if (menuSound) {
    menuSound.currentTime = 0;
    menuSound.play();
  }
  setTimeout(() => {
    form.submit();
  }, 100); // ← 必要に応じて500msなどに調整
  return false; // 通常のsubmitをキャンセル
}

document.addEventListener("DOMContentLoaded", () => {
  // ======== 時計の更新処理 ========
  function updateDateTime() {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hour = String(now.getHours()).padStart(2, '0');
    const minute = String(now.getMinutes()).padStart(2, '0');
    const weekdays = ["日", "月", "火", "水", "木", "金", "土"];
    const dayOfWeek = weekdays[now.getDay()];

    document.getElementById("year").textContent = year + "ねん";
    document.getElementById("month").textContent = month + "がつ";
    document.getElementById("day").textContent = day + "にち（" + dayOfWeek + "）";
    document.getElementById("time").textContent = hour + ":" + minute;
  }

  updateDateTime();
  setInterval(updateDateTime, 1000);

  // ======== 設定ポップアップ処理 ========
  document.addEventListener("click", function (event) {
    const popup = document.getElementById("settings-popup");
    const gear = document.querySelector(".settings-icon img");
    if (!popup.contains(event.target) && event.target !== gear) {
      popup.classList.remove("show");
    }
  });

  function toggleSettings() {
    const popup = document.getElementById("settings-popup");
    popup.classList.toggle("show");
  }
  window.toggleSettings = toggleSettings;

  function logout() {
    location.href = "<%= basePath %>Logout";
  }
  window.logout = logout; // ★これを追加！

  // ======== 設定フォームのバリデーション ========
  document.querySelector("form[action$='updateSettings']").addEventListener("submit", function (e) {
    const username = this.username.value.trim();
    const password = this.password.value.trim();

    if (!/^[a-zA-Z0-9]{4,8}$/.test(password)) {
      alert("パスワードは半角英数字4～8文字で入力してください。");
      e.preventDefault();
      return;
    }

    const len = Array.from(username).reduce((sum, char) =>
      sum + (escape(char).length > 4 ? 2 : 1), 0);

    if (len > 8) {
      alert("ユーザー名は全角4文字または半角8文字以内で入力してください。");
      e.preventDefault();
    }
  });

  // ======== キャラクタークリック時のぴょんぴょんジャンプ＋効果音 ========
  const character = document.querySelector(".character");
  const jumpSound = document.getElementById("jumpSound"); // 事前にaudioタグで読み込んでおく

  character.addEventListener("click", () => {
    // 効果音を再生
    if (jumpSound) {
      jumpSound.currentTime = 0;
      jumpSound.play();
    }

    // ぴょんぴょんアニメーション付与
    character.classList.add("jump-animation");

    // アニメ終了後クラス削除（1回だけ）
    character.addEventListener("animationend", () => {
      character.classList.remove("jump-animation");
    }, { once: true });
  });

//★メニュー効果音追加
  const menuSound = document.getElementById("menuSound");
  document.querySelectorAll(".img-button").forEach(button => {
    button.addEventListener("click", () => {
      if (menuSound) {
        menuSound.currentTime = 0;
        menuSound.play();
      }
    });
  });
});
</script>



</div>
</body>
</html>
