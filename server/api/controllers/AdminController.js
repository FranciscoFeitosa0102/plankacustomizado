/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

const { Profiles } = require('../models/User');
const { CardTypes } = require('../models/Card');

module.exports = {
  /**
   * @swagger
   * /admin/indicacoes/stats:
   *   get:
   *     summary: Get indicações statistics
   *     tags: [Admin]
   *     security:
   *       - bearerAuth: []
   *     responses:
   *       200:
   *         description: Statistics data
   *         content:
   *           application/json:
   *             schema:
   *               type: object
   *               properties:
   *                 totalIndicacoes:
   *                   type: number
   *                 indicacoesFechadas:
   *                   type: number
   */
  getIndicacoesStats: async (request, response) => {
    try {
      // Total de indicações
      const totalIndicacoes = await Card.count({
        cardType: CardTypes.INDICACAO,
      });

      // Indicações fechadas (cards em listas de tipo "closed")
      const indicacoesFechadas = await Card.count({
        cardType: CardTypes.INDICACAO,
        isClosed: true,
      });

      response.ok({
        totalIndicacoes,
        indicacoesFechadas,
      });
    } catch (error) {
      response.serverError('Erro ao buscar estatísticas de indicações');
    }
  },

  /**
   * @swagger
   * /admin/indicacoes/top-indicadores:
   *   get:
   *     summary: Get top 5 indicadores
   *     tags: [Admin]
   *     security:
   *       - bearerAuth: []
   *     responses:
   *       200:
   *         description: Top indicadores data
   *         content:
   *           application/json:
   *             schema:
   *               type: array
   *               items:
   *                 type: object
   *                 properties:
   *                   id:
   *                     type: string
   *                   name:
   *                     type: string
   *                   totalIndicacoes:
   *                     type: number
   *                   indicacoesFechadas:
   *                     type: number
   */
  getTopIndicadores: async (request, response) => {
    try {
      // Buscar usuários com perfil de indicador
      const indicadores = await User.find({
        perfil: Profiles.INDICADOR,
        select: ['id', 'name'],
      });

      // Para cada indicador, contar suas indicações
      const indicadoresComStats = await Promise.all(
        indicadores.map(async (indicador) => {
          const totalIndicacoes = await Card.count({
            creatorUserId: indicador.id,
            cardType: CardTypes.INDICACAO,
          });

          const indicacoesFechadas = await Card.count({
            creatorUserId: indicador.id,
            cardType: CardTypes.INDICACAO,
            isClosed: true,
          });

          return {
            id: indicador.id,
            name: indicador.name,
            totalIndicacoes,
            indicacoesFechadas,
          };
        })
      );

      // Ordenar por total de indicações e pegar os top 5
      const topIndicadores = indicadoresComStats
        .filter(ind => ind.totalIndicacoes > 0)
        .sort((a, b) => b.totalIndicacoes - a.totalIndicacoes)
        .slice(0, 5);

      response.ok(topIndicadores);
    } catch (error) {
      response.serverError('Erro ao buscar top indicadores');
    }
  },
};
