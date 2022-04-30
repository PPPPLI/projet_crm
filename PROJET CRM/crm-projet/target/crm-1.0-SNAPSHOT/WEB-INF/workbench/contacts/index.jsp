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
		

		$("#definedColumns > li").click(function(e) {

	        e.stopPropagation();
	    });

		$(".time").datetimepicker({
			minView: "month",
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			clearBtn:true,
			initialDate:new Date(),
		});

		getContactByCondition(1,10);

		$("#searchBtn").click(function (){

			getContactByCondition(1,$("#pageDivide").bs_pagination("getOption","rowsPerPage"))
		})

		$(window).keydown(function (e) {
			//press entry to confirm
			if (e.keyCode == 13) {
				$("#searchBtn").click();
			}
		})

		$("#clearBtn").click(function (){

			$("#searchForm")[0].reset()
			getContactByCondition(1,$("#pageDivide").bs_pagination("getOption","rowsPerPage"))
		})

		//select the checkbox for delete or modification
		$("#checkbox").click(function (){

			$("#contactList input[type='checkbox']").prop("checked",$("#checkbox").prop("checked"));
		})

		$("#contactList").on("click","input[type=checkbox]",function (){

			if($("#contactList input[type='checkbox']").size() == $("#contactList input[type='checkbox']:checked").size()){

				$("#checkbox").prop("checked",true);

			}else {$("#checkbox").prop("checked",false);}
		})

		//create the contact
		$("#createBtn").click(function (){

			$("#createContactsModal").modal("show");
		})

		$("#saveBtn").click(function (){

			var owner = $.trim($("#create-contactsOwner").val());
			var source = $("#create-clueSource").val();
			var fullName = $("#create-surname").val();
			var appellation = $.trim($("#create-call").val());
			var job = $.trim($("#create-job").val());
			var mPhone = $.trim($("#create-mphone").val());
			var email = $.trim($("#create-email").val())
			var birth = $.trim($("#create-birth").val());
			var customerId = $("#create-customerName").val();
			var description = $("#create-describe").val();
			var contactSummary = $.trim($("#create-contactSummary1").val());
			var nextContactTime = $("#create-nextContactTime1").val();
			var address = $.trim($("#edit-address1").val());

			//form check
			if (fullName == null || fullName == "" ){
				alert("Please fill the necessary information")
				return
			}

			var regPhone = /^(06|07)[0-9]{8}$/
			if(!regPhone.test(mPhone)){
				alert("Illegal landline number format")
				return
			}


			var regDate = /^[1-9]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/
			if(!regDate.test(nextContactTime)){

				alert("Illegal date format")
				return;
			}

			$.ajax({
				url:"workbench/contacts/insertContact.do",
				data:{
					"fullName":fullName,
					"appellation":appellation,
					"owner":owner,
					"customerId":customerId,
					"job":job,
					"mPhone":mPhone,
					"email":email,
					"source":source,
					"description":description,
					"contactSummary":contactSummary,
					"nextContactTime":nextContactTime,
					"address":address,
					"birth":birth
				},
				type: "post",
				dataType: "json",
				success:function (data){

					if (data.returnCode == 1){
						$("#createContactsModal").modal("hide");
						getContactByCondition(1,$("#pageDivide").bs_pagination("getOption","rowsPerPage"))
						$(".form-horizontal").get(0).reset();
					}else{
						alert(data.message);
					}
				}
			})
		})

		//Modify the clue
		$("#modifyBtn").click(function (){
			if($("#contactList input[type='checkbox']:checked").size() != 1){

				alert("Only one activity to modify at one time")
			}else{
				var id= $("#contactList input[type='checkbox']:checked").val()
				$.ajax({
					url:'workbench/contacts/queryContactById.do',
					dataType:'json',
					type:'post',
					data:{id:id},
					success:function (data){

						$("#edit-surname").val(data.fullName);
						$("#edit-call").val(data.appellation);
						$("#edit-contactsOwner").val(data.owner);
						$("#edit-customerName").val(data.customerId);
						$("#edit-job").val(data.job);
						$("#edit-email").val(data.email);
						$("#edit-birth").val(data.birth);
						$("#edit-mphone").val(data.mPhone);
						$("#edit-clueSource1").val(data.source);
						$("#edit-describe").val(data.description);
						$("#create-contactSummary").val(data.contactSummary);
						$("#create-nextContactTime").val(data.nextContactTime);
						$("#edit-address2").val(data.address);
					}
				})
				$("#editContactsModal").modal("show");
			}
		})

		//save the modification
		$("#updateBtn").click(function (){

			var id= $("#contactList input[type='checkbox']:checked").val()
			var fullName = $.trim($("#edit-surname").val());
			var appellation = $("#edit-call").val();
			var owner = $("#edit-contactsOwner").val();
			var customerId = $("#edit-customerName").val();
			var job = $.trim($("#edit-job").val());
			var email = $.trim($("#edit-email").val());
			var mPhone = $.trim($("#edit-mphone").val());
			var birth = $("#edit-birth").val();
			var source = $("#edit-clueSource1").val();
			var description = $.trim($("#edit-describe").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime = $("#create-nextContactTime").val();
			var address = $.trim($("#edit-address2").val());

			//form check
			if (fullName == null && fullName == ""){
				alert("Please fill the necessary information")
				return
			}
			var regMail = /^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/
			if(!regMail.test(email)){
				alert("Illegal email format")
				return;
			}



			var regmPhone = /^(06|07)[0-9]{8}$/
			if(!regmPhone.test(mPhone)){
				alert("Illegal cellphone number format")
				return;
			}

			var regDate = /^[1-9]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/
			if(!regDate.test(nextContactTime)){

				alert("Illegal date format")
				return;
			}
			$.ajax({
				url:"workbench/contacts/updateContactById.do",
				data:{
					"id":id,
					"fullName":fullName,
					"appellation":appellation,
					"owner":owner,
					"customerId":customerId,
					"job":job,
					"email":email,
					"mPhone":mPhone,
					"birth":birth,
					"source":source,
					"description":description,
					"contactSummary":contactSummary,
					"nextContactTime":nextContactTime,
					"address":address
				},
				type: "post",
				dataType: "json",
				success:function (data){

					if (data.returnCode == 1){

						$("#editContactsModal").modal("hide");
						getContactByCondition(1,$("#pageDivide").bs_pagination("getOption","rowsPerPage"))
					}else{
						alert(data.message);
					}
				}
			})
		})

		//delete the contact by id
		$("#deleteBtn").click(function (){

			var id = ""
			var idList = $("#contactList input[type='checkbox']:checked")

			if(idList.size() == 0){
				alert("Please select the contact")
			}else{
				if (window.confirm("Ready to delete?")){

					$.each(idList,function (index,obj){

						id += "id="+this.value+"&";
					})
					id = id.substring(0,id.length-1);

					$.ajax({
						url:'workbench/contacts/deleteContactByIds.do',
						data:id,
						dataType:'json',
						type:'post',
						success:function (data){
							if(data.returnCode = 1){
								getContactByCondition(1,$("#pageDivide").bs_pagination("getOption","rowsPerPage"))
							}else{
								alert(data.message);
							}
						}
					})
				}
			}
		})

	})

	//Get the contact list by condition
	function getContactByCondition(pageNo,PageSize){

		var fullName = $('#nameSearch').val();
		var customerId = $('#companySearch').val();
		var source = $('#sourceSearch').val();
		var birth = $('#birthSearch').val();
		var owner = $('#ownerSearch').val();

		$.ajax({
			url:'workbench/contacts/queryContactList.do',
			dataType:'json',
			type: 'post',
			data:{'fullName':fullName,
				'customerId':customerId,
				'birth':birth,
				'source':source,
				'owner':owner,
				'pageNo':pageNo,
				'pageSize':PageSize},
			//print on the page
			success:function (data){
				var stringHtml = '';
				$.each(data.contactsList,function (index,obj){
					stringHtml += "<tr class=\"contactsList\">";
					stringHtml +="<td><input type=\"checkbox\"  value=\""+obj.id+"\"></td>";
					stringHtml +="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/contacts/toDetailPage.do?id="+obj.id+"'\">"+obj.fullName+"</a></td>";
					stringHtml +="<td>"+obj.customerId+"</td>";
					stringHtml +="<td>"+obj.owner+"</td>";
					stringHtml +="<td>"+obj.source+"</td>";
					stringHtml +="<td>"+obj.birth+"</td>";
					stringHtml +="</tr>";

				})

				$("#contactList").html(stringHtml);

				//divide the page by pagination
				var totalPage = 0;
				if(data.countResult % PageSize == 0){
					totalPage = data.countResult/PageSize;
				}else {
					totalPage = parseInt(data.countResult / PageSize)+1;
				}
				$("#pageDivide").bs_pagination({

					currentPage:pageNo,
					totalPages:totalPage,
					rowsPerPage:PageSize,
					totalRows:data.countResult,
					visiblePageLinks: 5,
					showGoToPage:true,
					showRowsInfo:true,
					showRowsPerPage:true,

					onChangePage(event,pageObj){

						getContactByCondition(pageObj.currentPage,pageObj.rowsPerPage);
						$("#checkbox").prop("checked",false)
						$("#contactList input[type='checkbox']").prop("checked",$("#checkbox").prop("checked"));
					}
				})
			}
		})
	}
	
