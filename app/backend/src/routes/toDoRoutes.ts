import { Router } from 'express';

import * as todoController from '../controllers/toDoController';

const router = Router();

router.get('/', todoController.getAllTodos);
router.get('/:id', todoController.getTodoById);
router.post('/', todoController.createTodo);
router.put('/:id', todoController.editTodo);
router.delete('/:id', todoController.deleteTodo);

export default router;
