package com.workbench.service;

import com.workbench.domain.ClueActivityRelation;
import com.workbench.mapper.ClueActivityRelationMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {

    @Autowired
    ClueActivityRelationMapper clueActivityRelationMapper;
    @Override
    public int addRelations(List<ClueActivityRelation> clueActivityRelations) {

        int addResult = clueActivityRelationMapper.insertRelations(clueActivityRelations);
        return addResult;
    }

    @Override
    public int deleteRelation(ClueActivityRelation clueActivityRelation) {
        int deleteResult = clueActivityRelationMapper.deleteRelationById(clueActivityRelation);
        return deleteResult;
    }
}