</script>
</head>
<body>

	
	<!-- Create contact modal -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">Create Contact</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-contactsOwner">
									<c:forEach items="${users}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">Source</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueSource">
								  <option></option>
									<c:forEach items="${source}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-surname" class="col-sm-2 control-label">Name<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
							<label for="create-call" class="col-sm-2 control-label">Appellation</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
								  <option></option>
									<c:forEach items="${appellation}" var="appellation">
										<option value="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								</select>
							</div>
							
						</div>

						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">Job</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">Phone</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>

						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">Mail</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">Birthday</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-birth">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">Company</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-customerName">
									<option></option>
									<c:forEach items="${customerList}" var="customer">
										<option value="${customer.id}">${customer.name}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-describe" class="col-sm-2 control-label">Description</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary1" class="col-sm-2 control-label">Contact Summary</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary1"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime1" class="col-sm-2 control-label time">Next Contact Time</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime1">
								</div>
							</div>
						</div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address1" class="col-sm-2 control-label">Address</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address1"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					<button type="button" class="btn btn-primary" id="saveBtn">Save</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Modify contact modal -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">Modify Contact</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-contactsOwner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-contactsOwner">
									<c:forEach items="${users}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-clueSource1" class="col-sm-2 control-label">Source</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueSource1">
								  <option></option>
									<c:forEach items="${source}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-surname" class="col-sm-2 control-label">Name<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname">
							</div>
							<label for="edit-call" class="col-sm-2 control-label">Appellation</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
								  <c:forEach items="${appellation}" var="appellation">
									  <option value="${appellation.id}">${appellation.value}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">Job</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">Phone</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">Mail</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">Birthday</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-birth">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">Company</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerName">
									<option></option>
									<c:forEach items="${customerList}" var="customer">
										<option value="${customer.id}">${customer.name}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">Description</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">Contact Summary</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">Next Contact Time</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address2" class="col-sm-2 control-label">Address</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address2"></textarea>
                                </div>
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
	
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3 style="color: #2d6ca2; font-weight: bold;font-family: 'times new roman';font-size:xx-large;">Contact List</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;" id="searchForm">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" style="width: 77px">Owner</div>
				      <input class="form-control" type="text" id="ownerSearch">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Name</div>
				      <input class="form-control" type="text" id="nameSearch">
				    </div>
				  </div>

				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Company</div>
				      <input class="form-control" type="text" id="companySearch">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" style="width: 67px">Source</div>
				      <select class="form-control" style="width: 201px" id="sourceSearch">
						  <option></option>
							<c:forEach items="${source}" var="source">
								<option value="${source.id}">${source.value}</option>
							</c:forEach>
					  </select>
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" style="width: 50px">Birthday</div>
				      <input class="form-control time" type="text" id="birthSearch">
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
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkbox"/></td>
							<td>Name</td>
							<td>Company</td>
							<td>Owner</td>
							<td>Source</td>
							<td>Birthday</td>
						</tr>
					</thead>
					<tbody id="contactList">

					</tbody>
				</table>
				<div id="pageDivide"></div>
			</div>
			
			<div style="height: 50px; position: relative;top: 10px;">

			</div>
			
		</div>
		
	</div>
</body>
</html>