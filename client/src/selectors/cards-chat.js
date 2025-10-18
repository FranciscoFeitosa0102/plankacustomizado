/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

import { createSelector } from 'reselect';

const selectCardsChatState = (state) => state.cardsChat;

const selectCardChatMessages = createSelector(
  [selectCardsChatState, (state, cardId) => cardId],
  (cardsChat, cardId) => cardsChat.byCardId[cardId] || [],
);

const selectIsCardChatLoading = createSelector(
  [selectCardsChatState, (state, cardId) => cardId],
  (cardsChat, cardId) => cardsChat.isLoading[cardId] || false,
);

const selectCardChatError = createSelector(
  [selectCardsChatState, (state, cardId) => cardId],
  (cardsChat, cardId) => cardsChat.error[cardId] || null,
);

export {
  selectCardChatMessages,
  selectIsCardChatLoading,
  selectCardChatError,
};
