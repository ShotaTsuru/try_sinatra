# try_sinatra
try_sinatraは簡単なメモアプリ

# DEMO
投稿
https://i.gyazo.com/a0bce0a0d97e3b145e6e4512af716e82.gif

削除
https://i.gyazo.com/ce5122bb2530033cc3fc1d434cb7fef0.gif

編集
https://i.gyazo.com/f4216b3587eed93ce958f0b92ef898a7.gif
# Features
最低限必要なものを実装。
・XSS対策済み。
・CSSは黒と白でシンプルに
・CSSは黒と白でシンプルにSQLインジェクション対策済み

# DB setting 
DBにpostgreSQLを使用していますので、postgreSQLの環境で以下の準備をしてください。
```bash
# 'try_sinatra_db'データベースの作成
create database try_sinatra_db;
# 'memos'テーブルの作成
create table memos (
  memo_id serial, 
  title varchar(100),
  text text
);
```

# Usage
```bash
# 任意のフォルダに
git clone 
# cloneしたフォルダへ移動
cd try_sinatra
# gemのセッティング
bundle install
# sinatraサーバーの立ち上げ
bundle exec ruby app.rb
# http://localhost:4567/memo へアクセス
```
あとはメモとしてお使いください。

# Note
フィヨルドブートキャンプの課題

# Author

作成者　鶴 翔太
