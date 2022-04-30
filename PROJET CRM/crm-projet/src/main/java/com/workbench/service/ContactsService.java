package com.workbench.service;

import com.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsService {

    List<Contacts> queryContactsByCustomerId(String id);

    int addContact(Contacts contacts);

    Contacts queryContactById(String id);

    int deleteContactById(String id);

    List<Contacts> queryContactByCondition(Map<String,Object> map);

    int queryCountByCondition(Map<String,Object> map);

    Contacts queryOriginalContact(String id);

    int updateContactById(Contacts contacts);

    int deleteContactByIds(String[] id);

    List<Contacts> queryForTransSearch(String customerId);

}
