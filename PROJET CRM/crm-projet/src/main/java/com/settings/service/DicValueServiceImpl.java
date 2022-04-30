package com.settings.service;

import com.settings.domain.DicValue;
import com.settings.mapper.DicValueMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DicValueServiceImpl implements DicValueService {

    @Autowired
    DicValueMapper dicValueMapper;

    @Override
    public List<DicValue> queryDicValueByTypeCode(String typeCode) {
        List<DicValue> resultQuery = dicValueMapper.selectDicValue(typeCode);
        return resultQuery;
    }
}
