//あいうえお
//ロードしたときに起動する機能その１
document.addEventListener("DOMContentLoaded", function () {
    const modal = document.getElementById("foodModal");
    modal.style.display = "none";
    const rModal = document.getElementById("rateModal");
    rModal.style.display = "none";
	const aModal = document.getElementById("addModal");
	aModal.style.display = "none";
	const conModal = document.getElementById("addConfimat");
	conModal.style.display = "none";
	const ardModal = document.getElementById("addreged");
	ardModal.style.display = "none";
	//確認画面表示ボタン
    const openBtn = document.getElementById("openModalBtn");
    
	openBtn.addEventListener("click", function () {
    	let ratetext = document.getElementById("modalerror");
        ratetext.innerHTML = "";
      	modal.style.display = "block";
      	cartList();
    });
	
	//✖ボタン全部の処理
	// 全ての閉じるボタンにイベントリスナーを追加
	document.querySelectorAll('.close-btn').forEach(btn => {
	    btn.addEventListener('click', function() {
	        const bmodal = this.parentElement.parentElement; // ボタンの親要素を取得
	        bmodal.style.display = 'none'; // 親要素を非表示にする
	    });
	});
	
	const lodBtn = document.getElementById("listOrDataId");
	lodBtn.addEventListener("click", function () {
	    listOrData = !listOrData; // ← ここでtrue/falseを反転させる！！
	    console.log("リスト/履歴モード切り替え:", listOrData ? "メニュー一覧" : "履歴");
	    document.getElementById("searchInput").value = ""; // 検索窓クリア
	    classId = "all"; // ジャンル初期化
	    searchMenu(); // 再検索
	});
	  //ポップアップを閉じるボタン
	  const continueBtn = document.getElementById("close");
	    
	     continueBtn.addEventListener("click", function () {
	         rModal.style.display = "none";
	         modal.style.display = "none";
	       });
	
	//カート登録するボタン＆登録メゾット（１０３行まで）
    const regcartBtn = document.getElementById("registerCart");

    regcartBtn.addEventListener("click", async function () {
		//cartが空の場合エラーを返す
		if(cart.length === 0){
			let ratetext = document.getElementById("modalerror");
	        ratetext.innerHTML = ""; // 既存データをクリア
	    	ratetext.textContent = "中身が空です。";
			}else{

		//更新前を事前に受け取る
		let response = await fetch('getRating');
        if (!response.ok) throw new Error(`HTTPエラー: ${response.status}`);
        let beforRating = parseInt(await response.text(), 10);
        
		//Menu_Dataに登録するjavaメゾット起動
		let params = new URLSearchParams();
   		cart.forEach(v => params.append("cart", v));
    	response = await fetch('registerCart?' + params.toString());
        if (!response.ok) throw new Error(`HTTPエラー: ${response.status}`);
        let afterRating = parseInt(await response.text(), 10);//
		//返ってきた評価値を受け取る
		
		//cartをリセット
		cart.length = 0;
		
		//評価値の前/後を表示
		rModal.style.display = "block";
		
		let changeRating = afterRating - beforRating;
		//
		if(changeRating != 0){
			let ratetext = document.getElementById("rateTable");
	        ratetext.innerHTML = ""; // 既存データをクリア
	    	ratetext.textContent = (changeRating > 0)? changeRating+"ポイント上がった。":(changeRating*-1) + "ポイント下がった。";
	    	let ratingtext = document.getElementById("rating");
	        ratingtext.innerHTML = ""; // 既存データをクリア
	    	ratingtext.innerHTML = "変更前⇒変更後<br>"+beforRating+"⇒"　+ afterRating;
		}
		console.log(beforRating);
		console.log(afterRating);
		console.log(changeRating);
		//"摂取/目標カロリーを表示
    	response = await fetch('getTodayCal');
        if (!response.ok) throw new Error(`HTTPエラー: ${response.status}`);
        let nowCal = parseInt(await response.text(), 10);
        response = await fetch('getGoalCal');
        if (!response.ok) throw new Error(`HTTPエラー: ${response.status}`);
        let golCal = parseInt(await response.text(), 10);
        
        let ratetext = document.getElementById("nowCal");
        ratetext.innerHTML = ""; // 既存データをクリア
    	ratetext.textContent = "摂取/目標(kcal)："+ nowCal + "/"+  golCal;
	}
    
    });

	//メニュー登録ボタン
	const menuRBtn = document.getElementById("addModalBtn");
	    
	    menuRBtn.addEventListener("click", function () {
	    	
	      console.log("addModal起動");
	      aModal.style.display = "block";
	     
	    });
	const addCloMBtn = document.getElementById("addCloseModal");
	    console.log(addCloMBtn);
		addCloMBtn.addEventListener("click", function () {
		console.log("addCloseModal");
		aModal.style.display = "none";
		let nameE = document.getElementById("mName");
		let calE = document.getElementById("mCal");
		let mateE = document.getElementById("mMate");
		let classE = document.getElementById("class");
		let explE = document.getElementById("mExpl");
		nameE.value = "";
		calE.value = "";
		mateE.value = "";
		classE.value = "";
		explE.value = "";
    });
		//メニュー登録ボタン
		const addMenuBtn = document.getElementById("addMenu");
			    
		    addMenuBtn.addEventListener("click", function () {
			    	
	        console.log("addMenu押下");
			addMenu();
		});
		
	const addCloBtn = document.getElementById("addClose");
	    console.log(addCloBtn);
		addCloBtn.addEventListener("click", function () {
			console.log("addClose");
			
			aModal.style.display = "none";
	      	conModal.style.display = "none";
			ardModal.style.display = "none";
    });
	
  });
