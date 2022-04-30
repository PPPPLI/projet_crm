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

		$(".time").datetimepicker({
			minView: "month",
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			clearBtn:true,
			initialDate:new Date(),
			pickerPosition: "top-left"
		});

		$(window).keydown(function (e) {
			//press entry to confirm
			if (e.keyCode == 13) {
				$("#searchBtn").click();
			}
		})

		getClueByCondition(1,10);

		$("#searchBtn").click(function (){

			getClueByCondition(1,$("#pageDivide").bs_pagination("getOption","rowsPerPage"))
		})

		$("#clearBtn").click(function (){

			$("#searchForm")[0].reset()
			getClueByCondition(1,$("#pageDivide").bs_pagination("getOption","rowsPerPage"))
		})

		//select the checkbox for delete or modification
		$("#checkbox").click(function (){

			$("#clueList input[type='checkbox']").prop("checked",$("#checkbox").prop("checked"));
		})

		$("#clueList").on("click","input[type=checkbox]",function (){

			if($("#clueList input[type='checkbox']").size() == $("#clueList input[type='checkbox']:checked").size()){

				$("#checkbox").prop("checked",true);

			}else {$("#checkbox").prop("checked",false);}
		})

		//Modify the clue
		$("#modifyBtn").click(function (){
			if($("#clueList input[type='checkbox']:checked").size() != 1){

				alert("Only one activity to modify at one time")
			}else{
				var id= $("#clueList input[type='checkbox']:checked").val()
				$.ajax({
					url:'workbench/clue/getClueById.do',
					dataType:'json',
					type:'post',
					data:{id:id},
					success:function (data){

						$("#edit-fullName").val(data.fullName);
						$("#edit-appellation").val(data.appellation);
						$("#edit-owner").val(data.owner);
						$("#edit-company").val(data.company);
						$("#edit-job").val(data.job);
						$("#edit-email").val(data.email);
						$("#edit-phone").val(data.phone);
						$("#edit-website").val(data.website);
						$("#edit-mPhone").val(data.mPhone);
						$("#edit-status").val(data.state);
						$("#edit-source").val(data.source);
						$("#edit-describe").val(data.description);
						$("#edit-contactSummary").val(data.contactSummary);
						$("#edit-nextContactTime").val(data.nextContactTime);
						$("#edit-address").val(data.address);
					}
				})
				$("#editClueModal").modal("show");
			}
		})

		//save the modification
		$("#updateBtn").click(function (){

			var id= $("#clueList input[type='checkbox']:checked").val()
			var fullName = $.trim($("#edit-fullName").val());
			var appellation = $("#edit-appellation").val();
			var owner = $("#edit-owner").val();
			var company = $.trim($("#edit-company").val());
			var job = $.trim($("#edit-job").val());
			var email = $.trim($("#edit-email").val());
			var phone = $.trim($("#edit-phone").val())
			var website = $.trim($("#edit-website").val());
			var mPhone = $.trim($("#edit-mPhone").val());
			var state = $("#edit-status").val();
			var source = $("#edit-source").val();
			var description = $.trim($("#edit-describe").val());
			var contactSummary = $.trim($("#edit-contactSummary").val());
			var nextContactTime = $("#edit-nextContactTime").val();
			var address = $.trim($("#edit-address").val());

			//form check
			if (fullName == null && fullName == "" && appellation == null && appellation == "" && owner == null && owner == "" && company == null && company == "" &&
					source == null && source == "" && state == null && state == ""){
				alert("Please fill the necessary information")
				return
			}
			var regMail = /^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/
			if(!regMail.test(email)){
				alert("Illegal email format")
				return;
			}

			var regPhone = /^(01|02|03|04|05|08|09)[0-9]{8}$/
			if(!regPhone.test(phone)){
				alert("Illegal landline number format")
				return
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
				url:"workbench/clue/modifyClue.do",
				data:{
					"id":id,
					"fullName":fullName,
					"appellation":appellation,
					"owner":owner,
					"company":company,
					"job":job,
					"email":email,
					"phone":phone,
					"website":website,
					"mPhone":mPhone,
					"state":state,
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

						$("#editClueModal").modal("hide");
						getClueByCondition(1,$("#pageDivide").bs_pagination("getOption","rowsPerPage"))
					}else{
						alert(data.message);
					}
				}
			})
		})

		//delete the clue
		$("#deleteBtn").click(function (){

			var id = ""
			var idList = $("#clueList input[type='checkbox']:checked")

			if(idList.size() == 0){
				alert("Please select the clue")
			}else{
				if (window.confirm("Ready to delete?")){

					$.each(idList,function (index,obj){

						id += "id="+this.value+"&";
					})
					id = id.substring(0,id.length-1);

					$.ajax({
						url:'workbench/clue/deleteClue.do',
						data:id,
						dataType:'json',
						type:'post',
						success:function (data){
							if(data.returnCode = 1){
								getClueByCondition(1,$("#pageDivide").bs_pagination("getOption","rowsPerPage"))
							}else{
								alert(data.message);
							}
						}
					})
				}
			}
		})


		//Show on the insert clue modal
		$("#addBtn").click(function(){


			$("#createClueModal").modal("show");

		})

		//save a clue
		$("#saveBtn").click(function (){

			var fullName = $.trim($("#create-fullName").val());
			var appellation = $("#create-appellation").val();
			var owner = $("#create-owner").val();
			var company = $.trim($("#create-company").val());
			var job = $.trim($("#create-job").val());
			var email = $.trim($("#create-email").val());
			var phone = $.trim($("#create-phone").val())
			var website = $.trim($("#create-website").val());
			var mPhone = $.trim($("#create-mPhone").val());
			var state = $("#create-state").val();
			var source = $("#create-source").val();
			var description = $.trim($("#create-description").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime = $("#create-nextContactTime").val();
			var address = $.trim($("#create-address").val());

			//form check
			if (fullName == null || fullName == "" || appellation == null || appellation == "" || owner == null || owner == "" || company == null || company == "" ||
			    source == null || source == "" || state == null && state == ""){
				alert("Please fill the necessary information")
				return
			}
			var regMail = /^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/
			if(!regMail.test(email)){
				alert("Illegal email format")
				return;
			}

			var regPhone = /^(01|02|03|04|05|08|09)[0-9]{8}$/
			if(!regPhone.test(phone)){
				alert("Illegal landline number format")
				return
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
				url:"workbench/clue/addClue.do",
				data:{
					"fullName":fullName,
					"appellation":appellation,
					"owner":owner,
					"company":company,
					"job":job,
					"email":email,
					"phone":phone,
					"website":website,
					"mPhone":mPhone,
					"state":state,
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
						$("#createClueModal").modal("hide");
						getClueByCondition(1,$("#pageDivide").bs_pagination("getOption","rowsPerPage"))
						$(".form-horizontal").get(0).reset();
					}else{
						alert(data.message);
					}
				}
			})
		})


		
	});

	//Get the clue list by condition
	function getClueByCondition(pageNo,PageSize){

		var fullName = $('#search-name').val();
		var company = $('#search-company').val();
		var phone = $('#search-phone').val();
		var mPhone = $('#search-mPhone').val();
		var source = $('#search-source').val();
		var state = $('#search-state').val();
		var owner = $('#search-owner').val();
		$.ajax({
			url:'workbench/clue/getClueListToPage.do',
			dataType:'json',
			type: 'post',
			data:{'fullName':fullName,
				'company':company,
				'phone':phone,
				'mPhone':mPhone,
				'source':source,
				'state':state,
				'owner':owner,
				'pageNo':pageNo,
				'pageSize':PageSize},
			//print on the page
			success:function (data){
				var stringHtml = '';
				$.each(data.clueList,function (index,obj){
					stringHtml += "<tr class=\"clueList\">";
					stringHtml +="<td><input type=\"checkbox\"  value=\""+obj.id+"\"></td>";
					stringHtml +="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/clue/detail.do?id="+obj.id+"'\">"+obj.fullName+"</a></td>";
					stringHtml +="<td>"+obj.company+"</td>";
					stringHtml +="<td>"+obj.phone+"</td>";
					stringHtml +="<td>"+obj.mPhone+"</td>";
					stringHtml +="<td>"+obj.source+"</td>";
					stringHtml +="<td>"+obj.owner+"</td>";
					stringHtml +="<td>"+obj.state+"</td>";
					stringHtml +="</tr>";

				})

				$("#clueList").html(stringHtml);

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

						getClueByCondition(pageObj.currentPage,pageObj.rowsPerPage);
						$("#checkbox").prop("checked",false)
						$("#clueList input[type='checkbox']").prop("checked",$("#checkbox").prop("checked"));
					}
				})
			}
		})
	}
	
