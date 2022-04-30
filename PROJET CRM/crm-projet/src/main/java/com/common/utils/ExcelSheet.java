package com.common.utils;

import com.workbench.domain.Activity;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.format.CellFormatType;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;

import java.util.List;

public class ExcelSheet {

    public static HSSFWorkbook createExcelSheet(List<String> headRows,List<Activity> data){

        HSSFWorkbook wk = new HSSFWorkbook();
        HSSFSheet sheet = wk.createSheet("Page1");
        HSSFRow row1 = sheet.createRow(0);

        for (int i = 0; i<headRows.size();i++){

            HSSFCell cell = row1.createCell(i);
            cell.setCellValue(headRows.get(i));
        }

        for(int k = 0; k<data.size();k++){

            HSSFRow row = sheet.createRow(k+1);
            HSSFCell cell = row.createCell(k);
            cell.setCellValue(data.get(k).getId());
            cell = row.createCell(1);
            cell.setCellValue(data.get(k).getOwner());
            cell = row.createCell(2);
            cell.setCellValue(data.get(k).getName());
            cell = row.createCell(3);
            cell.setCellValue(data.get(k).getStartDate());
            cell = row.createCell(4);
            cell.setCellValue(data.get(k).getEndDate());
            cell = row.createCell(5);
            cell.setCellValue(data.get(k).getCost());
            cell = row.createCell(6);
            cell.setCellValue(data.get(k).getCreateTime());
            cell = row.createCell(7);
            cell.setCellValue(data.get(k).getCreateBy());
            cell = row.createCell(8);
            cell.setCellValue(data.get(k).getEditTime());
            cell = row.createCell(9);
            cell.setCellValue(data.get(k).getEditBy());
        }

        return wk;
    }

    public static String parseExcelToString(Cell cell){

        String cellValue = "";
        if(cell.getCellType() == CellType.STRING ){

            cellValue = cell.getStringCellValue();
        }else if (cell.getCellType() == CellType.NUMERIC){

            cellValue = cell.getNumericCellValue() + "";
        }else if(cell.getCellType() == CellType.FORMULA){

            cellValue = cell.getCellFormula() + "";

        }else if (cell.getCellType() == CellType.BOOLEAN){

            cellValue = cell.getBooleanCellValue() + "";
        }else{

            cellValue = " ";
        }

        return cellValue;
    }
}
