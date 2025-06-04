<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>へるすっち</title>
  <link rel="icon" href="GRAPHICS/favicon1.ico">
  <link href="top.css" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
</head>
<body>
  <div class="container">
    <!-- タイトルロゴ画像（中央上部）-->
    <img src="GRAPHICS/toplogo1.png" alt="へるすっち" class="character">
 
<div class="login-container">
  <h2>ログイン</h2>

  <form action="Login" method="post">
  <div class="form-group">
    <label for="U_ID">ユーザーID</label>
    <input type="text" id="U_ID" name="U_ID"
           value="<%= request.getAttribute("U_ID") != null ? request.getAttribute("U_ID") : "" %>"
           >
    <div id="form-message"></div>
  </div>

  <div class="form-group">
  <label for="U_PASS">パスワード</label>
  <input type="password" id="U_PASS" name="U_PASS" required>
	</div>
	
	<!-- ✅ エラーメッセージをここに移動 -->
	<div class="message">
	  <%
	    String error = (String)request.getAttribute("error");
	    if (error != null) {
	      out.print(error.replaceAll("\n", "<br>"));
	    } else {
	      out.print("&nbsp;");
	    }
	  %>
	</div>
	
	<!-- ログインボタン -->
	<button type="submit">ログイン</button>

  <div class="links">
    <a href="register.jsp" class="register-link">新規登録</a>
    <a href="changepw.jsp" class="forgot-U_PASS-link">パスワードを忘れた方はこちら</a>
  </div>
</div>
	
       
  </div>
  
  <script>
window.addEventListener('DOMContentLoaded', () => {
  const logo = document.querySelector('.character');

  // 効果音ファイルを読み込み
  const audio = new Audio('BGM/menuButton.mp3');  // ★ここに音ファイルパスを指定

  logo.addEventListener('click', () => {
    // 一回ジャンプアニメーションを付けて…
    logo.classList.add('jump');
    
    // 効果音を再生
    audio.currentTime = 0; // クリックするたび最初から再生
    audio.play();

    // アニメーション終了後クラスを外す（連続ジャンプできるように）
    logo.addEventListener('animationend', () => {
      logo.classList.remove('jump');
    }, { once: true });
  });
});
</script>
</body>
</html>