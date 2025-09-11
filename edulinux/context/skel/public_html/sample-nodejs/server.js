const express = require('express');
const app = express();
const PORT = 3001;

// JSONリクエストを受け取れるようにする
app.use(express.json());

// APIエンドポイント
app.get('/api/hello', (req, res) => {
  res.json({ message: 'こんにちは、ブラウザ！' });
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
