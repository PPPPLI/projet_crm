package com.workbench.service;

import com.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkService {

    List<CustomerRemark> queryCustomerRemarkById(String id);

    int addCustomerRemark(CustomerRemark customerRemark);

    CustomerRemark queryCustomerRemarkByRemarkId(String id);

    int deleteCustomerRemarkById(String id);

    int updateRemarkById(CustomerRemark customerRemark);
}
