/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

import api from '../api';

const ActionTypes = {
  INDICACOES_STATS_FETCH_REQUEST: 'INDICACOES_STATS_FETCH_REQUEST',
  INDICACOES_STATS_FETCH_SUCCESS: 'INDICACOES_STATS_FETCH_SUCCESS',
  INDICACOES_STATS_FETCH_FAILURE: 'INDICACOES_STATS_FETCH_FAILURE',
  TOP_INDICADORES_FETCH_REQUEST: 'TOP_INDICADORES_FETCH_REQUEST',
  TOP_INDICADORES_FETCH_SUCCESS: 'TOP_INDICADORES_FETCH_SUCCESS',
  TOP_INDICADORES_FETCH_FAILURE: 'TOP_INDICADORES_FETCH_FAILURE',
};

const fetchIndicacoesStats = () => async (dispatch) => {
  dispatch({
    type: ActionTypes.INDICACOES_STATS_FETCH_REQUEST,
  });

  try {
    const stats = await api.admin.getIndicacoesStats();

    dispatch({
      type: ActionTypes.INDICACOES_STATS_FETCH_SUCCESS,
      payload: {
        stats,
      },
    });
  } catch (error) {
    dispatch({
      type: ActionTypes.INDICACOES_STATS_FETCH_FAILURE,
      payload: {
        error,
      },
    });

    throw error;
  }
};

const fetchTopIndicadores = () => async (dispatch) => {
  dispatch({
    type: ActionTypes.TOP_INDICADORES_FETCH_REQUEST,
  });

  try {
    const indicadores = await api.admin.getTopIndicadores();

    dispatch({
      type: ActionTypes.TOP_INDICADORES_FETCH_SUCCESS,
      payload: {
        indicadores,
      },
    });
  } catch (error) {
    dispatch({
      type: ActionTypes.TOP_INDICADORES_FETCH_FAILURE,
      payload: {
        error,
      },
    });

    throw error;
  }
};

export {
  ActionTypes,
  fetchIndicacoesStats,
  fetchTopIndicadores,
};
