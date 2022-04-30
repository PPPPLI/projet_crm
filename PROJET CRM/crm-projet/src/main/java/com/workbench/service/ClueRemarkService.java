package com.workbench.service;

import com.workbench.domain.Clue;
import com.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkService {

    List<ClueRemark> queryClueRemarkById(String id);

    int insertClueRemark(ClueRemark clueRemark);

    ClueRemark queryClueRemarkByRid(String id);

    int deleteClueRemarkById(String id);

    int updateClueRemarkById(ClueRemark clueRemark);

    int deleteClueRemarkByClueId(String id);
}
