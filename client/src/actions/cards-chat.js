/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

import api from '../api';

const ActionTypes = {
  CARD_CHAT_MESSAGES_FETCH_REQUEST: 'CARD_CHAT_MESSAGES_FETCH_REQUEST',
  CARD_CHAT_MESSAGES_FETCH_SUCCESS: 'CARD_CHAT_MESSAGES_FETCH_SUCCESS',
  CARD_CHAT_MESSAGES_FETCH_FAILURE: 'CARD_CHAT_MESSAGES_FETCH_FAILURE',
  CARD_CHAT_MESSAGE_CREATE_REQUEST: 'CARD_CHAT_MESSAGE_CREATE_REQUEST',
  CARD_CHAT_MESSAGE_CREATE_SUCCESS: 'CARD_CHAT_MESSAGE_CREATE_SUCCESS',
  CARD_CHAT_MESSAGE_CREATE_FAILURE: 'CARD_CHAT_MESSAGE_CREATE_FAILURE',
  CARD_CHAT_MESSAGE_RECEIVE: 'CARD_CHAT_MESSAGE_RECEIVE',
};

const fetchCardChatMessages = (cardId) => async (dispatch) => {
  dispatch({
    type: ActionTypes.CARD_CHAT_MESSAGES_FETCH_REQUEST,
    payload: {
      cardId,
    },
  });

  try {
    const messages = await api.cardsChat.getMessages(cardId);

    dispatch({
      type: ActionTypes.CARD_CHAT_MESSAGES_FETCH_SUCCESS,
      payload: {
        cardId,
        messages,
      },
    });
  } catch (error) {
    dispatch({
      type: ActionTypes.CARD_CHAT_MESSAGES_FETCH_FAILURE,
      payload: {
        cardId,
        error,
      },
    });

    throw error;
  }
};

const createCardChatMessage = (data) => async (dispatch) => {
  dispatch({
    type: ActionTypes.CARD_CHAT_MESSAGE_CREATE_REQUEST,
    payload: {
      cardId: data.cardId,
    },
  });

  try {
    const message = await api.cardsChat.createMessage(data);

    dispatch({
      type: ActionTypes.CARD_CHAT_MESSAGE_CREATE_SUCCESS,
      payload: {
        cardId: data.cardId,
        message,
      },
    });

    return message;
  } catch (error) {
    dispatch({
      type: ActionTypes.CARD_CHAT_MESSAGE_CREATE_FAILURE,
      payload: {
        cardId: data.cardId,
        error,
      },
    });

    throw error;
  }
};

const receiveCardChatMessage = (message) => ({
  type: ActionTypes.CARD_CHAT_MESSAGE_RECEIVE,
  payload: {
    message,
  },
});

export {
  ActionTypes,
  fetchCardChatMessages,
  createCardChatMessage,
  receiveCardChatMessage,
};
