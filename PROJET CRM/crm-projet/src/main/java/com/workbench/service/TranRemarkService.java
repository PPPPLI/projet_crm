package com.workbench.service;

import com.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkService {

    List<TranRemark> queryRemarkByTranId(String id);
}
