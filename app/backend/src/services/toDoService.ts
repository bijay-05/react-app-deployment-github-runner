import { ToDoInterface } from "../domain/ToDoInterface";
import TodoModel from "../models/ToDoModel";

export const getAllTodos = async (): Promise<{ todos: ToDoInterface[]; message: string }> => {
  try {
    const todos = await TodoModel.findAll();
    return {
      todos,
      message: 'ToDos fetched successfully'
    };
  } catch (error) {
    throw new Error('Failed to fetch todos');
  }
};

export const createTodo = async (todo: Omit<ToDoInterface, 'id'>): Promise<{ todo: ToDoInterface; message: string }> => {
  try {
    const createdTodo = await TodoModel.create(todo);
    return {
      todo: createdTodo,
      message: 'Todo created successfully'
    };
  } catch (error) {
    console.log(error);
    throw new Error('Failed to create todo');
  }
}

export const getTodoById = async (id: number): Promise<{ todo: ToDoInterface | null; message: string }> => {
  try {
    const todo = await TodoModel.findById(id);
    if (todo) {
      return {
        todo,
        message: 'Todo found'
      };
    } else {
      return {
        todo: null,
        message: 'Todo not found'
      };
    }
  } catch (error) {
    throw new Error('Failed to fetch todo by ID');
  }
};

export const editTodo = async (id: number, todo: Partial<ToDoInterface>): Promise<string> => {
  try {
    await TodoModel.update(id, todo);
    return 'Todo edited successfully';
  } catch (error) {
    console.error('Error editing todo:', error);
    throw new Error('Failed to edit todo');
  }
};


export const deleteTodo = async (id: number): Promise<string> => {
  try {
    await TodoModel.delete(id);
    return 'Todo deleted successfully';
  } catch (error) {
    throw new Error('Failed to delete todo');
  }
};
