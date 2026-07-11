package com.hwadee.fsc.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.hwadee.fsc.common.PageResult;
import com.hwadee.fsc.common.exception.BusinessException;
import com.hwadee.fsc.entity.Homework;
import com.hwadee.fsc.entity.Submission;
import com.hwadee.fsc.mapper.HomeworkMapper;
import com.hwadee.fsc.mapper.SubmissionMapper;
import com.hwadee.fsc.service.HomeworkService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class HomeworkServiceImpl implements HomeworkService {

    private final HomeworkMapper homeworkMapper;
    private final SubmissionMapper submissionMapper;

    @Override
    public PageResult<Homework> getList(int page, int pageSize) {
        LambdaQueryWrapper<Homework> wrapper = new LambdaQueryWrapper<>();
        wrapper.orderByDesc(Homework::getAssignedAt);

        Page<Homework> p = new Page<>(page, pageSize);
        Page<Homework> result = homeworkMapper.selectPage(p, wrapper);
        return PageResult.of(result.getRecords(), result.getTotal(), page, pageSize);
    }

    @Override
    public Homework getDetail(Long id) {
        Homework homework = homeworkMapper.selectById(id);
        if (homework == null) {
            throw new BusinessException("作业不存在");
        }
        return homework;
    }

    @Override
    public Submission getSubmission(Long homeworkId, Long studentId) {
        LambdaQueryWrapper<Submission> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Submission::getHomeworkId, homeworkId);
        wrapper.eq(Submission::getStudentId, studentId);

        Submission submission = submissionMapper.selectOne(wrapper);
        if (submission == null) {
            throw new BusinessException("未找到提交记录");
        }
        return submission;
    }

    @Override
    @Transactional
    public Homework create(Homework homework) {
        LocalDateTime now = LocalDateTime.now();
        homework.setAssignedAt(now);
        homework.setSubmissionCount(0);
        homework.setTotalStudents(homework.getTotalStudents() != null ? homework.getTotalStudents() : 0);
        homework.setStatus("active");

        homeworkMapper.insert(homework);
        return homework;
    }

    @Override
    @Transactional
    public Submission submit(Submission submission) {
        // Verify homework exists
        Homework homework = homeworkMapper.selectById(submission.getHomeworkId());
        if (homework == null) {
            throw new BusinessException("作业不存在");
        }

        // Check for duplicate submission
        LambdaQueryWrapper<Submission> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Submission::getHomeworkId, submission.getHomeworkId());
        wrapper.eq(Submission::getStudentId, submission.getStudentId());
        Submission existing = submissionMapper.selectOne(wrapper);

        LocalDateTime now = LocalDateTime.now();
        submission.setSubmittedAt(now);
        submission.setStatus("submitted");

        if (existing != null) {
            // Update existing submission
            submission.setId(existing.getId());
            submissionMapper.updateById(submission);
        } else {
            // Insert new submission
            submissionMapper.insert(submission);

            // Increment submission count on homework
            int count = homework.getSubmissionCount() != null ? homework.getSubmissionCount() + 1 : 1;
            homework.setSubmissionCount(count);
            homeworkMapper.updateById(homework);
        }

        return submission;
    }

    @Override
    @Transactional
    public Submission grade(Long submissionId, Integer score, String comment) {
        Submission submission = submissionMapper.selectById(submissionId);
        if (submission == null) {
            throw new BusinessException("提交记录不存在");
        }

        submission.setScore(score);
        submission.setTeacherComment(comment);
        submission.setStatus("graded");
        submissionMapper.updateById(submission);

        return submission;
    }
}
