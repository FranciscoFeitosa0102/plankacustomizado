/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

import api from './index';

const getIndicacoesStats = () => api.get('/admin/indicacoes/stats');

const getTopIndicadores = () => api.get('/admin/indicacoes/top-indicadores');

export default {
  getIndicacoesStats,
  getTopIndicadores,
};
