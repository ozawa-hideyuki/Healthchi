package healthchi; 

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import bean.CharacterInfo;
import bean.User;

@WebServlet("/Home")
public class Home extends HttpServlet {

    private static final Map<String, String[]> MESSAGE_MAP = new HashMap<>();
    static {
        MESSAGE_MAP.put("KAZE", new String[]{
            "あ～だるいワン", "休みたいワン～", "赤いマフラーかわいいでしょ", "ちょっと横になるワン", "さっきお薬飲んだワン！", "うぅ…食べすぎたせいで調子が…", "運動しすぎて風邪ひいたかも…", "ゆっくり休んで体調を整えるワン", "少し休んだら、元気になれるかな？", "もうっ、早く良くなれ！"
        });
        
        MESSAGE_MAP.put("GORILLA", new String[]{
            "うほ〜…眠いなあ", "食べちゃおう、うほ", "うほうほ", "ねぇ、あそぼ！", "さびしいうほ…", "僕がかわりに食べるうほ！", "バナナでエネルギー補給、完璧だ！", "休息もトレーニングの一部だ！", "お前もゴリラにならないか？", "鍛えたら、ムキムキになれるぞ！"
        });
        MESSAGE_MAP.put("WARUINU", new String[]{
            "運動しようぜ！", "このバット100kgなんだぜ", "プロテインプリーズ！", "がるがる♪", "おまえはいい奴だよな…", "好きなものを食う！運動？ナシだ！", "カロリー？そんなの気にしないぜ！", "たまにはズルしてもいいよな？な？", "走るくらいなら寝るぜ…Zzz", "お前はすでに食べ過ぎている！"
        });
        
        MESSAGE_MAP.put("PIG", new String[]{
            "ぶひ〜…眠いなあ", "おなかすいたぶぅ", "むにゃむにゃ…", "ぽてち、うま～！", "運動しなきゃぶぅ～…", "いっぱい食べると気持ちいいブー♪", "ちょっと食べすぎちゃった…反省…", "運動はほどほどがいいブー！", "お昼寝して健康管理、最高ブー！", "食も運動も、バランスが大事ブー！"
        });
        MESSAGE_MAP.put("FUWARIN", new String[]{
            "ふわーん、今日もいい日になりそう", "お昼寝したい気分…", "もふもふしていいよ", "あなたは頑張ってるふわ", "ふわふわの毎日幸せいっぱいワン！", "おやつはガマン…できるかな？", "運動で、もっとモフモフになれる？", "ちょっと休憩…ごろーん♪"
        });
        MESSAGE_MAP.put("MEGARIN", new String[]{
            "勉強はまかせて", "今日は何食べようかな？", "運動はキミにまかせる", "めがねイイでしょ", "カロリー計算は完璧だワン！", "知識こそ健康管理の秘訣だワン！", "運動も計画的にするのがポイントだね。", "本を読みながら健康維持ワン！", "健康管理はデータ大事…分析開始！"
        });
        MESSAGE_MAP.put("IDOL", new String[]{
            "にゃむにゃむ…♪", "おなかすいた♪", "毎日ラッキーなんだよ♪", "一緒におどりましょ♪", "さみしくなんかないもん♪", "健康って、大事だよね！", "おいしいものは幸せになれる♪", "今日も元気いっぱい、がんばる！", "のんびりする時間も大事だよ～！"
        });
        MESSAGE_MAP.put("LION", new String[]{
            "頑張るキミは素敵だな", "綺麗なバラにもトゲはあるんだぜ", "おなかすいたぜ", "ふわふわのたてがみ、触るか？", "健康管理もスタイルの一部だぜ！", "カロリー管理？スマートにやるのがオシャだぜ！", "美しい毛並みには食事が大切さ！", ""
        });
        MESSAGE_MAP.put("KING", new String[]{
            "今日もいい日だな", "おいしいご飯を食べよう", "私は朝活派だな", "みんなでパーティーでもしようか", "王たる者、健康管理は欠かせぬ！", "バランスの取れた食事こそ王の習慣", "運動は気品を保つためにも重要だ！", "民よ、健康に気を付けよ！", "健やかな体は偉大なる王国の礎だ！"
        });
        MESSAGE_MAP.put("PIYORIN", new String[]{
            "ぴよぴよ素晴らしいぴよ", "", "ぴよぴよ…", "飴、食べる？", "頑張らなくていいぴよ…","そのままのキミが好きぴよ", "ちょっと食べすぎちゃったぴよ…", "運動するとぴょんぴょん楽しいぴよ", "今日はお野菜たくさん食べたぴよ！", "立派な鳥になるぴよ！"
        });
        MESSAGE_MAP.put("SENRIN", new String[]{
            "ふぉふぉ", "心の目は開いておるぞよ", "おぬしも仙人レベルだ", "おなかすいたぞよ","人間は運動も大切ぞよな", "腰ぎんちゃくには漢方が入っておる", "カロリー調和こそ心と体の安寧なり", "食も運動も己を知ることが大事じゃ", "過ぎたるは及ばざるが如し", "摂取も消費も、ほどほどにな", "運動を怠れば、気も滞るぞ", "健康は流れ。水の如く生きるのじゃ"
        });
        // 他キャラも必要に応じて追加
    }

