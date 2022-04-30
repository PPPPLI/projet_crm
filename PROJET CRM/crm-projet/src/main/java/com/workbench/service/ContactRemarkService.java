package com.workbench.service;

import com.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactRemarkService {

    List<ContactsRemark> queryContactRemarkByContactId(String id);

    int addRemarkByContactId(ContactsRemark contactsRemark);

    ContactsRemark queryContactRemarkById(String id);

    int deleteRemarkById(String id);

    int updateRemarkById(ContactsRemark contactsRemark);


}
