package com.workbench.service;

import com.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryService {

    List<TranHistory> queryAllHistoryByTranId(String id);
}
