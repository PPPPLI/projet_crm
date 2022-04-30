<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){

		$(window).keydown(function (e) {
			//press entry to confirm
			if (e.keyCode == 13) {
				$("#searchBtn").click();
			}
		})

		//select the checkbox for delete or modification
		$("#checkbox").click(function (){

			$("#transList input[type='checkbox']").prop("checked",$("#checkbox").prop("checked"));
		})

		$("#transList").on("click","input[type=checkbox]",function (){

			if($("#transList input[type='checkbox']").size() == $("#transList input[type='checkbox']:checked").size()){

				$("#checkbox").prop("checked",true);

			}else {$("#checkbox").prop("checked",false);}
		})

		getTransByCondition(1,10);

		$("#searchBtn").click(function (){

			getTransByCondition(1,$("#pageDivide").bs_pagination("getOption","rowsPerPage"));
		})

		$("#clearBtn").click(function (){

			$("#search-Form")[0].reset()
			getTransByCondition(1,$("#pageDivide").bs_pagination("getOption","rowsPerPage"))
		})

		//to create page
		$("#createBtn").click(function (){

			window.location.href = "workbench/transaction/toCreatePage.do";
		})

		//to modify page
		$("#modifyBtn").click(function (){

			if ($("#transList input[type='checkbox']:checked").size() != 1){
				alert("Only one activity to modify at one time");
				return
			}
			var transId = $("#transList input[type='checkbox']:checked").val()
			window.location.href = "workbench/transaction/toModifyPage.do?id="+transId+"";
		})

		$("#deleteBtn").click(function (){

			if ($("#transList input[type='checkbox']:checked").size() != 1){
				alert("Only one activity to modify at one time");
				return
			}
			var id = $("#transList input[type='checkbox']:checked").val()
			$.ajax({
				url: 'workbench/transaction/deleteTranById.do',
				data: {id:id},
				dataType:'json',
				type:'post',
				success:function (data){

					if(data.returnCode == 1){
						getTransByCondition(1,$("#pageDivide").bs_pagination("getOption","rowsPerPage"))
					}else{
						alert(data.message);
					}
				}
			})
		})
		
	});

	//Get the transaction list by condition
	function getTransByCondition(pageNo,PageSize){

		var contactsId = $('#search-contact').val();
		var source = $('#search-source').val();
		var type = $('#search-type').val();
		var stage = $('#search-phase').val();
		var customerId = $('#search-company').val();
		var name = $('#search-name').val();
		var owner = $('#search-owner').val();
		$.ajax({
			url:'workbench/transaction/queryTransListByCondition.do',
			dataType:'json',
			type: 'post',
			data:{'contactsId':contactsId,
				'source':source,
				'type':type,
				'stage':stage,
				'customerId':customerId,
				'name':name,
				'owner':owner,
				'pageNo':pageNo,
				'pageSize':PageSize},
			//print on the page
			success:function (data){
				var stringHtml = '';
				$.each(data.tranList,function (index,obj){
					stringHtml += "<tr class=\"tranList\">";
					stringHtml +="<td><input type=\"checkbox\"  value=\""+obj.id+"\"></td>";
					stringHtml +="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/transaction/toDetailPage.do?id="+obj.id+"'\">"+obj.name+"</a></td>";
					stringHtml +="<td>"+obj.customerId+"</td>";
					stringHtml +="<td>"+obj.stage+"</td>";
					stringHtml +="<td>"+obj.type+"</td>";
					stringHtml +="<td>"+obj.owner+"</td>";
					stringHtml +="<td>"+obj.source+"</td>";
					stringHtml +="<td>"+obj.contactsId+"</td>";
					stringHtml +="</tr>";

				})

				$("#transList").html(stringHtml);

				//divide the page by pagination
				var totalPage = 0;
				if(data.tranCount % PageSize == 0){
					totalPage = data.tranCount/PageSize;
				}else {
					totalPage = parseInt(data.tranCount / PageSize)+1;
				}
				$("#pageDivide").bs_pagination({

					currentPage:pageNo,
					totalPages:totalPage,
					rowsPerPage:PageSize,
					totalRows:data.tranCount,
					visiblePageLinks: 5,
					showGoToPage:true,
					showRowsInfo:true,
					showRowsPerPage:true,

					onChangePage(event,pageObj){

						getTransByCondition(pageObj.currentPage,pageObj.rowsPerPage);
						$("#checkbox").prop("checked",false)
						$("#transList input[type='checkbox']").prop("checked",$("#checkbox").prop("checked"));
					}
				})
			}
		})
	}
	
</script>
</head>
<body>

	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3 style="color: #2d6ca2; font-weight: bold;font-family: 'times new roman';font-size:xx-large;">Transaction List</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px; " id="search-Form">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Owner</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" style="width: 70px">Name</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" style="width: 66px">Company</div>
				      <input class="form-control" type="text" id="search-company">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" style="width: 70px">Phase</div>
					  <select class="form-control" style="width: 201px" id="search-phase">
					  	<option></option>
					  	<c:forEach items="${stageList}" var="stage">
							<option value="${stage.id}">${stage.value}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
					<br>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" style="width: 66px">Type</div>
					  <select class="form-control" style="width: 201px" id="search-type">
					  	<option></option>
						<c:forEach items="${typeList}" var="type">
							<option value="${type.id}">${type.value}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Source</div>
				      <select class="form-control" id="search-source" style="width: 201px">
						  <option></option>
						  <c:forEach items="${sourceList}" var="source">
							  <option value="${source.id}">${source.value}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" style="width: 85px">Contact</div>
				      <input class="form-control" type="text" id="search-contact">
				    </div>
				  </div>
				  
				  	<button type="button" class="btn btn-default" id="searchBtn">Search</button>
					<button type="button" class="btn btn-default" id="clearBtn" style="width: 78px;color: red">Clear</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createBtn"><span class="glyphicon glyphicon-plus"></span> Create</button>
				  <button type="button" class="btn btn-default" id="modifyBtn"><span class="glyphicon glyphicon-pencil"></span> Modify</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> Delete</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkbox"/></td>
							<td>Name</td>
							<td>Company</td>
							<td>Phase</td>
							<td>Type</td>
							<td>Owner</td>
							<td>Source</td>
							<td>Contact</td>
						</tr>
					</thead>
					<tbody id="transList">

					</tbody>
				</table>
				<div id="pageDivide"></div>
			</div>

			<div style="height: 50px; position: relative;top: 20px;">


			</div>
			
		</div>
		
	</div>
</body>
</html>