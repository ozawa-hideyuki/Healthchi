<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <title>へるすっち</title>
  <link rel="icon" href="GRAPHICS/favicon1.ico">
  <link href="register.css" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
</head>
<body>
  <div class="container">
    <!-- タイトルロゴ画像（中央上部）-->
    <img src="GRAPHICS/toplogo1.png" alt="へるすっち" class="character">

	<!-- ログインフォーム -->
<div class="login-container">
  <h2>新規登録</h2>


  <!-- スクロール可能なフォーム部分 -->
  <div class="form-scroll-area">
  </br>
    <form action="Register" method="post">
      <div class="form-group">
        <label for="U_ID">ユーザーID</label>
        <input type="text" id="U_ID" name="U_ID" 
        value="<%= request.getAttribute("U_ID") != null ? request.getAttribute("U_ID") : "" %>"
        required>
      </div>
      <div class="form-group">
        <label for="U_PASS">パスワード</label>
        <input type="password" id="U_PASS" name="U_PASS" required>
      </div>
      <div class="form-group">
        <label for="U_NAME">ニックネーム</label>
        <input type="text" id="U_NAME" name="U_NAME" required>
      </div>
      <div class="form-group">
        <label for="U_RATINGVALUE">目標摂取カロリー</label>
        <input type="number" id="U_GOALCAL" name="U_GOALCAL" required>
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

      <button type="submit">登録する</button>
           </br></br>
    </form>
  </div>

  <div class="links">
    <a href="top.jsp" class="register-link">ログイン画面に戻る</a>
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