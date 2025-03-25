import knex from '../db/knex';
import { ToDoInterface } from '../domain/ToDoInterface';

class TodoModel {
  private tableName = 'todolist';

  async findAll(): Promise<ToDoInterface[]> {
    return await knex.select().from<ToDoInterface>(this.tableName);
  }

  async findById(id: number): Promise<ToDoInterface | undefined> {
    return await knex.select().from<ToDoInterface>(this.tableName).where({ id }).first();
  }

  async create(todo: Omit<ToDoInterface, 'id'>): Promise<ToDoInterface> {
    const [createdTodo] = await knex<ToDoInterface>(this.tableName).insert(todo).returning('*');
    return createdTodo;
  }

  async update(id: number, todo: Partial<ToDoInterface>): Promise<void> {
    await knex(this.tableName).where({ id }).update(todo);
  }

  async delete(id: number): Promise<void> {
    await knex(this.tableName).where({ id }).del();
  }
}

export default new TodoModel();
