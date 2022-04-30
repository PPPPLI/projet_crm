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

		$(".time").datetimepicker(
				{autoclose:true,
					todayBtn:true,
					format:'yyyy-mm-dd',
					minView:'month',
					initialDate:new Date(),
					clearBtn:true,
					pickerPosition: "top-left"
				})
		getCustomerByCondition(1,10);

		$("#searchBtn").click(function (){

			getCustomerByCondition(1,$("#customerPage").bs_pagination("getOption","rowsPerPage"))
		})

		$("#clearBtn").click(function (){
			$("#search-form")[0].reset();
			getCustomerByCondition(1,$("#customerPage").bs_pagination("getOption","rowsPerPage"))
		})

		//select the checkbox for delete or modification
		$("#checkbox").click(function (){

			$("#customer-list input[type='checkbox']").prop("checked",$("#checkbox").prop("checked"));
		})

		$("#customer-list").on("click","input[type=checkbox]",function (){

			if($("#customer-list input[type='checkbox']").size() == $("#customer-list input[type='checkbox']:checked").size()){

				$("#checkbox").prop("checked",true);

			}else {$("#checkbox").prop("checked",false);}
		})

		$(window).keydown(function (e) {
			//press entry to confirm
			if (e.keyCode == 13) {
				$("#searchBtn").click();
			}
		})

		$("#createBtn").click(function(){

			$("#createCustomerModal").modal("show");
		})

		$("#saveBtn").click(function (){

			var name = $("#create-customerName").val();
			var phone =$("#create-phone").val();
			var nextContactTime = $("#create-nextContactTime").val();
			var website = $("#create-website").val();
			var regPhone = /^(01|02|03|04|05|08|09)[0-9]{8}$/;
			var regDate = /^[1-9]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/
			var owner = $('#create-customerOwner').val();
			var description = $('#create-describe').val();
			var address = $('#create-address1').val();
			var contactSummary = $('#create-contactSummary').val();
			if(name == null && name ==""){

				alert("Please fill the necessary information")
				return
			}
			if(!regPhone.test(phone)){
				alert("Illegal cellphone number format")
				return
			}
			if(!regDate.test(nextContactTime)){

				alert("Illegal date format");
					return
			}

			$.ajax({

				url:'workbench/customer/addCustomer.do',
				data: {name:name,phone:phone,nextContactTime:nextContactTime,website:website,owner:owner,
						description:description,address:address, contactSummary:contactSummary},
				dataType: 'json',
				type:'post',
				success:function (data){

					if(data.returnCode ==1){

						$("#createCustomerModal").modal("hide")
						getCustomerByCondition(1,$("#customerPage").bs_pagination("getOption","rowsPerPage"))
					}else{
						alert(data.message);
					}
				}
			})
		})

		//modify a customer info
		$("#modifyBtn").click(function (){


			if($("#customer-list input[type='checkbox']:checked").size() != 1){

				alert("Only one activity to modify at one time")
				return
			}else{


				var id= $("#customer-list input[type='checkbox']:checked").val()
				$.ajax({
					url:'workbench/customer/queryCustomerById.do',
					dataType:'json',
					type:'post',
					data:{id:id},
					success:function (data){

						$("#edit-customerOwner").val(data.owner);
						$("#edit-customerName").val(data.name);
						$("#edit-website").val(data.website);
						$("#edit-describe").val(data.description);
						$("#edit-contactSummary").val(data.contactSummary);
						$("#edit-nextContactTime").val(data.nextContactTime);
						$("#edit-address").val(data.address);
						$("#edit-phone").val(data.phone);
					}
				})
				$("#editCustomerModal").modal("show");
			}
		})

		$("#updateBtn").click(function (){
			var id= $("#customer-list input[type='checkbox']:checked").val()
			var name = $("#edit-customerName").val();
			var phone =$("#edit-phone").val();
			var nextContactTime = $("#edit-nextContactTime").val();
			var website = $("#edit-website").val();
			var regPhone = /^(01|02|03|04|05|08|09)[0-9]{8}$/;
			var regDate = /^[1-9]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/
			var owner = $('#edit-customerOwner').val();
			var description = $('#edit-describe').val();
			var address = $('#edit-address').val();
			var contactSummary = $('#edit-contactSummary').val();
			if(name == null && name ==""){

				alert("Please fill the necessary information")
				return
			}
			if(!regPhone.test(phone)){
				alert("Illegal cellphone number format")
				return
			}
			if(!regDate.test(nextContactTime)){

				alert("Illegal date format");
				return
			}

			$.ajax({

				url:'workbench/customer/updateCustomerById.do',
				data: {id:id,name:name,phone:phone,nextContactTime:nextContactTime,website:website,owner:owner,
					description:description,address:address, contactSummary:contactSummary},
				dataType: 'json',
				type:'post',
				success:function (data){

					if(data.returnCode ==1){

						$("#editCustomerModal").modal("hide")
						getCustomerByCondition(1,$("#customerPage").bs_pagination("getOption","rowsPerPage"))
					}else{
						alert(data.message);
					}
				}
			})
		})

		//delete the customer
		$("#deleteBtn").click(function (){

			var id = ""
			var idList = $("#customer-list input[type='checkbox']:checked")

			if(idList.size() == 0){
				alert("Please select the customer")
			}else{
				if (window.confirm("Ready to delete?")){

					$.each(idList,function (index,obj){

						id += "id="+this.value+"&";
					})
					id = id.substring(0,id.length-1);

					$.ajax({
						url:'workbench/customer/deleteCustomerById.do',
						data:id,
						dataType:'json',
						type:'post',
						success:function (data){
							if(data.returnCode == 1){
								getCustomerByCondition(1,$("#customerPage").bs_pagination("getOption","rowsPerPage"))
							}else{
								alert(data.message);
							}
						}
					})
				}
			}
		})
	});

	//Get the activities list by condition
	function getCustomerByCondition(pageNo,PageSize) {

		var name = $('#search-name').val();
		var owner = $('#search-owner').val();
		var phone = $('#search-phone').val();
		var website = $('#search-website').val();
		$.ajax({
			url: 'workbench/customer/queryCustomerList.do',
			dataType: 'json',
			type: 'post',
			data: {
				'name': name,
				'owner': owner,
				'phone': phone,
				'website': website,
				'pageNo': pageNo,
				'pageSize': PageSize
			},
			//print on the page
			success: function (data) {
				var stringHtml = '';
				$.each(data.customerList, function (index, obj) {
					stringHtml += "<tr class=\"customer\">";
					stringHtml += "<td><input type=\"checkbox\"  value=\"" + obj.id + "\"></td>";
					stringHtml += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/customer/customerDetailPage.do?id=" + obj.id + "'\">" + obj.name + "</a></td>";
					stringHtml += "<td>" + obj.owner + "</td>";
					stringHtml += "<td>" + obj.phone + "</td>";
					stringHtml += "<td><a style=\"text-decoration: none; cursor: pointer;\" href=\"http://"+obj.website+"\"; target='_blank' >" + obj.website + "</a></td>";
					stringHtml += "</tr>";

				})

				$("#customer-list").html(stringHtml);

				//divide the page by pagination
				var totalPage = 0;
				if (data.countResult % PageSize == 0) {
					totalPage = data.countResult / PageSize;
				} else {
					totalPage = parseInt(data.countResult / PageSize) + 1;
				}
				$("#customerPage").bs_pagination({

					currentPage: pageNo,
					totalPages: totalPage,
					rowsPerPage: PageSize,
					totalRows: data.countResult,
					visiblePageLinks: 5,
					showGoToPage: true,
					showRowsInfo: true,
					showRowsPerPage: true,
					onChangePage(event, pageObj) {
						getCustomerByCondition(pageObj.currentPage, pageObj.rowsPerPage);
						$("#checkbox").prop("checked", false)
						$("#customer-list input[type='checkbox']").prop("checked", $("#checkbox").prop("checked"));
					}
				})
			}
		})
	}
	