    private static final Map<String, CharacterInfo> EMOTION_MAP = new HashMap<>();
    static {
        EMOTION_MAP.put("寝",  new CharacterInfo("default", "EMOTEimage/zzz.png"));
        EMOTION_MAP.put("笑", new CharacterInfo("default", "EMOTEimage/wara.png"));
        EMOTION_MAP.put("もう", new CharacterInfo("default", "EMOTEimage/oko.png"));
        EMOTION_MAP.put("好", new CharacterInfo("default", "EMOTEimage/love.png"));
        EMOTION_MAP.put("元気", new CharacterInfo("default", "EMOTEimage/kirakira.png"));
        EMOTION_MAP.put("バランス", new CharacterInfo("default", "EMOTEimage/kira.png"));
        EMOTION_MAP.put("？", new CharacterInfo("default", "EMOTEimage/hatena.png"));
        EMOTION_MAP.put("食べ過ぎ", new CharacterInfo("default", "EMOTEimage/gaan.png"));
        EMOTION_MAP.put("！？", new CharacterInfo("default", "EMOTEimage/bikkurihatena.png"));
        EMOTION_MAP.put("！", new CharacterInfo("default", "EMOTEimage/bikkuri.png"));
        EMOTION_MAP.put("休", new CharacterInfo("default", "EMOTEimage/aseasease.png"));
        EMOTION_MAP.put("汗", new CharacterInfo("default", "EMOTEimage/asease.png"));
        EMOTION_MAP.put("反省", new CharacterInfo("default", "EMOTEimage/ase.png"));
        
        EMOTION_MAP.put("おなか", new CharacterInfo("default", "EMOTEimage/ase.png"));
        EMOTION_MAP.put("がんば", new CharacterInfo("default", "EMOTEimage/kirakira.png"));
        EMOTION_MAP.put("さびしい", new CharacterInfo("default", "EMOTEimage/moyamoya.png"));
        EMOTION_MAP.put("泣", new CharacterInfo("default", "EMOTEimage/asease.png"));
        EMOTION_MAP.put("うるうる", new CharacterInfo("default", "EMOTEimage/asease.png"));
     
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	HttpSession session = request.getSession();
    	User user = (User) session.getAttribute("user");

    	// テストモードを true にすると仮ログイン処理を行う
    	boolean isTestMode = false;

    	if (user == null) {
    	    if (isTestMode) {
    	        // 仮ログイン
    	        user = new User();
    	        user.setU_ID("test123");
    	        user.setU_NAME("テストユーザー");
    	        user.setU_RATINGVALUE(70); // ← 初期進化段階などに応じて設定
    	        session.setAttribute("user", user);
    	    } else {
    	        // 本番用：ログインしていなければログインページに飛ばす
    	        response.sendRedirect("/Healthchi/healthchi/top.jsp");
    	        return;
    	    }
    	}

        int point = user.getU_RATINGVALUE();
        String characterType = "FUWARIN";

        if (point < 10) characterType = "KAZE";
        else if (point < 30) characterType = "WARUINU";
        else if (point < 50) characterType = "GORILLA";
        else if (point < 60) characterType = "PIG";
        else if (point < 80) characterType = "FUWARIN";
        else if (point < 100) characterType = "MEGARIN";
        else if (point < 120) characterType = "IDOL";
        else if (point < 140) characterType = "LION";
        else if (point < 160) characterType = "KING";
        else if (point < 180) characterType = "PIYORIN";
        else characterType = "SENRIN";

        String[] messages = MESSAGE_MAP.getOrDefault(characterType, new String[]{"こんにちは！"});
        String msg = messages[new Random().nextInt(messages.length)];
        request.setAttribute("randomMessage", msg);

        CharacterInfo emotionInfo = EMOTION_MAP.entrySet().stream()
            .filter(e -> msg.contains(e.getKey()))
            .map(Map.Entry::getValue)
            .findFirst()
            .orElse(new CharacterInfo("default", null));

        String expression = (emotionInfo.getImagePath() != null) ? emotionInfo.getImagePath() : "default";
        String characterName = characterType.toLowerCase(); // 例: PIG → pig
        String characterImagePath = "CHARAimage/" + characterType + "/" + characterName + "_" + expression + ".png";

        CharacterInfo finalInfo = new CharacterInfo(characterImagePath, emotionInfo.getEffectPath());
        request.setAttribute("characterInfo", finalInfo);
        
     // ★ HPバー段階を計算（0〜9→段階0、10以降20刻みで1〜10）
        int hpLevel;
        if (point < 10) {
            hpLevel = 0;
        } else {
            hpLevel = Math.min(((point - 10) / 20) + 1, 10);
        }

        String hpBarPath = "GRAPHICS/hpbar" + hpLevel + ".png";
        request.setAttribute("hpBarPath", hpBarPath);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/healthchi/home.jsp");
        dispatcher.forward(request, response);
    }
}