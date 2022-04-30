package com.workbench.service;

import com.common.constance.Constance;
import com.common.utils.TimeFormat;
import com.common.utils.UUIDutils;
import com.settings.domain.User;
import com.workbench.domain.*;
import com.workbench.mapper.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class ClueServiceImpl implements ClueService {

    @Autowired
    ClueMapper clueMapper;

    @Autowired
    CustomerMapper customerMapper;

    @Autowired
    ContactsMapper contactsMapper;

    @Autowired
    ClueRemarkMapper clueRemarkMapper;

    @Autowired
    CustomerRemarkMapper customerRemarkMapper;

    @Autowired
    ContactsRemarkMapper contactsRemarkMapper;

    @Autowired
    ClueActivityRelationMapper clueActivityRelationMapper;

    @Autowired
    ContactsActivityRelationMapper contactsActivityRelationMapper;

    @Autowired
    TranMapper tranMapper;

    @Override
    public int addClue(Clue clue) {
        int addResult = clueMapper.insertClue(clue);
        return  addResult;
    }

    @Override
    public int clueCount(Map<String,Object> map) {
        int totalClue = clueMapper.clueCount(map);
        return totalClue;
    }

    @Override
    public List<Clue> queryClueByCondition(Map<String,Object> map) {

        List<Clue> queryResult = clueMapper.selectClueByCondition(map);
        return queryResult;
    }

    @Override
    public Clue queryOneClueById(String id) {
        Clue clueResult = clueMapper.selectOneClueById(id);
        return clueResult;
    }

    @Override
    public int updateClueById(Clue clue) {
        int updateResult = clueMapper.updateClueById(clue);
        return updateResult;
    }

    @Override
    public int deleteClueById(String[] id) {
        int deleteResult = clueMapper.deleteClueById(id);
        return deleteResult;
    }

    @Override
    public Clue queryClueById(String id) {
        Clue clue = clueMapper.selectClueById(id);
        return clue;
    }

    @Override
    public int deleteClue(String id) {
        int deleteResult = clueMapper.deleteClue(id);
        return deleteResult;
    }

    @Override
    public List<Activity> queryActivityByRelation(String clueId) {

       List<Activity> activities =  clueMapper.selectActivityByRelation(clueId);
       return activities;
    }

    @Override
    public void transferClue(Map<String, Object> map) {
        String id =(String)map.get("clueId");
        User user = (User)map.get(Constance.SESSION_USER);
        //By id select the clue
        Clue clue = clueMapper.selectOneClueById(id);

        //insert the company info to the customer table By clue
        Customer customer = new Customer();
        customer.setId(UUIDutils.getUUID());
        customer.setAddress(clue.getAddress());
        customer.setName(clue.getCompany());
        customer.setOwner(clue.getOwner());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(TimeFormat.dateToString(new Date()));
        customer.setEditBy(user.getId());
        customer.setEditTime(TimeFormat.dateToString(new Date()));
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setPhone(clue.getPhone());
        customer.setWebsite(clue.getWebsite());
        customerMapper.insertCustomerByTransfer(customer);

        //insert the personal info to the contact table By clue
        Contacts contacts = new Contacts();
        contacts.setSource(clue.getSource());
        contacts.setAddress(clue.getAddress());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(TimeFormat.dateToString(new Date()));
        contacts.setEditBy(user.getId());
        contacts.setEditTime(TimeFormat.dateToString(new Date()));
        contacts.setId(UUIDutils.getUUID());
        contacts.setAppellation(clue.getAppellation());
        contacts.setCustomerId(customer.getId());
        contacts.setEmail(clue.getEmail());
        contacts.setFullName(clue.getFullName());
        contacts.setJob(clue.getJob());
        contacts.setmPhone(clue.getmPhone());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setOwner(clue.getOwner());
        contactsMapper.insertContactByTransfer(contacts);

        //select the clue remark by clue id
        List<ClueRemark> clueRemarks = clueRemarkMapper.selectClueRemark(id);

        //insert to the customer and contact remark table by clue remark
        CustomerRemark customerRemark = null;
        ContactsRemark contactsRemark = null;
        List<CustomerRemark> customerRemarkList = new ArrayList<>();
        List<ContactsRemark> contactsRemarkList = new ArrayList<>();
        if(clueRemarks != null && clueRemarks.size() != 0){

            for (ClueRemark clueRemark:clueRemarks
                 ) {
                    customerRemark = new CustomerRemark();
                    customerRemark.setId(UUIDutils.getUUID());
                    customerRemark.setCustomerId(customer.getId());
                    customerRemark.setCreateBy(user.getId());
                    customerRemark.setCreateTime(TimeFormat.dateToString(new Date()));
                    customerRemark.setEditTime(TimeFormat.dateToString(new Date()));
                    customerRemark.setEditBy(user.getId());
                    customerRemark.setEditFlag(clueRemark.getEditFlag());
                    customerRemark.setNoteContent(clueRemark.getNoteContent());
                    customerRemarkList.add(customerRemark);

                    contactsRemark = new ContactsRemark();
                    contactsRemark.setId(UUIDutils.getUUID());
                    contactsRemark.setContactsId(contacts.getId());
                    contactsRemark.setCreateBy(user.getId());
                    contactsRemark.setCreateTime(TimeFormat.dateToString(new Date()));
                    contacts.setEditTime(TimeFormat.dateToString(new Date()));
                    contacts.setEditBy(user.getId());
                    contactsRemark.setEditFlag(clueRemark.getEditFlag());
                    contactsRemark.setNoteContent(clueRemark.getNoteContent());
                    contactsRemarkList.add(contactsRemark);
            }

            customerRemarkMapper.insertCustomerRemarkByTransfer(customerRemarkList);
            contactsRemarkMapper.insertContactRemarkByTransfer(contactsRemarkList);
        }

        //select clue activity relation by clue id
        List<ClueActivityRelation> clueActivityRelations = clueActivityRelationMapper.selectRelationByTransfer(id);
        ContactsActivityRelation contactsActivityRelation = null;
        List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>();
        if(clueActivityRelations != null && clueActivityRelations.size() != 0){

            //insert to contact activity relation table by clue activity relation
            for (ClueActivityRelation clueActivityRelation: clueActivityRelations
                 ) {
                contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setId(UUIDutils.getUUID());
                contactsActivityRelation.setContactsId(contacts.getId());
                contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
                contactsActivityRelationList.add(contactsActivityRelation);
            }
            contactsActivityRelationMapper.insertRelationByTransfer(contactsActivityRelationList);
        }

        String isCreate = (String) map.get("isCreate");

        if(isCreate.compareTo("true") == 0){
            Tran tran = new Tran();
            tran.setActivityId((String) map.get("activityId"));
            tran.setContactsId(contacts.getId());
            tran.setCreateBy(user.getId());
            tran.setCreateTime(TimeFormat.dateToString(new Date()));
            tran.setCustomerId(customer.getId());
            tran.setExpectedDate((String)map.get("expectedDate") );
            tran.setId(UUIDutils.getUUID());
            tran.setMoney((String) map.get("money"));
            tran.setStage((String) map.get("stage"));
            tran.setOwner(clue.getOwner());
            tran.setSource(clue.getSource());
            tran.setName((String) map.get("name"));
            tran.setNextContactTime(clue.getNextContactTime());
            tran.setEditBy(user.getId());
            tran.setEditTime(TimeFormat.dateToString(new Date()));
            tranMapper.insertTransByTransfer(tran);

            TranRemark tranRemark = null;
            List<TranRemark> tranRemarkList = new ArrayList<>();
            for (ClueRemark clueRemark:clueRemarks
                 ) {
                tranRemark = new TranRemark();
                tranRemark.setCreateBy(user.getId());
                tranRemark.setCreateTime(TimeFormat.dateToString(new Date()));
                tranRemark.setEditBy(user.getId());
                tranRemark.setEditTime(TimeFormat.dateToString(new Date()));
                tranRemark.setId(UUIDutils.getUUID());
                tranRemark.setEditFlag(clueRemark.getEditFlag());
                tranRemark.setTranId(tran.getId());
                tranRemark.setNoteContent(clueRemark.getNoteContent());

            }
        }
    }
}