//メニュー/履歴の保存値
let listOrData;//真…Menu,偽…Menu_Data
//ジャンルの保存値
let classId;
//カートの保存値
let cart = [];

let sumCal;
//ロードしたときに起動する機能その２
window.onload = initialize;

function initialize(){
	console.log("onload");
	classId = "all";
	listOrData = true;
	console.log("classIdの初期値", classId);
	searchMenu();
	
  }
//ジャンル変更のメゾット
function clickClassId(event){
	classId = event.target.id;
	console.log("ジャンル:",classId);
	searchMenu();
}
//検索ボックスでエンターを押した時に検索実行
function enterSearch(){
	if(event.key === "Enter"){
		event.preventDefault();
		searchMenu();
	}
}
//検索メゾット（２５５まで）
async function searchMenu() {
    try {
        // 検索文字列取得
        let queryE = document.getElementById("searchInput");
        let query = queryE != null ? queryE.value : " ";
        
        // URLを決定（メニューか履歴か）
		let url = listOrData
		    ? 'menuSearch?q=' + encodeURIComponent(query) + '&class=' + encodeURIComponent(classId)
		    : 'menuDataSearch?q=' + encodeURIComponent(query) + '&class=' + encodeURIComponent(classId);


        // データ取得
        let response = await fetch(url);
        if (!response.ok) throw new Error(`HTTPエラー: ${response.status}`);
        
        let text = await response.text();
		console.log("[取得データ]", text); // ★追加！
        let arrayData = text.trim().split("\n").map(row => row.split(",")); // 2次元配列に変換

        // テーブル描画
        const tableBody = document.getElementById("resultTable");
        tableBody.innerHTML = ""; // 既存クリア
		
		const thead = document.querySelector(".dish-table thead");
		if (thead) {
		    thead.innerHTML = ""; // 一旦クリア
		    const tr = document.createElement("tr");
		    const th = document.createElement("th");
		    th.textContent = listOrData ? "追加" : "登録日時"; // モードによって切り替え
		    tr.appendChild(th);

		    // 他のカラムは固定なので追加
		    const headers = ["料理名", "ジャンル", "摂取カロリー", "食材", "分量"];
		    headers.forEach(text => {
		        const th = document.createElement("th");
		        th.textContent = text;
		        tr.appendChild(th);
		    });
		    thead.appendChild(tr);
		}

        arrayData.forEach(row => {
            const tr = document.createElement("tr");
            row.forEach((cell, index) => {
                const td = document.createElement("td");
                if (index === 0) {
                    if (listOrData) {
                        // メニュー一覧モード（追加ボタン）
                        const button = document.createElement("button");
                        button.id = cell;
                        button.classList.add("button-add");
                        button.textContent = "追加";
                        button.addEventListener("click", addCart);
                        td.appendChild(button);
                    } else {
                        // 履歴モード（登録日時をそのまま表示）
                        td.textContent = formatDateTime(cell);
                    }
                } else {
                    td.textContent = cell;
                }
                tr.appendChild(td);
            });
            tableBody.appendChild(tr);
        });

    } catch (error) {
        console.error("検索失敗:", error);
    }
}
//カートにメニューを入れる
function addCart(event){
	let menuId = event.target.id;
	cart.push(menuId);
	console.log(cart);
}
//カートのメニューを削除
function removeCart(event){
	let cartIndex = event.target.id;
	cart.splice(cartIndex,1);
	
	console.log(cart);
	cartList();
}
//確認画面でカートの内容を表示（３３８まで）
async function cartList() {
    try {
		//カートが空ならテキストのみ表示
    	if(cart.length === 0){
    		let tableBody = document.getElementById("cartTable");
	        tableBody.innerHTML = "";
        	let caltext = document.getElementById("caltable");
	        caltext.innerHTML = ""; // 既存データをクリア
        	caltext.textContent = "現在、リストの中身はありません。";
        }else{
        //IDをもとにカートのメニューを検索
    	let params = new URLSearchParams();
    	cart.forEach(v => params.append("cart", v));
    	let response = await fetch('cartList?' + params.toString());
        if (!response.ok) throw new Error(`HTTPエラー: ${response.status}`);

        let text = await response.text(); // CSVデータ取得
        //コンソールに表示
		console.log(text);
        
	    //↓スプリットを二回行い二次元配列にする
	    let arrayData = text.trim().split("\n").map(row => row.split(",")); // 二次元配列に変換
	        
	        let tableBody = document.getElementById("cartTable");
	        tableBody.innerHTML = ""; // 既存データをクリア

	        let cartIndex = 0;
			sumCal = 0;
	        arrayData.forEach(row => { //javaにおける拡張for文
	            if (row.length < 2) return; // データが不足している場合スキップ
	
				//htmlにおける<tr>
	            let tr = document.createElement("tr");
				let count = 0;
	            row.forEach(cell => {
	                let td = document.createElement("td");
					//M_IDなら削除ボタン設置
					if(count == 0){
	                	let button = document.createElement("button");
	                	button.id = cartIndex;//ボタンのidを宣言
	                	button.classList.add("button-remove");
	                	button.textContent = "削除";//ボタンの中の文字を表示
	                	//ボタンのonclickを宣言
	                	button.addEventListener("click",removeCart);
	                	td.appendChild(button);
	                }else{
		                td.textContent = cell;
	                }
					//合計カロリーの積算
	                if(count == 2){
						sumCal = sumCal + Number(cell);
		                }
	                count++;
	                tr.appendChild(td);
	            });
				//htnlにおける</tr>
	            tableBody.appendChild(tr);
	            cartIndex++;
	        });
			//合計カロリーの表示
	        let caltext = document.getElementById("caltable");
	        caltext.innerHTML = "";
	        caltext.textContent = "合計カロリー："　+ sumCal;
        }
    } catch (error) {
        console.error("検索失敗:", error);
    }
}

