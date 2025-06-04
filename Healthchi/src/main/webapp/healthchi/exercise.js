//メニュー/履歴の保存値
let listOrData;
let classId;
let cart = [];
let sumCal;

document.addEventListener("DOMContentLoaded", function () {
    const modal = document.getElementById("exerModal");
    modal.style.display = "none";
    const rModal = document.getElementById("rateModal");
    rModal.style.display = "none";

    const openBtn = document.getElementById("openModalBtn");
    openBtn.addEventListener("click", function () {
        document.getElementById("modalerror").innerHTML = "";
        modal.style.display = "block";
        cartList();
    });

    document.querySelectorAll('.close-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            this.parentElement.parentElement.style.display = 'none';
        });
    });

    const lodBtn = document.getElementById("listOrDataId");
    lodBtn.addEventListener("click", function () {
        listOrData = !listOrData;
        document.getElementById("searchInput").value = "";
        classId = "all";
        searchMenu();
    });

    const continueBtn = document.getElementById("close");
    continueBtn.addEventListener("click", function () {
        rModal.style.display = "none";
        modal.style.display = "none";
    });

    const regcartBtn = document.getElementById("registerCart");
    regcartBtn.addEventListener("click", registerCart);
});

window.onload = initialize;

function initialize(){
    console.log("onload");
    classId = "all";
    listOrData = true;
    console.log("classIdの初期値", classId);
    searchMenu();
}

function clickClassId(event){
    classId = event.target.id;
    console.log("ジャンル:", classId);
    searchMenu();
}

function enterSearch(){
    if(event.key === "Enter"){
        event.preventDefault();
        searchMenu();
    }
}

async function searchMenu() {
    try {
        const queryE = document.getElementById("searchInput");
        const query = queryE ? queryE.value : " ";
        const url = listOrData
            ? 'exerSearch?q=' + encodeURIComponent(query) + '&class=' + encodeURIComponent(classId)
            : 'exerDataSearch?q=' + encodeURIComponent(query) + '&class=' + encodeURIComponent(classId) + '&mode=history';

        const response = await fetch(url);
        if (!response.ok) throw new Error(`HTTPエラー: ${response.status}`);
        const text = await response.text();
        const arrayData = text.trim().split("\n").map(row => row.split(","));

        // ★テーブルヘッダーも動的に切り替え
        const tableHead = document.querySelector(".dish-table thead tr");
        tableHead.innerHTML = "";
        if (listOrData) {
            tableHead.innerHTML = `
                <th>追加</th>
                <th>運動名</th>
                <th>ジャンル</th>
                <th>消費カロリー</th>
                <th>運動の説明</th>
            `;
        } else {
            tableHead.innerHTML = `
                <th>登録日時</th>
                <th>運動名</th>
                <th>ジャンル</th>
                <th>消費カロリー</th>
                <th>運動の説明</th>
            `;
        }

        const tableBody = document.getElementById("resultTable");
        tableBody.innerHTML = "";

        arrayData.forEach(row => {
            if (row.length < 2) return;
            const tr = document.createElement("tr");

            if (listOrData) {
                const tdButton = document.createElement("td");
                const button = document.createElement("button");
                button.id = row[0];
                button.classList.add("button-add");
                button.textContent = "追加";
                button.addEventListener("click", addCart);
                tdButton.appendChild(button);
                tr.appendChild(tdButton);

                for (let i = 1; i < row.length; i++) {
                    const td = document.createElement("td");
                    td.textContent = row[i];
                    tr.appendChild(td);
                }
            } else {
                const tdDate = document.createElement("td");
                tdDate.textContent = row[0];
                tr.appendChild(tdDate);

                for (let i = 1; i < row.length; i++) {
                    const td = document.createElement("td");
                    td.textContent = row[i];
                    tr.appendChild(td);
                }
            }
            tableBody.appendChild(tr);
        });

    } catch (error) {
        console.error("検索失敗:", error);
    }
}

function addCart(event){
    const menuId = event.target.id;
    cart.push(menuId);
    console.log(cart);
}

function removeCart(event){
    const cartIndex = event.target.id;
    cart.splice(cartIndex, 1);
    cartList();
}

async function cartList() {
    try {
        const tableBody = document.getElementById("cartTable");
        if (cart.length === 0) {
            tableBody.innerHTML = "";
            document.getElementById("caltable").innerHTML = "現在、リストの中身はありません。";
            return;
        }

        const params = new URLSearchParams();
        cart.forEach(v => params.append("cart", v));
        const response = await fetch('exerCartList?' + params.toString());
        if (!response.ok) throw new Error(`HTTPエラー: ${response.status}`);

        const text = await response.text();
        const arrayData = text.trim().split("\n").map(row => row.split(","));

        tableBody.innerHTML = "";
        sumCal = 0;
        arrayData.forEach((row, cartIndex) => {
            if (row.length < 2) return;
            const tr = document.createElement("tr");
            let count = 0;
            row.forEach(cell => {
                const td = document.createElement("td");
                if (count == 0) {
                    const button = document.createElement("button");
                    button.id = cartIndex;
                    button.classList.add("button-remove");
                    button.textContent = "削除";
                    button.addEventListener("click", removeCart);
                    td.appendChild(button);
                } else {
                    td.textContent = cell;
                }
                if (count == 2) {
                    sumCal += Number(cell);
                }
                count++;
                tr.appendChild(td);
            });
            tableBody.appendChild(tr);
        });

        document.getElementById("caltable").innerHTML = "合計カロリー：" + sumCal;
    } catch (error) {
        console.error("検索失敗:", error);
    }
}

async function registerCart() {
    if (cart.length === 0) {
        document.getElementById("modalerror").innerHTML = "中身が空です。";
        return;
    }

    const response1 = await fetch('getRating');
    if (!response1.ok) throw new Error(`HTTPエラー: ${response1.status}`);
    const beforeRating = parseInt(await response1.text(), 10);

    const params = new URLSearchParams();
    cart.forEach(v => params.append("cart", v));
    const response2 = await fetch('exerRegisterCart?' + params.toString());
    if (!response2.ok) throw new Error(`HTTPエラー: ${response2.status}`);
    const afterRating = parseInt(await response2.text(), 10);

    cart.length = 0;

    const rModal = document.getElementById("rateModal");
    rModal.style.display = "block";
    const changeRating = afterRating - beforeRating;

    const rateTable = document.getElementById("rateTable");
    rateTable.innerHTML = changeRating != 0 
        ? (changeRating > 0 ? changeRating + "ポイント上がった。" : (-changeRating) + "ポイント下がった。")
        : "ポイントに変動なし";

    const rating = document.getElementById("rating");
    rating.innerHTML = "変更前⇒変更後<br>" + beforeRating + "⇒" + afterRating;

    const response3 = await fetch('exerGetTodayCal');
    if (!response3.ok) throw new Error(`HTTPエラー: ${response3.status}`);
    const nowCal = parseInt(await response3.text(), 10);

    document.getElementById("nowCal").innerHTML = "今日の消費カロリー(kcal)："+ nowCal;
}
