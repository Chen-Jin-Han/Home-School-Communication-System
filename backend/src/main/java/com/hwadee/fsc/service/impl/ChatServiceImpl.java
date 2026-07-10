package com.hwadee.fsc.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hwadee.fsc.common.PageResult;
import com.hwadee.fsc.common.exception.BusinessException;
import com.hwadee.fsc.entity.Conversation;
import com.hwadee.fsc.entity.Message;
import com.hwadee.fsc.entity.Participant;
import com.hwadee.fsc.mapper.ConversationMapper;
import com.hwadee.fsc.mapper.MessageMapper;
import com.hwadee.fsc.mapper.ParticipantMapper;
import com.hwadee.fsc.service.ChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ChatServiceImpl implements ChatService {

    private final ParticipantMapper participantMapper;
    private final ConversationMapper conversationMapper;
    private final MessageMapper messageMapper;

    @Override
    public List<Conversation> getConversations(Long userId) {
        // Find all participant records for this user
        LambdaQueryWrapper<Participant> participantWrapper = new LambdaQueryWrapper<>();
        participantWrapper.eq(Participant::getUserId, userId);
        List<Participant> participants = participantMapper.selectList(participantWrapper);

        if (participants.isEmpty()) {
            return Collections.emptyList();
        }

        // Get the conversation IDs
        List<Long> conversationIds = participants.stream()
                .map(Participant::getConversationId)
                .collect(Collectors.toList());

        // Query conversations
        LambdaQueryWrapper<Conversation> conversationWrapper = new LambdaQueryWrapper<>();
        conversationWrapper.in(Conversation::getId, conversationIds);
        conversationWrapper.orderByDesc(Conversation::getUpdatedAt);

        return conversationMapper.selectList(conversationWrapper);
    }

    @Override
    public PageResult<Message> getMessages(Long conversationId, int page, int pageSize) {
        LambdaQueryWrapper<Message> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Message::getConversationId, conversationId);
        wrapper.orderByAsc(Message::getCreatedAt);

        Page<Message> p = new Page<>(page, pageSize);
        Page<Message> result = messageMapper.selectPage(p, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), page, pageSize);
    }

    @Override
    @Transactional
    public Message sendMessage(Message message) {
        // Verify conversation exists
        Conversation conversation = conversationMapper.selectById(message.getConversationId());
        if (conversation == null) {
            throw new BusinessException("会话不存在");
        }

        // Set timestamp
        LocalDateTime now = LocalDateTime.now();
        message.setCreatedAt(now);
        message.setStatus("sent");

        // Insert message
        messageMapper.insert(message);

        // Update conversation last message and timestamp
        conversation.setLastMessage(truncateContent(message.getContent()));
        conversation.setUpdatedAt(now);
        conversationMapper.updateById(conversation);

        return message;
    }

    private String truncateContent(String content) {
        if (content == null) {
            return "";
        }
        return content.length() > 50 ? content.substring(0, 50) + "..." : content;
    }
}
