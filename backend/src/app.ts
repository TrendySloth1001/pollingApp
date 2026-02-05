import express from 'express';
import cors from 'cors';
import helloRoutes from './features/hello/hello.route';
import authRoutes from './auth/auth.routes';
import profileRoutes from './features/profile/profile.route';

const app = express();

app.use(cors());
app.use(express.json());

// Routes
app.use('/hello', helloRoutes);
app.use('/auth', authRoutes);
app.use('/profile', profileRoutes);

// Health check
app.get('/', (req, res) => {
    res.json({ status: 'OK' });
});

export default app;
