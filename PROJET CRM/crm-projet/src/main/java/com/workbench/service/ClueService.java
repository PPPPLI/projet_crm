package com.workbench.service;

import com.workbench.domain.Activity;
import com.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {

    int addClue(Clue clue);

    int clueCount(Map<String,Object> map);

    List<Clue> queryClueByCondition(Map<String,Object> map);

    Clue queryOneClueById(String id);

    int updateClueById(Clue clue);

    int deleteClueById(String[] id);

    Clue queryClueById(String id);

    int deleteClue(String id);

    List<Activity> queryActivityByRelation(String clueId);

    void transferClue(Map<String,Object> map);
}
