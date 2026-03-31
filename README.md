# X検索コマンド ジェネレータ

X（Twitter）の検索を効率化するためのツールです。ユーザーIDやキーワード、エンゲージメント数などを入力するだけで、複雑な検索コマンドを自動生成できます。

## 🎯 特徴

- ✅ **簡単操作** — ユーザーIDを入力してチェックボックスを選ぶだけ
- 🔍 **リアルタイム生成** — 入力すると即座にコマンドが生成される
- 📋 **ワンクリックコピー** — コマンドをクリックで自動コピー
- 🎨 **モダンなUI** — 使いやすく、美しいインターフェース
- 📱 **レスポンシブ** — PCとスマートフォンどちらでも使用可能
- 🚀 **高速** — 外部ライブラリ不要で軽量

## 🚀 使い方

### オンラインで使用

[こちらのリンク](https://xxx.github.io/x-search-generator/)からアクセスしてください。
※ GithubPages設定後のURLに置き換えてください

### ローカルで使用

1. `x-search-generator.html` をダウンロード
2. ブラウザで開く

## 💡 使用例

### 例1：特定ユーザーのポストを検索
```
ユーザーID: elon
生成コマンド: from:elon
```
Elonのすべてのポストが表示されます

### 例2：期間内の高エンゲージメントポスト
```
ユーザーID: OpenAI
開始日: 2024-01-01
終了日: 2024-03-31
最小いいね数: 1000
生成コマンド: from:OpenAI since:2024-01-01 until:2024-03-31 min_faves:1000
```

### 例3：キーワード付きで検索
```
ユーザーID: NASA
キーワード: Mars
生成コマンド: from:NASA "Mars"
```
NASAのMarsに関するポストのみが表示されます

## 🛠️ 生成可能なコマンド

### 基本検索
- **ユーザーのポストのみ** — `from:ID`
- **リプライのみ** — `filter:replies`
- **リプライ除外** — `exclude:replies`

### メディア・形式
- **画像のみ** — `filter:images`
- **動画のみ** — `filter:videos`
- **画像・動画** — `filter:media`
- **URL付き** — `filter:links`
- **リポストのみ** — `filter:nativeretweets`
- **引用リポスト** — `twitter.com/ID -from:ID`

### 認証・フォロー
- **認証済みアカウント** — `filter:verified`（青チェック）
- **フォロー中のみ** — `filter:follows`

### 期間指定
- **指定日以降** — `since:YYYY-MM-DD`
- **指定日以前** — `until:YYYY-MM-DD`
- **指定期間内** — `since:YYYY-MM-DD until:YYYY-MM-DD`

### エンゲージメント
- **最小いいね数** — `min_faves:N`
- **最小リポスト数** — `min_retweets:N`
- **最小リプライ数** — `min_replies:N`

### キーワード検索
- **完全一致** — `"キーワード"`
- **部分一致** — `キーワード`

## ⚙️ 技術仕様

- **言語** — JavaScript（バニラJS）
- **依存関係** — なし
- **ファイルサイズ** — 約15KB（最小化時）
- **ブラウザ対応** — 全モダンブラウザ対応

## ⚠️ 注意事項

- X（Twitter）は定期的に検索コマンドを変更することがあります
- コマンドに余計なスペースやタイポがあると動作しません
- `:` や `-` などの記号は正確に入力される必要があります
- 日付形式は **YYYY-MM-DD** で統一してください

## 📝 ライセンス

MIT License

## 🤝 貢献

改善提案やバグ報告は、GitHubのIssuesやPull Requestsで受け付けています。

## 📚 参考資料

- [X Advanced Search](https://twitter.com/search-advanced)
- [Twitterの検索コマンド完全ガイド](https://help.twitter.com/ja/using-twitter/twitter-advanced-search)

---

**作成日**: 2024年
**最終更新**: 2024年

このツールで検索の効率性が向上することを願っています！
