package com.hwadee.fsc.controller;

import com.hwadee.fsc.common.ApiResponse;
import com.hwadee.fsc.common.PageResult;
import com.hwadee.fsc.dto.ChatMessageRequest;
import com.hwadee.fsc.entity.Conversation;
import com.hwadee.fsc.entity.Message;
import com.hwadee.fsc.service.ChatService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/conversations")
@RequiredArgsConstructor
@Tag(name = "即时通讯")
public class ChatController {

    private final ChatService chatService;

    @GetMapping
    @Operation(summary = "获取会话列表")
    public ApiResponse<List<Conversation>> list(@RequestHeader("X-User-Id") Long userId) {
        return ApiResponse.success(chatService.getConversations(userId));
    }

    @GetMapping("/{id}/messages")
    @Operation(summary = "获取会话消息")
    public ApiResponse<PageResult<Message>> messages(@PathVariable Long id,
                                                      @RequestParam(defaultValue = "1") int page,
                                                      @RequestParam(defaultValue = "20") int pageSize) {
        return ApiResponse.success(chatService.getMessages(id, page, pageSize));
    }

    @PostMapping("/{id}/messages")
    @Operation(summary = "发送消息")
    public ApiResponse<Message> sendMessage(@PathVariable Long id,
                                            @RequestHeader("X-User-Id") Long userId,
                                            @Valid @RequestBody ChatMessageRequest req) {
        Message msg = new Message();
        msg.setConversationId(id);
        msg.setSenderId(userId);
        msg.setContent(req.getContent());
        msg.setType("text");
        return ApiResponse.success(chatService.sendMessage(msg));
    }
}
