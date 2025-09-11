const express = require('express');
const app = express();
const PORT = 3000;

const cors = require('cors');
app.use(cors());

// APIエンドポイント
app.get('/api/hello', (req, res) => {
  res.json({ message: 'こんにちは、ブラウザ！' });
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
