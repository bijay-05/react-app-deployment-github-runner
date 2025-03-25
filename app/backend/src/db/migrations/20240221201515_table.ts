import { Knex } from "knex";


export async function up(knex: Knex): Promise<void> {
    return knex.schema.createTable('todolist', (table) => {
        table.increments('id').primary();
        table.string('title').notNullable();
        table.string('description').notNullable();
        table.boolean('completed').notNullable().defaultTo(false);
    });
}


export async function down(knex: Knex): Promise<void> {
}

