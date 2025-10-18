/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

import { ActionTypes } from '../actions/cards-chat';

const initialState = {
  byCardId: {},
  isLoading: {},
  error: {},
};

const cardsChat = (state = initialState, action) => {
  switch (action.type) {
    case ActionTypes.CARD_CHAT_MESSAGES_FETCH_REQUEST: {
      const { cardId } = action.payload;

      return {
        ...state,
        isLoading: {
          ...state.isLoading,
          [cardId]: true,
        },
        error: {
          ...state.error,
          [cardId]: null,
        },
      };
    }

    case ActionTypes.CARD_CHAT_MESSAGES_FETCH_SUCCESS: {
      const { cardId, messages } = action.payload;

      return {
        ...state,
        byCardId: {
          ...state.byCardId,
          [cardId]: messages,
        },
        isLoading: {
          ...state.isLoading,
          [cardId]: false,
        },
      };
    }

    case ActionTypes.CARD_CHAT_MESSAGES_FETCH_FAILURE: {
      const { cardId, error } = action.payload;

      return {
        ...state,
        isLoading: {
          ...state.isLoading,
          [cardId]: false,
        },
        error: {
          ...state.error,
          [cardId]: error,
        },
      };
    }

    case ActionTypes.CARD_CHAT_MESSAGE_CREATE_REQUEST: {
      const { cardId } = action.payload;

      return {
        ...state,
        isLoading: {
          ...state.isLoading,
          [cardId]: true,
        },
      };
    }

    case ActionTypes.CARD_CHAT_MESSAGE_CREATE_SUCCESS: {
      const { cardId, message } = action.payload;

      return {
        ...state,
        byCardId: {
          ...state.byCardId,
          [cardId]: [
            ...(state.byCardId[cardId] || []),
            message,
          ],
        },
        isLoading: {
          ...state.isLoading,
          [cardId]: false,
        },
      };
    }

    case ActionTypes.CARD_CHAT_MESSAGE_CREATE_FAILURE: {
      const { cardId, error } = action.payload;

      return {
        ...state,
        isLoading: {
          ...state.isLoading,
          [cardId]: false,
        },
        error: {
          ...state.error,
          [cardId]: error,
        },
      };
    }

    case ActionTypes.CARD_CHAT_MESSAGE_RECEIVE: {
      const { message } = action.payload;

      return {
        ...state,
        byCardId: {
          ...state.byCardId,
          [message.cardId]: [
            ...(state.byCardId[message.cardId] || []),
            message,
          ],
        },
      };
    }

    default:
      return state;
  }
};

export default cardsChat;
