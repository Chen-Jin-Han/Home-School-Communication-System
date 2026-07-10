package com.hwadee.fsc.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hwadee.fsc.entity.Message;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MessageMapper extends BaseMapper<Message> {
}
