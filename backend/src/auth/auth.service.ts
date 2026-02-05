import { OAuth2Client } from 'google-auth-library';
import { PrismaClient } from '@prisma/client';
import { config } from '../config';

const client = new OAuth2Client(config.googleClientId);
const prisma = new PrismaClient();

export class AuthService {
    async verifyGoogleToken(token: string) {
        try {
            const ticket = await client.verifyIdToken({
                idToken: token,
                audience: config.googleClientId,
            });
            const payload = ticket.getPayload();

            if (!payload || !payload.email || !payload.sub) {
                throw new Error('Invalid token');
            }

            // Upsert user in database
            const user = await prisma.user.upsert({
                where: { googleId: payload.sub },
                update: {
                    name: payload.name,
                    picture: payload.picture,
                },
                create: {
                    email: payload.email,
                    googleId: payload.sub,
                    name: payload.name,
                    picture: payload.picture,
                },
            });

            return user;
        } catch (error) {
            console.error('Error verifying Google token:', error);
            throw new Error('Unauthorized');
        }
    }
}
