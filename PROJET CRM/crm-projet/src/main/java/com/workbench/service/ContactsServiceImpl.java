package com.workbench.service;

import com.workbench.domain.Contacts;
import com.workbench.mapper.ContactsMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ContactsServiceImpl implements ContactsService {

    @Autowired
    ContactsMapper contactsMapper;

    @Override
    public List<Contacts> queryContactsByCustomerId(String id) {
        List<Contacts> contactsList = contactsMapper.selectContactsByCustomerId(id);
        return contactsList;
    }

    @Override
    public int addContact(Contacts contacts) {
        int addResult = contactsMapper.insertContact(contacts);
        return addResult;
    }

    @Override
    public Contacts queryContactById(String id) {
        Contacts contacts = contactsMapper.selectContactById(id);
        return contacts;
    }

    @Override
    public int deleteContactById(String id) {
        int deleteResult = contactsMapper.deleteContactById(id);
        return deleteResult;
    }

    @Override
    public List<Contacts> queryContactByCondition(Map<String, Object> map) {
        List<Contacts> contactsList = contactsMapper.selectContactsByCondition(map);
        return contactsList;
    }

    @Override
    public int queryCountByCondition(Map<String, Object> map) {
        int countResult = contactsMapper.selectCount(map);
        return countResult;
    }

    @Override
    public Contacts queryOriginalContact(String id) {
        Contacts contacts = contactsMapper.selectOriginalContactById(id);
        return contacts;
    }

    @Override
    public int updateContactById(Contacts contacts) {
        int updateResult = contactsMapper.updateContactById(contacts);
        return updateResult;
    }

    @Override
    public int deleteContactByIds(String[] id) {
        int deleteResult = contactsMapper.deleteContactByIds(id);
        return deleteResult;
    }

    @Override
    public List<Contacts> queryForTransSearch(String customerId) {
        List<Contacts> contactsList = contactsMapper.queryForTransSearch(customerId);
        return contactsList;
    }
}
