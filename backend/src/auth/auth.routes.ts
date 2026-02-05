import { Router } from 'express';
import { AuthService } from './auth.service';

const router = Router();
const authService = new AuthService();

router.post('/google', async (req, res) => {
    const { token } = req.body;

    if (!token) {
        res.status(400).json({ message: 'Token is required' });
        return;
    }

    try {
        const user = await authService.verifyGoogleToken(token);
        // In a real app, verifyGoogleToken would probably return a session token of your own.
        // For this demo, we just echo back the user info to confirm success.
        res.json({ message: 'Login successful', user });
    } catch (error) {
        res.status(401).json({ message: 'Invalid token' });
    }
});

export default router;
