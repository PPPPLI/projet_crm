<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

		//add the click event for create button
		$("#addBtn").click(function () {


			$("#createActivityModal").modal("show");
        })

		$(window).keydown(function (e) {
			//press entry to confirm
			if (e.keyCode == 13) {
				$("#searchBtn").click();
			}
		})

        $("#saveBtn").click(function (){


			var owner = $("#create-owner").val();
			var name = $.trim($("#create-name").val());
			var startDate = $("#create-startDate").val();
			var endDate = $("#create-endDate").val();
			var cost = $("#create-cost").val();
			var description = $.trim($("#create-description").val());

			if(owner == "" || name == ""){

				alert("Please fill the necessary information")
				return;
			}
			if(startDate != "" && endDate != ""){

				if(startDate > endDate){

					alert("enddate can't be early than startdate");
					return;
				}
			}
			var regDate = /^[1-9]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/
			if(!regDate.test(startDate)&&regDate.test(endDate)){

				alert("Illegal date format")
				return;
			}

			var regCost = /^[1-9]\d*|0$/;

			if(!regCost.test(cost)){

				alert("The cost can't be negative");
				return
			}

			$.ajax({
				url:'workbench/activity/addActivity.do',
				data:{'owner':owner,
					  'name':name,
					  'startDate':startDate,
					  'endDate':endDate,
					  'cost':cost,
					  'description':description},
				dataType:'json',
				type:'post',
				success:function (data){
					if(data.returnCode == 1){

						getActivityByCondition(1,$("#activityPage").bs_pagination('getOption','rowsPerPage'));
						$("#createActivityModal").modal("hide");
						$(".form-horizontal")[0].reset;
					}else{
						alert(data.message);
						$("#createActivityModal").modal("show");
					}
				}
			})
		})

		$(".time").datetimepicker(
				{autoclose:true,
				 todayBtn:true,
				 format:'yyyy-mm-dd',
				 minView:'month',
				 initialDate:new Date(),
				 clearBtn:true
				})
		//clear the search
		$("#clearBtn").click(function (){

			$("#searchForm")[0].reset()
			getActivityByCondition(1,$("#activityPage").bs_pagination("getOption","rowsPerPage"))
		})

		//Get the activities list by condition for the first moment
		getActivityByCondition(1,10);

		//Search the activities list by condition
		$("#searchBtn").click(function (){

			getActivityByCondition(1,$("#activityPage").bs_pagination('getOption','rowsPerPage'));
			$(".form-inline")[0].reset();
		})

		//select the checkbox for delete or modification
		$("#chckBox").click(function (){

			$("#activityBody input[type='checkbox']").prop("checked",$("#chckBox").prop("checked"));
		})

		$("#activityBody").on("click","input[type=checkbox]",function (){

			if($("#activityBody input[type='checkbox']").size() == $("#activityBody input[type='checkbox']:checked").size()){

				$("#chckBox").prop("checked",true);

			}else {$("#chckBox").prop("checked",false);}
		})

		//delete the activities

		$("#deleteBtn").click(function(){

			var ids = "";
			var idList = $("#activityBody input[type='checkbox']:checked")

			if(idList.size()==0){
				alert("Please chose the activities you want to delete")
			}else{
				if (window.confirm("Ready to delete?")){

					$.each(idList,function (index,obj){

						ids += "id="+this.value+"&";
					})
					ids = ids.substring(0,ids.length-1);

					$.ajax({
						url:'workbench/activity/deleteActivitiesById.do',
						data:ids,
						dataType:'json',
						type:'post',
						success:function (data){
							if(data.returnCode == 1){
								getActivityByCondition(1,$("#activityPage").bs_pagination("getOption","rowsPerPage"));
							}else {
								alert(data.message);
							}
						}
					})
				}
			}
		})

		//modification of the activities
		//Get the activity info at first
		$("#editBtn").click(function (){
			var idList = $("#activityBody input[type='checkbox']:checked")

			if(idList.size() == 1){
				var id = idList[0].value;
				$.ajax({
					url:"workbench/activity/infoToModify.do",
					data:{'id':id},
					dataType:'json',
					type:'post',
					success:function (data){
						$("#edit-id").val(data.id);
						$("#edit-owner").val(data.owner);
						$("#edit-name").val( data.name);
						$("#edit-startDate").val(data.startDate) ;
						$("#edit-endDate").val(data.endDate);
						$("#edit-cost").val(data.cost);
						$("#edit-description").val(data.description);
						$("#editActivityModal").modal("show");
					}
				})
			}else {
				alert("Only one activity to modify at one time")
			}
		})

		//modify the info
		$("#updateBtn").click(function (){
			var owner = $("#edit-owner").val();
			var name = $("#edit-name").val();
			var startDate = $("#edit-startDate").val();
			var endDate = $("#edit-endDate").val();
			var cost = $("#edit-cost").val();
			var description = $("#edit-description").val();
			var id = $("#edit-id").val();

			if(owner == "" || name ==""){
				alert("Please fill the necessary information");
				return
			}
			if(startDate != "" && endDate != ""){

				if(startDate > endDate){

					alert("enddate can't be early than startdate");
					return;
				}
			}
			var regDate = /^[1-9]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/
			if(!regDate.test(startDate)&&regDate.test(endDate)){

				alert("Illegal date format")
				return;
			}
			var regCost = /^[1-9]\d*|0$/;

			if(!regCost.test(cost)){

				alert("The cost can't be negative");
				return
			}
			$.ajax({
				url:'workbench/activity/modifyActivity.do',
				data:{'id':id,'name':name,
					  'owner':owner,'startDate':startDate,
					  'endDate':endDate,'cost':cost,'description':description},
				dataType:'json',
				type:'post',
				success:function (data){
					if(data.returnCode == 1){
						getActivityByCondition(1,$("#activityPage").bs_pagination("getOption","rowsPerPage"))
						$("#editActivityModal").modal("hide");
						$(".form-horizontal")[0].reset;
					}else{
						alert(data.message);
					}
				}
			})
		})

		$("#exportActivityAllBtn").click(function (){

			if(window.confirm("Ready to download?")){

				window.location.href="workbench/activity/exportAllActivities.do";
			}

		})

		//export the selected activities
		$("#exportActivityXzBtn").click(function (){
			var ids = ""
			var idList = $("#activityBody input[type='checkbox']:checked")
			if(idList.size() == 0){
				alert("Please select the activity")
				return
			}else{

				$.each(idList,function (index,obj){

					ids += "id="+this.value+"&";
				})
				ids = ids.substring(0,ids.length-1);
				window.location.href="workbench/activity/exportActivitiesById.do?"+ids;
			}

		})

		//make the import modal on
		$("#importActivity").click(function (){

			$("#importActivityModal").modal("show")
		})

		$("#importActivityBtn").click(function (){

			var fileName = $("#activityFile").val();
			var suffix = fileName.substr(fileName.lastIndexOf(".")+1).toLocaleLowerCase();
			if(suffix != "xls"){
				alert("Only excel file please")
				return;
			}
			var activityFile = $("#activityFile")[0].files[0];
			if(activityFile.size > 5*1024*1024){
				alert("The max file size is 5MB")
				return;
			}
			var formData = new FormData;
			alert(activityFile);
			alert(activityFile.size);

			formData.append("activityFile",activityFile);
			$.ajax({
				url:'workbench/activity/addActivityByImport.do',
				dataType:'json',
				data:formData,
				processData:false,
				contentType:false,
				type:'post',
				success:function (data){
					if(data.returnCode == 1){

						alert(data.message);
						$("#importActivityModal").modal("hide")
						getActivityByCondition(1,$("#activityPage").bs_pagination("getOption","rowsPerPage"))
					}else {

						alert(data.message);
						$("#importActivityModal").modal("show");
					}

				}
			})
		})


    })

	//Get the activities list by condition
	function getActivityByCondition(pageNo,PageSize){

		var name = $('#search-name').val();
		var owner = $('#search-owner').val();
		var startDate = $('#search-startDate').val();
		var endDate = $('#search-endDate').val();
		$.ajax({
			url:'workbench/activity/queryActivityByCondition.do',
			dataType:'json',
			type: 'post',
			data:{'name':name,
				  'owner':owner,
				  'startDate':startDate,
				  'endDate':endDate,
				  'pageNo':pageNo,
				  'pageSize':PageSize},
			//print on the page
			success:function (data){
				var stringHtml = '';
				$.each(data.activityList,function (index,obj){
					stringHtml += "<tr class=\"active\">";
					stringHtml +="<td><input type=\"checkbox\"  value=\""+obj.id+"\"></td>";
					stringHtml +="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/detailInfoById.do?id="+obj.id+"'\">"+obj.name+"</a></td>";
					stringHtml +="<td>"+obj.owner+"</td>";
					stringHtml +="<td>"+obj.startDate+"</td>";
					stringHtml +="<td>"+obj.endDate+"</td>";
					stringHtml +="</tr>";

				})

				$("#activityBody").html(stringHtml);

				//divide the page by pagination
				var totalPage = 0;
				if(data.activityCount % PageSize == 0){
					totalPage = data.activityCount/PageSize;
				}else {
					totalPage = parseInt(data.activityCount / PageSize)+1;
				}
				$("#activityPage").bs_pagination({

					currentPage:pageNo,
					totalPages:totalPage,
					rowsPerPage:PageSize,
					totalRows:data.activityCount,
					visiblePageLinks: 5,
					showGoToPage:true,
					showRowsInfo:true,
					showRowsPerPage:true,
					onChangePage(event,pageObj){
						getActivityByCondition(pageObj.currentPage,pageObj.rowsPerPage);
						$("#chckBox").prop("checked",false)
						$("#activityBody input[type='checkbox']").prop("checked",$("#chckBox").prop("checked"));
					}
				})
			}
		})
	}
