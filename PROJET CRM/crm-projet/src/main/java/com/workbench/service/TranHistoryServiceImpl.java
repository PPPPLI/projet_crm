package com.workbench.service;

import com.workbench.domain.TranHistory;
import com.workbench.mapper.TranHistoryMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TranHistoryServiceImpl implements TranHistoryService {

    @Autowired
    TranHistoryMapper tranHistoryMapper;

    @Override
    public List<TranHistory> queryAllHistoryByTranId(String id) {
        List<TranHistory> tranHistoryList = tranHistoryMapper.selectHistory(id);
        return tranHistoryList;
    }
}
