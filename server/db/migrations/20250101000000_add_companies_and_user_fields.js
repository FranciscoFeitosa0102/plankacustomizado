/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

module.exports.up = async (knex) => {
  // Criar tabela companies
  await knex.schema.createTable('company', (table) => {
    /* Columns */
    table.bigIncrements('id').primary();
    table.text('nome').notNullable();
    table.timestamp('created_at', true);
    table.timestamp('updated_at', true);

    /* Indexes */
    table.index('nome');
  });

  // Adicionar campos ao modelo de usuário
  await knex.schema.alterTable('user_account', (table) => {
    table.bigInteger('company_id');
    table.text('perfil').notNullable().defaultTo('vendedor');
  });

  // Adicionar foreign key para company_id
  await knex.schema.alterTable('user_account', (table) => {
    table.foreign('company_id').references('id').inTable('company');
  });

  // Adicionar campos ao modelo de card para sincronização
  await knex.schema.alterTable('card', (table) => {
    table.bigInteger('linked_card_id');
    table.bigInteger('company_id');
    table.text('numero');
    table.text('observacao');
    table.text('card_type').notNullable().defaultTo('indicacao'); // 'indicacao' ou 'venda'
  });

  // Adicionar foreign keys para card
  await knex.schema.alterTable('card', (table) => {
    table.foreign('linked_card_id').references('id').inTable('card');
    table.foreign('company_id').references('id').inTable('company');
  });

  // Criar tabela cards_chat
  await knex.schema.createTable('cards_chat', (table) => {
    /* Columns */
    table.bigIncrements('id').primary();
    table.bigInteger('card_id').notNullable();
    table.bigInteger('user_id').notNullable();
    table.text('message').notNullable();
    table.timestamp('created_at', true);
    table.timestamp('updated_at', true);

    /* Indexes */
    table.index('card_id');
    table.index('user_id');
    table.index('created_at');
  });

  // Adicionar foreign keys para cards_chat
  await knex.schema.alterTable('cards_chat', (table) => {
    table.foreign('card_id').references('id').inTable('card');
    table.foreign('user_id').references('id').inTable('user_account');
  });
};

module.exports.down = async (knex) => {
  // Remover foreign keys primeiro
  await knex.schema.alterTable('cards_chat', (table) => {
    table.dropForeign('card_id');
    table.dropForeign('user_id');
  });

  await knex.schema.alterTable('card', (table) => {
    table.dropForeign('linked_card_id');
    table.dropForeign('company_id');
  });

  await knex.schema.alterTable('user_account', (table) => {
    table.dropForeign('company_id');
  });

  // Remover tabelas e colunas
  await knex.schema.dropTable('cards_chat');

  await knex.schema.alterTable('card', (table) => {
    table.dropColumn('linked_card_id');
    table.dropColumn('company_id');
    table.dropColumn('numero');
    table.dropColumn('observacao');
    table.dropColumn('card_type');
  });

  await knex.schema.alterTable('user_account', (table) => {
    table.dropColumn('company_id');
    table.dropColumn('perfil');
  });

  await knex.schema.dropTable('company');
};
