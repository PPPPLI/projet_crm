package com.workbench.service;

import com.workbench.domain.TranRemark;
import com.workbench.mapper.TranRemarkMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TranRemarkServiceImpl implements TranRemarkService {

    @Autowired
    TranRemarkMapper tranRemarkMapper;

    @Override
    public List<TranRemark> queryRemarkByTranId(String id) {
        List<TranRemark> tranRemarkList = tranRemarkMapper.selectTranRemarkByTranId(id);
        return  tranRemarkList;
    }
}
