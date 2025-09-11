const express = require('express');
const app = express();
const PORT = 3000;

// 別のサーバ間からのアクセスを許可する場合
// const cors = require('cors');
// app.use(cors());

app.use(express.static('html')); // htmlにHTML/JSを配置

// APIエンドポイント
app.get('/api/hello', (req, res) => {
  res.json({ message: 'アクセス成功' });
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
