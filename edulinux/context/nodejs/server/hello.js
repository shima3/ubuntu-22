const fs = require("fs");
const express = require('express');
const path = require("path");
const app = express();
const PORT = 1000;

// 別のサーバ間からのアクセスを許可する場合
// const cors = require('cors');
// app.use(cors());

// APIエンドポイント
app.get('/api/hello', (req, res) => {
    res.json({ message: 'アクセス成功' });
});

// app.use(express.static('public')); // publicにHTML/JSを配置
app.get(/.*/, (req, res) => {
    const filePath = path.join(process.cwd(), "public", req.path);
    fs.readFile(filePath, "utf8", (err, data) => {
	if (err) {
	    res.status(404).send("File not found");
	    return;
	}
	const replaced = data.replace("<<BASE>>", "/port/"+PORT);
	res.send(replaced);
    });
});

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
