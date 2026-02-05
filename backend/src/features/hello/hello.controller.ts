import { Request, Response } from 'express';
import { HelloService } from './hello.service';

const helloService = new HelloService();

export class HelloController {
    getHello(req: Request, res: Response) {
        const data = helloService.getHelloMessage();
        res.json(data);
    }
}
