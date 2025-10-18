/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

module.exports = {
  inputs: {
    card: {
      type: 'ref',
      required: true,
    },
    newListId: {
      type: 'string',
      required: true,
    },
    newPosition: {
      type: 'number',
      required: true,
    },
    request: {
      type: 'ref',
    },
  },

  async fn(inputs) {
    const { card, newListId, newPosition, request } = inputs;

    // Se o card tem um linkedCardId, sincronizar o movimento
    if (card.linkedCardId) {
      const linkedCard = await Card.findOne({ id: card.linkedCardId });

      if (linkedCard) {
        // Buscar a lista correspondente no board do card vinculado
        const newList = await List.findOne({ id: newListId });
        const linkedBoard = await Board.findOne({ id: linkedCard.boardId });

        // Buscar lista com mesmo nome no board vinculado
        const correspondingList = await List.findOne({
          where: {
            boardId: linkedCard.boardId,
            name: newList.name
          }
        });

        if (correspondingList) {
          // Atualizar posição do card vinculado
          await Card.updateOne({ id: linkedCard.id }).set({
            listId: correspondingList.id,
            position: newPosition,
            listChangedAt: new Date().toISOString(),
          });

          // Notificar via WebSocket
          sails.sockets.broadcast(
            `board:${linkedCard.boardId}`,
            'cardUpdate',
            {
              item: {
                id: linkedCard.id,
                listId: correspondingList.id,
                position: newPosition,
                listChangedAt: new Date().toISOString(),
              },
            },
            request,
          );
        }
      }
    }

    return card;
  },
};
