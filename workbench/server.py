#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
きせかえ競合インテリジェンス・ワークベンチ — ローカルサーバー

- Python標準ライブラリのみ（pip install 不要）
- 同じフォルダの index.html を配信し、データは data.json に実ファイル保存
- 起動: python3 server.py  （または start.command / start.bat をダブルクリック）

データはすべてこのPCの中だけ。外部には一切送信しません。
"""

import json
import os
import sys
import webbrowser
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

HERE = os.path.dirname(os.path.abspath(__file__))
DATA_PATH = os.path.join(HERE, "data.json")
INDEX_PATH = os.path.join(HERE, "index.html")
PORT = 8765

DEFAULT_DATA = {
    "competitors": [],   # {id,name,handle,kisekae:[...],isSelf}
    "ips": [],           # {id,name,handle,genres:[...]}
    "categories": ["スポーツ", "エンタメ"],
    "campaigns": [],     # {id,subjectId,ipId,kisekaeName,releaseDate,endDate,genres:[...],vocNote,metrics:{...}}
    "vocs": [],          # {id,text,url,sentiment,campaignId,ipId,createdAt}
}


def load_data():
    if not os.path.exists(DATA_PATH):
        save_data(DEFAULT_DATA)
        return DEFAULT_DATA
    try:
        with open(DATA_PATH, "r", encoding="utf-8") as f:
            return json.load(f)
    except (ValueError, OSError):
        # 壊れていても起動は止めない。バックアップを取って初期化。
        try:
            os.replace(DATA_PATH, DATA_PATH + ".corrupt")
        except OSError:
            pass
        save_data(DEFAULT_DATA)
        return DEFAULT_DATA


def save_data(data):
    # 一時ファイルに書いてから置き換える（書き込み中に壊れないように）
    tmp = DATA_PATH + ".tmp"
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    os.replace(tmp, DATA_PATH)


class Handler(BaseHTTPRequestHandler):
    def _send(self, code, body=b"", ctype="application/json; charset=utf-8"):
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(body)))
        # ローカル専用。キャッシュ無効化で常に最新を表示。
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        if body:
            self.wfile.write(body)

    def do_GET(self):
        if self.path.split("?")[0] == "/api/data":
            body = json.dumps(load_data(), ensure_ascii=False).encode("utf-8")
            self._send(200, body)
            return
        if self.path.split("?")[0] in ("/", "/index.html"):
            try:
                with open(INDEX_PATH, "rb") as f:
                    body = f.read()
                self._send(200, body, "text/html; charset=utf-8")
            except OSError:
                self._send(404, b"index.html not found")
            return
        self._send(404, b'{"error":"not found"}')

    def do_POST(self):
        if self.path.split("?")[0] != "/api/data":
            self._send(404, b'{"error":"not found"}')
            return
        try:
            length = int(self.headers.get("Content-Length", "0"))
            raw = self.rfile.read(length) if length else b"{}"
            data = json.loads(raw.decode("utf-8"))
            if not isinstance(data, dict):
                raise ValueError("expected object")
            save_data(data)
            self._send(200, b'{"ok":true}')
        except (ValueError, OSError) as e:
            self._send(400, json.dumps({"error": str(e)}, ensure_ascii=False).encode("utf-8"))

    def log_message(self, *args):
        pass  # 静かに動かす


def main():
    port = PORT
    server = None
    for attempt in range(20):
        try:
            server = ThreadingHTTPServer(("127.0.0.1", port), Handler)
            break
        except OSError:
            port += 1
    if server is None:
        print("起動に失敗しました（ポートが見つかりません）。")
        sys.exit(1)

    url = "http://127.0.0.1:%d/" % port
    print("=" * 56)
    print(" きせかえ競合インテリジェンス・ワークベンチ 起動中")
    print(" ブラウザで開いてください: " + url)
    print(" データ保存先: " + DATA_PATH)
    print(" 終了するには、このウィンドウで Ctrl+C")
    print("=" * 56)
    try:
        webbrowser.open(url)
    except Exception:
        pass
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n終了しました。")


if __name__ == "__main__":
    main()
