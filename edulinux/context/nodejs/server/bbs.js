const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const PORT = 3000;

// メッセージをサーバ側で保持（簡易的にメモリ上）
let messages = [];

// 静的ファイル配信
app.use(express.static('public'));
app.use(bodyParser.json());

// メッセージ一覧を返す
app.get('/api/messages', (req, res) => {
  res.json(messages);
});

// 新しいメッセージを受け取って保存
app.post('/api/messages', (req, res) => {
  const text = req.body.text?.trim();
  if (!text) return res.status(400).json({ error: 'メッセージが空です' });
  const msg = { text, time: new Date().toLocaleString() };
  messages.push(msg);
  res.json({ status: 'ok' });
});

app.listen(PORT, () => console.log(`http://localhost:${PORT} で起動中`));
