/*!
 * Copyright (c) 2024 PLANKA Software GmbH
 * Licensed under the Fair Use License: https://github.com/plankanban/planka/blob/master/LICENSE.md
 */

import React, { useCallback, useEffect, useRef, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useTranslation } from 'react-i18next';
import { Button, Form, Icon, Modal } from 'semantic-ui-react';

import selectors from '../../../selectors';
import entryActions from '../../../entry-actions';
import { useClosableModal } from '../../../hooks';
import UserAvatar from '../../users/UserAvatar';
import TimeAgo from '../../common/TimeAgo';

import styles from './CardChatModal.module.scss';

const CardChatModal = React.memo(({ cardId, onClose }) => {
  const { t } = useTranslation();
  const dispatch = useDispatch();

  const [message, setMessage] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const messagesEndRef = useRef(null);

  const currentUser = useSelector(selectors.selectCurrentUser);
  const chatMessages = useSelector((state) =>
    selectors.selectCardChatMessages(state, cardId)
  );

  const [ClosableModal, isClosableActiveRef] = useClosableModal();

  const scrollToBottom = useCallback(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, []);

  useEffect(() => {
    scrollToBottom();
  }, [chatMessages, scrollToBottom]);

  useEffect(() => {
    // Carregar mensagens do chat
    dispatch(entryActions.fetchCardChatMessages(cardId));
  }, [cardId, dispatch]);

  const handleSendMessage = useCallback(async () => {
    if (!message.trim() || isLoading) {
      return;
    }

    setIsLoading(true);
    try {
      await dispatch(entryActions.createCardChatMessage({
        cardId,
        message: message.trim(),
      }));
      setMessage('');
    } catch (error) {
      console.error('Erro ao enviar mensagem:', error);
    } finally {
      setIsLoading(false);
    }
  }, [cardId, message, isLoading, dispatch]);

  const handleKeyPress = useCallback((event) => {
    if (event.key === 'Enter' && !event.shiftKey) {
      event.preventDefault();
      handleSendMessage();
    }
  }, [handleSendMessage]);

  return (
    <ClosableModal
      open
      size="small"
      onClose={onClose}
      className={styles.modal}
    >
      <Modal.Header>
        <Icon name="chat" />
        {t('common.chat')}
      </Modal.Header>
      <Modal.Content className={styles.content}>
        <div className={styles.messages}>
          {chatMessages.map((msg) => (
            <div key={msg.id} className={styles.message}>
              <div className={styles.messageHeader}>
                <UserAvatar
                  user={msg.user}
                  size="small"
                  className={styles.avatar}
                />
                <div className={styles.messageInfo}>
                  <span className={styles.userName}>{msg.user.name}</span>
                  <TimeAgo date={msg.createdAt} className={styles.timestamp} />
                </div>
              </div>
              <div className={styles.messageText}>{msg.message}</div>
            </div>
          ))}
          <div ref={messagesEndRef} />
        </div>
        <div className={styles.inputArea}>
          <Form>
            <Form.TextArea
              value={message}
              onChange={(e) => setMessage(e.target.value)}
              onKeyPress={handleKeyPress}
              placeholder={t('common.typeMessage')}
              rows={2}
              className={styles.messageInput}
            />
            <Button
              primary
              onClick={handleSendMessage}
              disabled={!message.trim() || isLoading}
              loading={isLoading}
              className={styles.sendButton}
            >
              <Icon name="send" />
              {t('common.send')}
            </Button>
          </Form>
        </div>
      </Modal.Content>
    </ClosableModal>
  );
});

export default CardChatModal;
