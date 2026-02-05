import dotenv from 'dotenv';

dotenv.config();

export const config = {
    port: process.env.PORT || 3000,
    env: process.env.NODE_ENV || 'development',
    googleClientId: process.env.GOOGLE_CLIENT_ID || '452121335838-scpqis9c5o7ngok5m5v82h2ndvmk930b.apps.googleusercontent.com',
};
