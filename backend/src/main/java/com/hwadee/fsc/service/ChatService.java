package com.hwadee.fsc.service;

import com.hwadee.fsc.common.PageResult;
import com.hwadee.fsc.entity.Conversation;
import com.hwadee.fsc.entity.Message;
import java.util.List;

public interface ChatService {

    List<Conversation> getConversations(Long userId);

    PageResult<Message> getMessages(Long conversationId, int page, int pageSize);

    Message sendMessage(Message msg);
}
