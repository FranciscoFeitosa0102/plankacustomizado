/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

const { Roles } = require('../models/User');

module.exports = {
  /**
   * @swagger
   * /companies:
   *   get:
   *     summary: List all companies
   *     tags: [Companies]
   *     security:
   *       - bearerAuth: []
   *     responses:
   *       200:
   *         description: List of companies
   *         content:
   *           application/json:
   *             schema:
   *               type: array
   *               items:
   *                 $ref: '#/components/schemas/Company'
   */
  index: async (request, response) => {
    const companies = await Company.find().sort('nome ASC');

    response.ok(companies);
  },

  /**
   * @swagger
   * /companies:
   *   post:
   *     summary: Create a new company
   *     tags: [Companies]
   *     security:
   *       - bearerAuth: []
   *     requestBody:
   *       required: true
   *       content:
   *         application/json:
   *           schema:
   *             type: object
   *             required:
   *               - nome
   *             properties:
   *               nome:
   *                 type: string
   *                 description: Company name
   *                 example: "Empresa ABC"
   *     responses:
   *       201:
   *         description: Company created successfully
   *         content:
   *           application/json:
   *             schema:
   *               $ref: '#/components/schemas/Company'
   *       400:
   *         description: Invalid input data
   */
  create: async (request, response) => {
    const { nome } = request.body;

    if (!nome) {
      return response.badRequest('Nome da empresa é obrigatório');
    }

    const company = await Company.create({
      nome,
    }).fetch();

    response.status(201).ok(company);
  },

  /**
   * @swagger
   * /companies/{id}:
   *   put:
   *     summary: Update a company
   *     tags: [Companies]
   *     security:
   *       - bearerAuth: []
   *     parameters:
   *       - in: path
   *         name: id
   *         required: true
   *         schema:
   *           type: string
   *         description: Company ID
   *     requestBody:
   *       required: true
   *       content:
   *         application/json:
   *           schema:
   *             type: object
   *             properties:
   *               nome:
   *                 type: string
   *                 description: Company name
   *                 example: "Empresa ABC Atualizada"
   *     responses:
   *       200:
   *         description: Company updated successfully
   *         content:
   *           application/json:
   *             schema:
   *               $ref: '#/components/schemas/Company'
   *       404:
   *         description: Company not found
   */
  update: async (request, response) => {
    const { id } = request.params;
    const { nome } = request.body;

    const company = await Company.updateOne({ id }).set({
      nome,
    });

    if (!company) {
      return response.notFound('Empresa não encontrada');
    }

    response.ok(company);
  },

  /**
   * @swagger
   * /companies/{id}:
   *   delete:
   *     summary: Delete a company
   *     tags: [Companies]
   *     security:
   *       - bearerAuth: []
   *     parameters:
   *       - in: path
   *         name: id
   *         required: true
   *         schema:
   *           type: string
   *         description: Company ID
   *     responses:
   *       204:
   *         description: Company deleted successfully
   *       404:
   *         description: Company not found
   */
  destroy: async (request, response) => {
    const { id } = request.params;

    const company = await Company.destroyOne({ id });

    if (!company) {
      return response.notFound('Empresa não encontrada');
    }

    response.status(204).send();
  },
};
