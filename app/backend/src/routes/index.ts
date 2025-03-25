import { Router } from 'express';

import todoRoutes from './toDoRoutes';

const router = Router();

router.use('/todo', todoRoutes);

export default router;
