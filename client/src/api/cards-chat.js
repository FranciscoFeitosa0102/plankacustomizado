/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

import api from './index';

const getMessages = (cardId) => api.get(`/cards/${cardId}/chat`);

const createMessage = (data) => api.post(`/cards/${data.cardId}/chat`, {
  message: data.message,
});

export default {
  getMessages,
  createMessage,
};
