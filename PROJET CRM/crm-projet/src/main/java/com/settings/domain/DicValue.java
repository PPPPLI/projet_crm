package com.settings.domain;

public class DicValue {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_dic_value.id
     *
     * @mbggenerated Wed Apr 20 10:56:11 CEST 2022
     */
    private String id;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_dic_value.value
     *
     * @mbggenerated Wed Apr 20 10:56:11 CEST 2022
     */
    private String value;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_dic_value.text
     *
     * @mbggenerated Wed Apr 20 10:56:11 CEST 2022
     */
    private String text;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_dic_value.orderNo
     *
     * @mbggenerated Wed Apr 20 10:56:11 CEST 2022
     */
    private String orderNo;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_dic_value.typeCode
     *
     * @mbggenerated Wed Apr 20 10:56:11 CEST 2022
     */
    private String typeCode;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public String getTypeCode() {
        return typeCode;
    }

    public void setTypeCode(String typeCode) {
        this.typeCode = typeCode;
    }
}