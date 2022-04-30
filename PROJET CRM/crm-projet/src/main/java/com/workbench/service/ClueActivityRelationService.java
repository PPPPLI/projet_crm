package com.workbench.service;

import com.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationService {

    int addRelations(List<ClueActivityRelation> clueActivityRelations);

    int deleteRelation(ClueActivityRelation clueActivityRelation);
}
