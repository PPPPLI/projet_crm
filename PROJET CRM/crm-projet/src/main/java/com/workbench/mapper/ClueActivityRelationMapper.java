package com.workbench.mapper;

import com.workbench.domain.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_activity_relation
     *
     * @mbggenerated Thu Apr 21 22:04:54 CEST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_activity_relation
     *
     * @mbggenerated Thu Apr 21 22:04:54 CEST 2022
     */
    int insert(ClueActivityRelation record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_activity_relation
     *
     * @mbggenerated Thu Apr 21 22:04:54 CEST 2022
     */
    int insertSelective(ClueActivityRelation record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_activity_relation
     *
     * @mbggenerated Thu Apr 21 22:04:54 CEST 2022
     */
    ClueActivityRelation selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_activity_relation
     *
     * @mbggenerated Thu Apr 21 22:04:54 CEST 2022
     */
    int updateByPrimaryKeySelective(ClueActivityRelation record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_clue_activity_relation
     *
     * @mbggenerated Thu Apr 21 22:04:54 CEST 2022
     */
    int updateByPrimaryKey(ClueActivityRelation record);

    int insertRelations(List<ClueActivityRelation> clueActivityRelations);

    int deleteRelationById(ClueActivityRelation clueActivityRelation);

    List<ClueActivityRelation> selectRelationByTransfer(String clueId);
}