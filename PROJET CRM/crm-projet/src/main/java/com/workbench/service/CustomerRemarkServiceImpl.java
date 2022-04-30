package com.workbench.service;

import com.workbench.domain.CustomerRemark;
import com.workbench.mapper.CustomerRemarkMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CustomerRemarkServiceImpl implements CustomerRemarkService {

    @Autowired
    CustomerRemarkMapper customerRemarkMapper;

    @Override
    public List<CustomerRemark> queryCustomerRemarkById(String id) {

        List<CustomerRemark> customerRemarkList = customerRemarkMapper.selectCustomerRemarkById(id);
        return customerRemarkList;
    }

    @Override
    public int addCustomerRemark(CustomerRemark customerRemark) {
        int addResult =  customerRemarkMapper.insertCustomerRemark(customerRemark);
        return addResult;
    }

    @Override
    public CustomerRemark queryCustomerRemarkByRemarkId(String id) {
        CustomerRemark customerRemark = customerRemarkMapper.selectCustomerRemarkByRemarkId(id);
        return customerRemark;
    }

    @Override
    public int updateRemarkById(CustomerRemark customerRemark) {
        int updateResult = customerRemarkMapper.updateRemarkById(customerRemark);
        return updateResult;
    }

    @Override
    public int deleteCustomerRemarkById(String id) {
        int deleteResult = customerRemarkMapper.deleteCustomerRemarkByRemarkId(id);
        return deleteResult;
    }
}
