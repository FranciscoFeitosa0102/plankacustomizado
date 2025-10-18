/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

const { Profiles } = require('../../models/User');
const { CardTypes } = require('../../models/Card');

module.exports = {
  inputs: {
    card: {
      type: 'ref',
      required: true,
    },
    companyId: {
      type: 'string',
      required: true,
    },
    cardType: {
      type: 'string',
      required: true,
    },
    creatorUser: {
      type: 'ref',
      required: true,
    },
    request: {
      type: 'ref',
    },
  },

  async fn(inputs) {
    const { card, companyId, cardType, creatorUser, request } = inputs;

    // Buscar usuários da mesma empresa
    const companyUsers = await User.find({
      where: { companyId },
      select: ['id', 'perfil'],
    });

    // Separar indicadores e vendedores
    const indicadores = companyUsers.filter(user => user.perfil === Profiles.INDICADOR);
    const vendedores = companyUsers.filter(user => user.perfil === Profiles.VENDEDOR);

    // Se o criador é um indicador, criar cards espelhados para vendedores
    if (creatorUser.perfil === Profiles.INDICADOR && cardType === CardTypes.INDICACAO) {
      for (const vendedor of vendedores) {
        // Buscar o primeiro board do vendedor (ou criar um específico para indicações)
        const boardMembership = await BoardMembership.findOne({
          where: { userId: vendedor.id },
          select: ['boardId'],
        });

        if (boardMembership) {
          // Buscar a primeira lista do board
          const list = await List.findOne({
            where: { boardId: boardMembership.boardId },
            sort: 'position ASC',
          });

          if (list) {
            // Criar card espelhado para o vendedor
            const linkedCard = await Card.create({
              type: card.type,
              name: card.name,
              description: card.description,
              numero: card.numero,
              observacao: card.observacao,
              cardType: CardTypes.VENDA,
              companyId: card.companyId,
              linkedCardId: card.id,
              boardId: boardMembership.boardId,
              listId: list.id,
              creatorUserId: vendedor.id,
              position: 65536, // Posição padrão
              listChangedAt: new Date().toISOString(),
            }).fetch();

            // Notificar via WebSocket
            sails.sockets.broadcast(
              `board:${boardMembership.boardId}`,
              'cardCreate',
              {
                item: linkedCard,
              },
              request,
            );
          }
        }
      }
    }

    // Se o criador é um vendedor, criar card espelhado para indicadores
    if (creatorUser.perfil === Profiles.VENDEDOR && cardType === CardTypes.VENDA) {
      for (const indicador of indicadores) {
        // Buscar o primeiro board do indicador
        const boardMembership = await BoardMembership.findOne({
          where: { userId: indicador.id },
          select: ['boardId'],
        });

        if (boardMembership) {
          // Buscar a primeira lista do board
          const list = await List.findOne({
            where: { boardId: boardMembership.boardId },
            sort: 'position ASC',
          });

          if (list) {
            // Criar card espelhado para o indicador
            const linkedCard = await Card.create({
              type: card.type,
              name: card.name,
              description: card.description,
              numero: card.numero,
              observacao: card.observacao,
              cardType: CardTypes.INDICACAO,
              companyId: card.companyId,
              linkedCardId: card.id,
              boardId: boardMembership.boardId,
              listId: list.id,
              creatorUserId: indicador.id,
              position: 65536, // Posição padrão
              listChangedAt: new Date().toISOString(),
            }).fetch();

            // Notificar via WebSocket
            sails.sockets.broadcast(
              `board:${boardMembership.boardId}`,
              'cardCreate',
              {
                item: linkedCard,
              },
              request,
            );
          }
        }
      }
    }

    return card;
  },
};
