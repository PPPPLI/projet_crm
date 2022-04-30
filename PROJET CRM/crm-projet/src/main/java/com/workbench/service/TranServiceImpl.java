package com.workbench.service;

import com.common.utils.TimeFormat;
import com.common.utils.UUIDutils;
import com.settings.domain.User;
import com.workbench.domain.Chart;
import com.workbench.domain.Tran;
import com.workbench.domain.TranHistory;
import com.workbench.mapper.TranHistoryMapper;
import com.workbench.mapper.TranMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class TranServiceImpl implements TranService {

    @Autowired
    TranMapper tranMapper;
    @Autowired
    TranHistoryMapper tranHistoryMapper;

    @Override
    public List<Tran> queryTranById(String id) {

        List<Tran> trans = tranMapper.selectTranById(id);
        return trans;
    }

    @Override
    public List<Tran> queryTransByContactId(String id) {
        List<Tran> trans = tranMapper.selectTranByContactId(id);
        return trans;
    }

    @Override
    public List<Tran> queryTransByCondition(Map<String, Object> map) {
        List<Tran> tranList = tranMapper.selectTranByCondition(map);
        return tranList;
    }

    @Override
    public int addTran(Tran tran) {
        int addResult = tranMapper.insertTran(tran);
        return addResult;
    }

    @Override
    public int queryCount(Map<String, Object> map) {
        int tranCount = tranMapper.selectTranCountByCondition(map);
        return tranCount;
    }

    @Override
    public int updateTran(Map<String,Object> map) {
        User user = (User) map.get("user");
        Tran tran =(Tran)map.get("tran");

        Tran oldTran = tranMapper.selectTranByTranId(tran.getId());

        TranHistory history = new TranHistory();
        history.setCreateBy(oldTran.getCreateBy());
        history.setCreateTime(oldTran.getCreateTime());
        history.setTranId(oldTran.getId());
        history.setExpectedDate(oldTran.getExpectedDate());
        history.setId(UUIDutils.getUUID());
        history.setMoney(oldTran.getMoney());
        history.setStage(oldTran.getStage());

        int updateResult = tranMapper.updateTran(tran);

        int insertHistory = tranHistoryMapper.insertHistory(history);

        int returnResult = updateResult + insertHistory;
        return returnResult;
    }

    @Override
    public Tran queryTranByTranId(String id) {
        Tran tran = tranMapper.selectTranByTranId(id);
        return tran;
    }

    @Override
    public Tran queryTranForDetail(String id) {
        Tran tranList = tranMapper.selectTranForDetail(id);
        return tranList;
    }

    @Override
    public int deleteTran(String id) {
        int deleteResult = tranMapper.deleteTranById(id);
        return deleteResult;
    }

    @Override
    public List<Chart> queryTranStage() {
        List<Chart> chartList = tranMapper.selectTranStage();
        return chartList;
    }
}
