/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

import { createSelector } from 'reselect';

const selectAdminState = (state) => state.admin;

const selectIndicacoesStats = createSelector(
  [selectAdminState],
  (admin) => admin.indicacoesStats,
);

const selectTopIndicadores = createSelector(
  [selectAdminState],
  (admin) => admin.topIndicadores,
);

const selectIsAdminLoading = createSelector(
  [selectAdminState, (state, type) => type],
  (admin, type) => admin.isLoading[type] || false,
);

const selectAdminError = createSelector(
  [selectAdminState, (state, type) => type],
  (admin, type) => admin.error[type] || null,
);

export {
  selectIndicacoesStats,
  selectTopIndicadores,
  selectIsAdminLoading,
  selectAdminError,
};