</script>
</head>
<body>

	<input type="hidden" id="hidden-name"/>
	<input type="hidden" id="hidden-owner"/>
	<input type="hidden" id="hidden-startDate"/>
	<input type="hidden" id="hidden-endDate"/>

	<!-- create activity modal -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">Create Activity</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="activityAddForm">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
                                    <c:forEach items="${resultList}" var="user">
                                        <option value="${user.id}">${user.name}</option>
                                    </c:forEach>
								</select>
							</div>
                            <label for="create-name" class="col-sm-2 control-label">Name<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">StartDate</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate" >
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">EndDate</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate" >
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">Cost</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">Description</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" id="btnClose" data-dismiss="modal">Close</button>
					<button type="button" class="btn btn-primary" id="saveBtn">Save</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Modify activity modal -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">Modify Activity</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
                        <input type="hidden" id="edit-id">
					
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
                                    <c:forEach items="${resultList}" var="user">
                                        <option value="${user.id}">${user.name}</option>
                                    </c:forEach>
								</select>
							</div>
                            <label for="edit-name" class="col-sm-2 control-label">Name<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">StartDate</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate">
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">EndDate</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">Cost</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">Description</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					<button type="button" class="btn btn-primary" id="updateBtn">Update</button>
				</div>
			</div>
		</div>
	</div>

	<!-- Import the activity -->
	<div class="modal fade" id="importActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">Import Activity</h4>
				</div>
				<div class="modal-body" style="height: 350px;">
					<div style="position: relative;top: 20px; left: 50px;">
						Please import your excel file：<small style="color: gray;">[Only.xls]</small>
					</div>
					<div style="position: relative;top: 40px; left: 50px;">
						<input type="file" id="activityFile">
					</div>
					<div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
						<h3>Notice</h3>
						<ul>
							<li>Only for Excel file</li>
							<li>First line must be the keywords</li>
							<li>Smaller than 5MB。</li>
							<li>Date must be the format yyyy-MM-dd</li>
							<li>Default encoding:UTF-8</li>
						</ul>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					<button id="importActivityBtn" type="button" class="btn btn-primary">Import</button>
				</div>
			</div>
		</div>
	</div>

	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3 style="color: #2d6ca2; font-weight: bold;font-family: 'times new roman';font-size:xx-large;">Activity Dashbord</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;" id="searchForm">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Name</div>
				      <input class="form-control" type="text" id="search-name" style="width: 150px">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Owner</div>
				      <input class="form-control" type="text" id="search-owner" style="width: 150px">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Start Date</div>
					  <input class="form-control time" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">End Date</div>
					  <input class="form-control time" type="text" id="search-endDate" />
				    </div>
				  </div>
				  
				 	 <button type="button" id="searchBtn" class="btn btn-default">Search</button>
					<button type="button" class="btn btn-default" id="clearBtn" style="width: 78px;color: red">Clear</button>
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> Create</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> Modify</button>
				  <button type="button" class="btn btn-danger"id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> Delete</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
					<button id="importActivity" type="button" class="btn btn-default"  ><span class="glyphicon glyphicon-import"></span> Import Excel File</button>
					<button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> Export Excel File(All)</button>
					<button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> Export Excel File（Selected）</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="chckBox"/></td>
							<td>Name</td>
                            <td>Owner</td>
							<td>Start Date</td>
							<td>End Date</td>
						</tr>
					</thead>
					<tbody id="activityBody">

					</tbody>
				</table>
				<div id="activityPage"></div>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">


			</div>
			
		</div>
		
	</div>
</body>
</html>