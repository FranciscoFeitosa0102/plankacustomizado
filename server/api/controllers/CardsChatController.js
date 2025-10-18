/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

module.exports = {
  /**
   * @swagger
   * /cards/{cardId}/chat:
   *   get:
   *     summary: Get chat messages for a card
   *     tags: [CardsChat]
   *     security:
   *       - bearerAuth: []
   *     parameters:
   *       - in: path
   *         name: cardId
   *         required: true
   *         schema:
   *           type: string
   *         description: Card ID
   *     responses:
   *       200:
   *         description: List of chat messages
   *         content:
   *           application/json:
   *             schema:
   *               type: array
   *               items:
   *                 $ref: '#/components/schemas/CardsChat'
   */
  index: async (request, response) => {
    const { cardId } = request.params;

    const messages = await CardsChat.find({
      where: { cardId },
      sort: 'createdAt ASC',
    }).populate('userId');

    response.ok(messages);
  },

  /**
   * @swagger
   * /cards/{cardId}/chat:
   *   post:
   *     summary: Send a message to card chat
   *     tags: [CardsChat]
   *     security:
   *       - bearerAuth: []
   *     parameters:
   *       - in: path
   *         name: cardId
   *         required: true
   *         schema:
   *           type: string
   *         description: Card ID
   *     requestBody:
   *       required: true
   *       content:
   *         application/json:
   *           schema:
   *             type: object
   *             required:
   *               - message
   *             properties:
   *               message:
   *                 type: string
   *                 description: Chat message
   *                 example: "Olá, como está o andamento?"
   *     responses:
   *       201:
   *         description: Message sent successfully
   *         content:
   *           application/json:
   *             schema:
   *               $ref: '#/components/schemas/CardsChat'
   *       400:
   *         description: Invalid input data
   */
  create: async (request, response) => {
    const { cardId } = request.params;
    const { message } = request.body;
    const { user } = request;

    if (!message || message.trim().length === 0) {
      return response.badRequest('Mensagem é obrigatória');
    }

    // Verificar se o card existe
    const card = await Card.findOne({ id: cardId });
    if (!card) {
      return response.notFound('Card não encontrado');
    }

    const chatMessage = await CardsChat.create({
      cardId,
      userId: user.id,
      message: message.trim(),
    }).fetch();

    // Buscar a mensagem com dados do usuário
    const messageWithUser = await CardsChat.findOne({ id: chatMessage.id }).populate('userId');

    // Emitir evento via WebSocket
    sails.sockets.broadcast(`card-${cardId}`, 'card-chat-message', {
      message: messageWithUser,
    });

    response.status(201).ok(messageWithUser);
  },
};
