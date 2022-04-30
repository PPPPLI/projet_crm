package com.workbench.service;

import com.workbench.domain.Clue;
import com.workbench.domain.ClueRemark;
import com.workbench.mapper.ClueRemarkMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {

    @Autowired
    ClueRemarkMapper clueRemarkMapper;

    @Override
    public List<ClueRemark> queryClueRemarkById(String id) {

        List<ClueRemark> clueRemarks = clueRemarkMapper.selectClueRemarkById(id);
        return  clueRemarks;
    }

    @Override
    public int insertClueRemark(ClueRemark clueRemark) {
        int insertResult = clueRemarkMapper.insertClueRemark(clueRemark);
        return insertResult;
    }

    @Override
    public ClueRemark queryClueRemarkByRid(String id) {
        ClueRemark clueRemark = clueRemarkMapper.selectClueRemarkByRid(id);
        return clueRemark;
    }

    @Override
    public int deleteClueRemarkById(String id) {
        int deleteResult = clueRemarkMapper.deleteClueRemarkById(id);
        return deleteResult;
    }

    @Override
    public int updateClueRemarkById(ClueRemark clueRemark) {
        int updateResult = clueRemarkMapper.updateClueRemarkById(clueRemark);
        return updateResult;
    }

    @Override
    public int deleteClueRemarkByClueId(String id) {
        int deleteResult = clueRemarkMapper.deleteClueRemarkByClueId(id);
        return deleteResult;
    }
}