</script>
</head>
<body>

	<!-- Create clue modal -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">Create Clue</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
									<c:forEach items="${users}" var="s">
										<option value="${s.id}">${s.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">Company<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">Appellation</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
									<c:forEach items="${dicValuesAppellation}" var="a">
										<option value="${a.id}">${a.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-fullName" class="col-sm-2 control-label">Name<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullName">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">Job</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">Email</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">Landline</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">Website</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mPhone" class="col-sm-2 control-label">Cellphone</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mPhone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">Stage</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option></option>
									<c:forEach items="${dicValueClueState}" var="c">
										<option value="${c.id}">${c.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">Source</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
									<c:forEach items="${dicValueSource}" var="s">
										<option value="${s.id}">${s.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">Description</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
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
									<input type="text" class="form-control time" id="create-nextContactTime" >
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">Address</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
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
	
	<!-- Modity Clue Modal -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">Modify Clue</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
									<c:forEach items="${users}" var="s">
										<option value="${s.id}">${s.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">Company<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">Appellation</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
									<option></option>
									<c:forEach items="${dicValuesAppellation}" var="a">
										<option value="${a.id}">${a.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-fullName" class="col-sm-2 control-label">Name<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullName">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">Job</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">Email</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">Landline</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">Website</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mPhone" class="col-sm-2 control-label">Cellphone</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mPhone">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">Stage</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
								  <option></option>
									<c:forEach items="${dicValueClueState}" var="c">
										<option value="${c.id}">${c.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">Source</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${dicValueSource}" var="s">
										<option value="${s.id}">${s.value}</option>
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
								<label for="edit-contactSummary" class="col-sm-2 control-label">Contact Summary</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">Next Contact Time</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime">
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
				<h3 style="color: #2d6ca2; font-weight: bold;font-family: 'times new roman';font-size:xx-large;">Potential Client</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px; " id="searchForm" >
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon"  style="width: 66px">Name</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon"  style="width: 88px">Company</div>
				      <input class="form-control" type="text" id="search-company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >Landline</div>
				      <input class="form-control" type="text" id="search-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >Source</div>
					  <select class="form-control" id="search-source">
					  	  <option></option>
						  <c:forEach items="${dicValueSource}" var="s">
							  <option value="${s.id}">${s.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon"  style="align-items: center" >Owner</div>
				      <input class="form-control" type="text" id="search-owner" style="alignment: center">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >Cellphone</div>
				      <input class="form-control" type="text" id="search-mPhone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" style="width: 78px">State</div>
					  <select class="form-control" id="search-state"  style="width: 200px">
					  	<option></option>
						  <c:forEach items="${dicValueClueState}" var="s">
							  <option value="${s.id}">${s.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

					<button type="button" class="btn btn-default" id="searchBtn" style="width: 78px">Search</button>
					<button type="button" class="btn btn-default" id="clearBtn" style="width: 78px;color: red">Clear</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span>Create</button>
				  <button type="button" class="btn btn-default" id="modifyBtn"><span class="glyphicon glyphicon-pencil"></span>Modify</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span>Delete</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkbox"/></td>
							<td>Name</td>
							<td>Company</td>
							<td>Landline</td>
							<td>Cellphone</td>
							<td>Source</td>
							<td>Owner</td>
							<td>State
					</thead>
					<tbody id="clueList">

					</tbody>
				</table>
				<div id="pageDivide"></div>
			</div>

			<div style="height: 50px; position: relative;top: 30px;">


			</div>

		</div>
		
	</div>
</body>
</html>