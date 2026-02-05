import { OAuth2Client } from 'google-auth-library';
import { PrismaClient } from '@prisma/client';
import { Pool } from 'pg';
import { PrismaPg } from '@prisma/adapter-pg';
import { config } from '../config';

const client = new OAuth2Client(config.googleClientId);

const connectionString = `${process.env.DATABASE_URL}`;

const pool = new Pool({ connectionString });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter });

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
