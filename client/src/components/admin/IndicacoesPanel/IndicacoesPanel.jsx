/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useTranslation } from 'react-i18next';
import { Card, Grid, Header, Icon, Statistic } from 'semantic-ui-react';

import selectors from '../../../selectors';
import entryActions from '../../../entry-actions';

import styles from './IndicacoesPanel.module.scss';

const IndicacoesPanel = React.memo(() => {
  const { t } = useTranslation();
  const dispatch = useDispatch();

  const stats = useSelector(selectors.selectIndicacoesStats);
  const topIndicadores = useSelector(selectors.selectTopIndicadores);

  useEffect(() => {
    dispatch(entryActions.fetchIndicacoesStats());
    dispatch(entryActions.fetchTopIndicadores());
  }, [dispatch]);

  return (
    <div className={styles.panel}>
      <Header as="h2" icon>
        <Icon name="chart bar" />
        {t('admin.indicacoesPanel')}
        <Header.Subheader>
          {t('admin.indicacoesPanelDescription')}
        </Header.Subheader>
      </Header>

      <Grid stackable>
        <Grid.Row>
          <Grid.Column width={8}>
            <Card fluid>
              <Card.Content>
                <Card.Header>{t('admin.totalIndicacoes')}</Card.Header>
                <Card.Description>
                  <Statistic>
                    <Statistic.Value>{stats.totalIndicacoes || 0}</Statistic.Value>
                    <Statistic.Label>{t('admin.totalIndicacoesLabel')}</Statistic.Label>
                  </Statistic>
                </Card.Description>
              </Card.Content>
            </Card>
          </Grid.Column>
          <Grid.Column width={8}>
            <Card fluid>
              <Card.Content>
                <Card.Header>{t('admin.indicacoesFechadas')}</Card.Header>
                <Card.Description>
                  <Statistic>
                    <Statistic.Value>{stats.indicacoesFechadas || 0}</Statistic.Value>
                    <Statistic.Label>{t('admin.indicacoesFechadasLabel')}</Statistic.Label>
                  </Statistic>
                </Card.Description>
              </Card.Content>
            </Card>
          </Grid.Column>
        </Grid.Row>

        <Grid.Row>
          <Grid.Column width={16}>
            <Card fluid>
              <Card.Content>
                <Card.Header>
                  <Icon name="trophy" />
                  {t('admin.topIndicadores')}
                </Card.Header>
                <Card.Description>
                  <div className={styles.ranking}>
                    {topIndicadores.map((indicador, index) => (
                      <div key={indicador.id} className={styles.rankingItem}>
                        <div className={styles.position}>
                          {index === 0 && <Icon name="trophy" color="yellow" />}
                          {index === 1 && <Icon name="trophy" color="grey" />}
                          {index === 2 && <Icon name="trophy" color="brown" />}
                          {index > 2 && <span className={styles.positionNumber}>{index + 1}</span>}
                        </div>
                        <div className={styles.userInfo}>
                          <div className={styles.userName}>{indicador.name}</div>
                          <div className={styles.userStats}>
                            {indicador.totalIndicacoes} {t('admin.indicacoes')} • {indicador.indicacoesFechadas} {t('admin.fechadas')}
                          </div>
                        </div>
                        <div className={styles.score}>
                          {Math.round((indicador.indicacoesFechadas / indicador.totalIndicacoes) * 100) || 0}%
                        </div>
                      </div>
                    ))}
                  </div>
                </Card.Description>
              </Card.Content>
            </Card>
          </Grid.Column>
        </Grid.Row>
      </Grid>
    </div>
  );
});

export default IndicacoesPanel;
