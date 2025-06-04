<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, javax.servlet.*" %>
<%@ page import="bean.User" %>
<%@ include file="userCheck.jspf" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>食事管理</title>
    <link rel="icon" href="GRAPHICS/favicon1.ico">
    <link rel="stylesheet" href="food.css">
    <link href="https://fonts.googleapis.com/css2?family=Kosugi+Maru&display=swap" rel="stylesheet">
    <script type="text/javascript" src="food.js"></script>
</head>
<body>
    <!-- ホームボタン -->
    <div class="home-button">
        <a href="<%= request.getContextPath() %>/Home"><img src="GRAPHICS/homebutton.png" alt="ホーム"></a>
    </div>

    <!-- 分類ボタン -->
    <div class="category-buttons">
        <button><img src="GRAPHICS/all.png" alt="すべて" id="all" onclick="clickClassId(event)"></button>
        <button><img src="GRAPHICS/syusyoku.png" alt="主食" id="主食" onclick="clickClassId(event)"></button>
        <button><img src="GRAPHICS/okazu.png" alt="おかず" id="おかず" onclick="clickClassId(event)"></button>
        <button><img src="GRAPHICS/oyatsu.png" alt="おやつ" id="おやつ" onclick="clickClassId(event)"></button>
        <button><img src="GRAPHICS/other.png" alt="その他" id="その他" onclick="clickClassId(event)"></button>
    </div>
 
    <!-- 検索フォーム -->
    <div class="search-form">
        
            <input type="text" id="searchInput" onkeydown="enterSearch()" placeholder="料理名 or 食材名を入力">
            <button type="button" onclick="searchMenu()">検索する</button>
        
    </div>

    <!-- 仮の料理データ表示 -->
    <div class="dish-table">
	    <div class="table-scroll-wrapper">
	        <table>
	            <thead>
    <tr>
        <th>登録日時</th>  <!-- ←ここを「登録日時」にちゃんと直す！ -->
        <th>料理名</th>
        <th>ジャンル</th>
        <th>摂取カロリー</th>
        <th>食材</th>
        <th>分量</th>
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
        <img class="banner-image" src="GRAPHICS/foodtag.png" alt="食事管理バナー">
    </div>
    <div class="buttons-container">
        <button id="listOrDataId"><img src="GRAPHICS/history_or_menu.png" alt="履歴/メニュー切替"></button>
        <button id="addModalBtn"><img src="GRAPHICS/menuadd.png" alt="新メニューを追加する"></button>
        <button id="openModalBtn"><img src="GRAPHICS/foodadd.png" alt="食べた食事を登録する"></button>
    </div>
</div>
    
 	<!-- 確実画面のポップアップ -->
<div id="foodModal" class="modal">
  <div class="modal-content">
    <span class="close-btn">&times;</span>
    
    <h2>確認画面</h2>
    
	    <div class="dish-table">
		    <div class="table-scroll-wrapper">
		        <table>
		            <thead>
					    <tr>
					    	<th>削除</th>
					        <th>料理名</th>
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

  <!-- 新規メニュー登録ポップアップ -->
<div id="addModal" class="modal">
  <div class="modal-content form-modal">
    <span class="close-btn">&times;</span>
    <h2>オリジナルメニュー登録</h2>

    <form id="addMenuForm">
      <div class="form-group">
        <label for="mName">メニュー名</label>
        <input type="text" id="mName" required>
      </div>

      <div class="form-group">
        <label for="mCal">カロリー（kcal）</label>
        <input type="number" id="mCal" required>
      </div>

      <div class="form-group">
        <label for="mMate">食材</label>
        <input type="text" id="mMate" required>
      </div>

      <div class="form-group">
        <label for="class">ジャンル</label>
        <select id="class" required>
          <option value="" disabled selected>ジャンルを選択</option>
          <option value="主食">主食</option>
          <option value="おかず">おかず</option>
          <option value="おやつ">おやつ</option>
          <option value="その他">その他</option>
        </select>
      </div>

      <div class="form-group">
        <label for="mExpl">分量（〇〇あたり）</label>
        <input type="text" id="mExpl" required>
      </div>

      <div id="addMenuError" class="error-message"></div>

      <div class="form-buttons">
        <button type="button" id="addMenu" class="register-button">登録</button>
        <button type="button" id="addCloseModal" class="register-button cancel-button">閉じる</button>
      </div>
    </form>

  </div>
</div>

<!-- 登録確認の画面（ポップアップ） -->
<div class="modal-content" id="addConfimat">
    
    <h1>登録確認画面。</h1><br><br>
    
    <div class="dish-table">
	    <div class="table-scroll-wrapper">
	        <table>
	            <thead>
				    <tr>
				        <th>料理名</th>
				        <th>カロリー</th>
				        <th>食材</th>
				        <th>ジャンル</th>
				        <th>分量</th>
				    </tr>
			 	</thead>
			 	<tr>
      				<tbody id="confimatMenu"></tbody>
				</tr>
	        </table>
	        
	    </div>
    </div>
    
    <h2>登録しますか？</h2>
    <button id="addFixed" class="register-button">登録確定</button>
    <button id="addBack" class="register-button">戻る</button>
    
</div>

<!-- 登録完了の画面（ポップアップ） -->
<div class="modal-content form-modal" id="addreged">
    <div class="success-icon">✔️</div>
    <h2>登録完了しました！</h2>
    <p>メニューが正常に追加されました。</p>
    
    <div class="form-buttons">
        <button id="addClose" class="register-button">閉じる</button>
    </div>
</div>

</body>
</html>