package com.workbench.service;

import com.workbench.domain.Customer;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;


public interface CustomerService {

    List<Customer> queryCustomerByCondition(Map<String,Object> map);

    int queryCountByCondition(Map<String,Object> map);

    int addCustomer(Customer customer);

    int modifyCustomerById(Customer customer);

    Customer queryCustomerById(String id);

    int deleteCustomerById(String[] id);

    Customer queryCustomerDetailById(String id);

    Customer queryOriginalCustomerById(String id);

    List<Customer> queryAllCustomer();

    Customer queryCustomerByName(String name);

    List<Customer> queryCustomerNameByName();
}
