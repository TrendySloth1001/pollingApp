import { Router } from 'express';
import { HelloController } from './hello.controller';

const router = Router();
const helloController = new HelloController();

router.get('/', helloController.getHello.bind(helloController));

export default router;
