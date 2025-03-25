import { Request, Response, NextFunction } from 'express';
import * as todoService from '../services/toDoService';
import { ToDoInterface } from '../domain/ToDoInterface';

export const getAllTodos = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  try {
    const { todos, message } = await todoService.getAllTodos();
    res.json({ todos, message });
  } catch (error) {
    next(error);
  }
};

export const createTodo = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  const todo: Omit<ToDoInterface, 'id'> = req.body;
  try {
    const { todo: createdTodo, message } = await todoService.createTodo(todo);
    res.status(201).json({ todo: createdTodo, message });
  } catch (error) {
    next(error);
  }
};

export const getTodoById = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  const id = parseInt(req.params.id);
  try {
    const { todo, message } = await todoService.getTodoById(id);
    if (todo) {
      res.json({ todo, message });
    } else {
      res.status(404).json({ message });
    }
  } catch (error) {
    next(error);
  }
};

export const editTodo = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  const id = parseInt(req.params.id);
  const updatedTodo: Partial<ToDoInterface> = req.body;
  try {
    const message = await todoService.editTodo(id, updatedTodo);
    res.json({ message });
  } catch (error) {
    next(error);
  }
};


export const deleteTodo = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  const id = parseInt(req.params.id);
  try {
    const message = await todoService.deleteTodo(id);
    res.json({ message });
  } catch (error) {
    next(error);
  }
};
