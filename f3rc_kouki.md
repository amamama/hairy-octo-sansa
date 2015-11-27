はじめに
========
## チーム名
<span>例の紐</span>
## メンバー
**天津 健**，中山 比呂，川口 貴弘，久保田 雅祐，有賀 嵩紘，豊田 修与，横山 陽彦

機体の紹介
==========
## 自動機の紹介
![](./ji_.png){right}
- ライントレース
- 足回りのモータに540を使用して素早い移動が可能
- コの字型にして中に情報オブジェクトを溜める
- マイコンはstm32を使用


## 自動機の説明
![](./ji_.png){right}
- バッテリー置き場
バッテリーを置くために，ロボットの底面にバッテリー置き場を作った．
- ライントレース
F3RCのラインを見るために，9個の赤外線センサーを用い白と緑を判別しライントレースをする．

![](./ji_.png){right}
- アーム
2つのサーボモータに板を直接張りつける形で，アームを制作した．
- モータドライバ
中山くんが設計，制作してくれました．ロボットに乗っけてテストしている最中に煙を吹いた．

![](./ji_.png){right}
- コの字型
中に情報オブジェクトを2つまで溜められる．他の班をが制作したロボットを見ると，大量に情報オブジェクトを貯めこむタイプが多かったので，試合で不利になった．

## 手動機の紹介
![](./tmp_.png){right}
- 足回りのモータに540を使用して素早い移動が可能
- ステピンで発射機構の角度が変更できる
- そのステピンにつけるギヤを自作
- 砲弾オブジェクトを溜めるところと射出機構とのスムーズな連携
- PS2コントローラによる操作
- マイコンはstm32を使用

## 手動機の説明
![](./tm.png){right}
- 発射機構の角度変更
ステッピングモータと秋月に売っているモータドライバを使い，チルト角を変更可能．\n
また，回転させるためのギヤを自作した．
- 砲弾を格納する場所
自動で筒の変更と玉送りをできるようにした．\n
直動機構により筒を動かさなければならないため，ここにもステッピングモータを使い，ギヤとラックギヤを自作した．

![](./tmp_.png){right}
- 玉送り
マイクロスイッチ2つをタミヤのDCモータで玉送りを行った．\n
ここにも同様にギヤとラックギヤを用いた．
- PS2コントローラの使用
SPI通信を用いてPS2コントローラと通信した．\n
石橋先輩のブログを参考にしました．

当初予定とどう変更したか
========================
## 自動機のタイヤ
![](./t_.png){right}
ロボットの中心にタイヤが来るように設計したが，最終的にモータは後ろについた．\n
//理由は，タイヤが真ん中に来るとうまくライントレースができなかったため．ラインセンサとタイヤの位置を離すことによって改善した．\n
それに伴い,キャスターの位置が変更になり，3点設置から4点設置になった．\nそのため，安定性を上げるため，タイヤの真上に重りをつけ，グリップ力を上げた．

## 手動機の機構
![](./tmp_.png){right}
当初ドーナツ型の玉を溜める場所から中央にある砲台に弾を入れ発射させる機構(ターンテーブルの外側に弾，中央に砲台)を発案したが，開発期間が十分に取れないと判断したため，急遽画像のような機構となった．\n
結果，溜めるところと射出機構のみというシンプルな機構に変更し，その機構がスムーズに動くように尽力した．\n
工夫箇所として
- 角度調整が容易なステッピングモータで発射機構の角度が変えられる
- 自動で弾の装填，筒の移動が可能
などがある．

ちなみに
==========
このスライドは[]()
で閲覧可能です
- User **amamama**
- repository **hairy-octo-sansa**
