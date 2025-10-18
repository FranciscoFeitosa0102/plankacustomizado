/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

import { ActionTypes } from '../actions/admin';

const initialState = {
  indicacoesStats: {
    totalIndicacoes: 0,
    indicacoesFechadas: 0,
  },
  topIndicadores: [],
  isLoading: {
    stats: false,
    topIndicadores: false,
  },
  error: {
    stats: null,
    topIndicadores: null,
  },
};

const admin = (state = initialState, action) => {
  switch (action.type) {
    case ActionTypes.INDICACOES_STATS_FETCH_REQUEST:
      return {
        ...state,
        isLoading: {
          ...state.isLoading,
          stats: true,
        },
        error: {
          ...state.error,
          stats: null,
        },
      };

    case ActionTypes.INDICACOES_STATS_FETCH_SUCCESS:
      return {
        ...state,
        indicacoesStats: action.payload.stats,
        isLoading: {
          ...state.isLoading,
          stats: false,
        },
      };

    case ActionTypes.INDICACOES_STATS_FETCH_FAILURE:
      return {
        ...state,
        isLoading: {
          ...state.isLoading,
          stats: false,
        },
        error: {
          ...state.error,
          stats: action.payload.error,
        },
      };

    case ActionTypes.TOP_INDICADORES_FETCH_REQUEST:
      return {
        ...state,
        isLoading: {
          ...state.isLoading,
          topIndicadores: true,
        },
        error: {
          ...state.error,
          topIndicadores: null,
        },
      };

    case ActionTypes.TOP_INDICADORES_FETCH_SUCCESS:
      return {
        ...state,
        topIndicadores: action.payload.indicadores,
        isLoading: {
          ...state.isLoading,
          topIndicadores: false,
        },
      };

    case ActionTypes.TOP_INDICADORES_FETCH_FAILURE:
      return {
        ...state,
        isLoading: {
          ...state.isLoading,
          topIndicadores: false,
        },
        error: {
          ...state.error,
          topIndicadores: action.payload.error,
        },
      };

    default:
      return state;
  }
};

export default admin;