function isFrom(from){
	if(!from || from.value.trim() === ""){
		return false;
	}
	return true;
}

async function addMenu(){
	console.log("addMenu起動");
	let error = "";
	//フォームからデータを受け取る&未入力チェック
	let nameE = document.getElementById("mName");
	console.log(nameE);
	let name = isFrom(nameE) ? nameE.value: error += "メニュー名、";
	let calE = document.getElementById("mCal");
	console.log(calE);
	let cal = isFrom(calE)? calE.value: error += "カロリー、";
	let mateE = document.getElementById("mMate");
	console.log(mateE);
	let mate = isFrom(mateE)? mateE.value: error += "食材、";
	let explE = document.getElementById("mExpl");
	console.log(explE);
	let expl = isFrom(explE)? explE.value: error += "分量、";	
	error += error.trim() === "" ? "":"を入力してください。";
	let classE = document.getElementById("class");
	console.log(classE);
	let classId = "";
	
	if(!classE || classE.value === ""){
		error += "ジャンルを選択してください。";
	}else{
		classId = classE.value;
	}
	if(name.length > 30){
		error += "\nメニュー名は３０文字までです。";
	}
	if(mate.length > 100){
			error += "\n食材は１００文字までです。";
		}
	console.log(error);
	//未入力の判定、（未入力なら上の行でerrorにメッセージが入っている）
	if(error.trim() != ""){
    	let caltext = document.getElementById("addMenuError");
        caltext.innerHTML = ""; // 既存データをクリア
    	caltext.textContent = error;
	}else{
		const conModal = document.getElementById("addConfimat");
		conModal.style.display = "block";
		
		let tableBody = document.getElementById("confimatMenu");
        tableBody.innerHTML = ""; // 既存データをクリア
            
				//htmlにおける<td>
                let td = document.createElement("td");
	            td.textContent = name;
				//htmlにおける</td>
				tableBody.appendChild(td);
				td = document.createElement("td");
	            td.textContent = cal;
				tableBody.appendChild(td);
				td = document.createElement("td");
	            td.textContent = mate;
				tableBody.appendChild(td);
				td = document.createElement("td");
	            td.textContent = classId
				tableBody.appendChild(td);
				td = document.createElement("td");
	            td.textContent = expl;
				tableBody.appendChild(td);

            
	//データを格納するメゾット実行	
		console.log("ボタンが押されるのを待っています...");
	    const result = await waitForButtonClick(["addFixed","addBack"]);
	    console.log(result+"ボタンが押されました！"); // "ボタンが押されました！"
		
		if(result === "addFixed"){
			const ardModal = document.getElementById("addreged");
			console.log(result+"起動");
	    response = await fetch('addMenu?name=' + encodeURIComponent(name) 
								+ '&cal=' + encodeURIComponent(cal) 
								+ '&mate=' + encodeURIComponent(mate) 
								+ '&classId=' + encodeURIComponent(classId)
								+ '&expl=' + encodeURIComponent(expl));
	        if (response.ok) {     
		        ardModal.style.display = "block";
				
				nameE.value = "";
				calE.value = "";
				mateE.value = "";
				classE.value = "";
				explE.value = "";
				
			}else{
				throw new Error(`HTTPエラー: ${response.status}`);
			} 
			ardModal.style.display = "block";
		}else if(result === "addBack"){
			conModal.style.display = "none";
		}
	}
	console.log("addMene終了");
}

// 登録日時を yyyy-MM-dd HH:mm に整形する
function formatDateTime(datetimeString) {
    if (!datetimeString) return "";
    return datetimeString.length >= 16 ? datetimeString.substring(0, 16) : datetimeString;
}

function waitForButtonClick(buttonIds) {
    return new Promise((resolve) => {
        buttonIds.forEach(id => {
            const button = document.getElementById(id);
            button.addEventListener("click", () => {
                resolve(id); // クリックされたボタンのIDを返す
            }, { once: true }); // 一度だけ実行
        });
    });
}
