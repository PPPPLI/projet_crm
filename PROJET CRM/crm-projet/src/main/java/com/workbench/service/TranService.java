package com.workbench.service;

import com.workbench.domain.Chart;
import com.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranService {

    List<Tran> queryTranById(String id);

    List<Tran> queryTransByContactId(String id);

    List<Tran> queryTransByCondition(Map<String,Object> map);

    int queryCount(Map<String,Object> map);

    int addTran(Tran tran);

    Tran queryTranByTranId(String id);

    int updateTran(Map<String,Object> map);

    int deleteTran(String id);

    Tran queryTranForDetail(String id);

    List<Chart> queryTranStage();
}
