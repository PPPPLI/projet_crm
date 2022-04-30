package com.workbench.service;

import com.workbench.domain.Customer;
import com.workbench.mapper.CustomerMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    CustomerMapper customerMapper;

    @Override
    public List<Customer> queryCustomerByCondition(Map<String,Object> map) {

        List<Customer> customers = customerMapper.selectCustomerByCondition(map);
        return customers;
    }

    @Override
    public int queryCountByCondition(Map<String, Object> map) {
        int countResult = customerMapper.selectCountByCondition(map);
        return countResult;
    }

    @Override
    public int addCustomer(Customer customer) {
        int addResult = customerMapper.insertCustomer(customer);
        return addResult;
    }

    @Override
    public int modifyCustomerById(Customer customer) {
        int modifyResult = customerMapper.updateCustomerById(customer);
        return modifyResult;
    }

    @Override
    public int deleteCustomerById(String[] id) {
        int deleteResult = customerMapper.deleteCustomerById(id);
        return deleteResult;
    }

    @Override
    public Customer queryCustomerById(String id) {
        Customer queryResult = customerMapper.selectCustomerById(id);
        return queryResult;
    }

    @Override
    public Customer queryCustomerDetailById(String id) {
        Customer customer = customerMapper.selectCustomerDetailById(id);
        return customer;
    }

    @Override
    public Customer queryOriginalCustomerById(String id) {
        Customer customer = customerMapper.selectOriginalCustomerById(id);
        return customer;
    }

    @Override
    public List<Customer> queryAllCustomer() {
        List<Customer> customerList = customerMapper.selectAllCustomer();
        return customerList;
    }

    @Override
    public List<Customer> queryCustomerNameByName() {
        List<Customer> customerList = customerMapper.queryCustomerNameByName();
        return customerList;
    }

    @Override
    public Customer queryCustomerByName(String name) {
        Customer customerList = customerMapper.selectCustomerByName(name);
        return customerList;
    }
}