</script>
</head>
<body>

	<!-- Create customer modal -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">Create Customer</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-customerOwner">
								  <c:forEach items="${users}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">Company<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">Website</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">Phone</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">Description</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
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
                                <label for="create-address1" class="col-sm-2 control-label">Address</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address1"></textarea>
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
	
	<!-- modify customer modal -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">Modify</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerOwner">
									<c:forEach items="${users}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">Company<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" >
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">Website</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">phone</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
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
                                <label for="edit-contactSummary" class="col-sm-2 control-label">Contact Summary</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">Next Contact Time</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="edit-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">Address</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
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
				<h3 style="color: #2d6ca2; font-weight: bold;font-family: 'times new roman';font-size:xx-large;">Customer List</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;" id="search-form">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Name</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Owner</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Phone</div>
				      <input class="form-control" type="text" id="search-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">Website</div>
				      <input class="form-control" type="text" id="search-website">
				    </div>
				  </div>
				  
				  	<button type="button" class="btn btn-default" id="searchBtn">Search</button>
					<button type="button" class="btn btn-default" id="clearBtn" style="width: 78px;color: red">Clear</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
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
							<td><input type="checkbox" id="checkbox" /></td>
							<td>Company</td>
							<td>Owner</td>
							<td>Phone</td>
							<td>Website</td>
						</tr>
					</thead>
					<tbody id="customer-list">

					</tbody>
				</table>
				<div id="customerPage"></div>
			</div>

			<div style="height: 50px; position: relative;top: 30px;">


			</div>
			
		</div>
		
	</div>
</body>
</html>