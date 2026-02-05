import express from 'express';
import cors from 'cors';

const app = express();
const port = 3000;

app.use(cors());

app.get('/hello', (req, res) => {
    res.json({ message: 'Hello from Backend!' });
});

app.listen(port, () => {
    console.log(`Backend server listening on port ${port}`);
});
