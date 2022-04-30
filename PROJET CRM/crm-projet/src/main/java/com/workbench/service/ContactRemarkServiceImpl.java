package com.workbench.service;

import com.workbench.domain.ContactsRemark;
import com.workbench.mapper.ContactsRemarkMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ContactRemarkServiceImpl implements ContactRemarkService {

    @Autowired
    ContactsRemarkMapper contactsRemarkMapper;

    @Override
    public List<ContactsRemark> queryContactRemarkByContactId(String id) {

        List<ContactsRemark> contactsRemarkList = contactsRemarkMapper.selectContactRemarkByContactId(id);
        return contactsRemarkList;
    }

    @Override
    public int addRemarkByContactId(ContactsRemark contactsRemark) {
        int addResult = contactsRemarkMapper.insertContactRemarkByContactId(contactsRemark);
        return addResult;
    }

    @Override
    public ContactsRemark queryContactRemarkById(String id) {
        ContactsRemark contactsRemarkList = contactsRemarkMapper.selectContactRemarkById(id);
        return contactsRemarkList;
    }

    @Override
    public int deleteRemarkById(String id) {
        int deleteResult = contactsRemarkMapper.deleteRemarkById(id);
        return deleteResult;
    }

    @Override
    public int updateRemarkById(ContactsRemark contactsRemark) {
        int updateResult = contactsRemarkMapper.updateRemarkById(contactsRemark);
        return updateResult;
    }
}
