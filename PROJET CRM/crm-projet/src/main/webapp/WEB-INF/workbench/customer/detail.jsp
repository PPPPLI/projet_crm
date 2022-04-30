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

	//the save and cancel buttons are hided by default
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//set remarkDiv a 130px height
				$("#remarkDiv").css("height","130px");
				//display
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//display
			$("#cancelAndSaveBtn").hide();
			////set remarkDiv a 90px height
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

		$("#remarkDivList").on("mouseover",".remarkDiv",function () {
			$(this).children("div").children("div").show();
		});



		$("#remarkDivList").on("mouseout",".remarkDiv",function () {
			$(this).children("div").children("div").hide();
		});


		$("#remarkDivList").on("mouseover",".myHref",function () {
			$(this).children("span").css("color","red");
		});


		$("#remarkDivList").on("mouseout",".myHref",function () {
			$(this).children("span").css("color","#E6E6E6");
		})

		//Add the customer remark
		$("#saveCreateActivityRemarkBtn").click(function (){
			var customerId = $("#customerId").val()
			var noteContent = $.trim($("#remark").val())
			if(noteContent == null && noteContent == ""){
				alert("Please tape your remark!")
			}else{
				$.ajax({
					url:'workbench/customer/addCustomerRemark.do',
					data:{customerId:customerId,noteContent:noteContent},
					dataType:'json',
					type:'post',
					success:function (data){
						if(data.returnCode=="1"){
							//clear the textarea
							$("#remark").val("");
							//refresh the list
							var htmlStr="";
							htmlStr+="<div id=\"div_"+data.returnData.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">";
							htmlStr+="<img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
							htmlStr+="<div style=\"position: relative; top: -40px; left: 40px;\" >";
							htmlStr+="<h5>"+data.returnData.noteContent+"</h5>";
							htmlStr+="<b>"+data.returnData.createBy+"</b>   <small style=\"color: gray;\"> "+data.returnData.createTime+"| create by: ${sessionScope.sessionUser.name}</small>";
							htmlStr+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
							htmlStr+="<a class=\"myHref\" name=\"editA\" remarkId=\""+data.returnData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							htmlStr+="&nbsp;&nbsp;&nbsp;&nbsp;";
							htmlStr+="<a class=\"myHref\" name=\"deleteA\" remarkId=\""+data.returnData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
							htmlStr+="</div>";
							htmlStr+="</div>";
							htmlStr+="</div>";
							$("#remarkDiv").before(htmlStr);
						}else{
							//warning message
							alert(data.message);
						}
					}
				})
			}
		})

		//delete the remark
		$("#remarkDivList").on("click","a[name='deleteA']",function () {
			if(window.confirm("Ready to delete?")){


				var id=$(this).attr("remarkId");

				$.ajax({
					url:'workbench/customer/deleteRemarkById.do',
					data:{
						id:id
					},
					type:'post',
					dataType:'json',
					success:function (data) {
						if(data.returnCode=="1"){
							//refresh the list
							$("#div_"+id).remove();
						}else{
							//warning message
							alert(data.message);
						}
					}
				});
			}

		});

		$(".time").datetimepicker({
			minView: "month",
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});

		$("#create-birth").datetimepicker({
			minView: "month",
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
		});


		//Modify the clue remark
		$("#remarkDivList").on("click","a[name='editA']",function () {
			//get id and noteContent
			var id=$(this).attr("remarkId");
			var noteContent=$("#div_"+id+" h5").text();
			//put id and noteContent to modify remark modal
			$("#remarkId").val(id);
			$("#noteContent").val(noteContent);
			//display the modal
			$("#editRemarkModal").modal("show");
		});
		$("#updateRemarkBtnToModify").click(function () {
			//Collect arguments
			var id=$("#remarkId").val();
			var noteContent=$.trim($("#noteContent").val());
			//Form check
			if(noteContent==""){
				alert("Please tape your comment");
				return;
			}
			//Request
			$.ajax({
				url:'workbench/customer/updateRemarkById.do',
				data:{
					id:id,
					noteContent:noteContent
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.returnCode=="1"){
						//Close modal
						$("#editRemarkModal").modal("hide");
						//Refresh the list
						$("#div_"+data.returnData.id+" h5").text(data.returnData.noteContent);
						$("#div_"+data.returnData.id+" small").text(" "+data.returnData.editTime+" | edit by: ${sessionScope.sessionUser.name}");
					}else{
						//Notice
						alert(data.message);
						//Keep the modal on
						$("#editRemarkModal").modal("show");
					}
				}
			});
		});

		//create new contact
		$("#create-contact").click(function (){

			$("#createContactsModal").modal("show");
		})

		$("#save-contact").click(function (){

			var owner = $("#create-contactsOwner").val();
			var source = $("#create-clueSource").val();
			var appellation = $("#create-call").val();
			var job = $("#create-job").val();
			var mPhone = $("#create-mphone").val();
			var email = $("#create-email").val();
			var birth = $("#create-birth").val();
			var customerId = $("#customerId").val();
			var fullName = $("#create-surname").val();
			var description = $("#create-describe").val();
			var contactSummary = $("#edit-contactSummary").val();
			var nextContactTime = $("#edit-nextContactTime").val();
			var address = $("#edit-address1").val();

			//form check
			if (fullName == null || fullName == ""){
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
			if(!regDate.test(birth)){

				alert("Illegal date format")
				return;
			}

			$.ajax({
				url:'workbench/customer/addContact.do',
				dataType:'json',
				type:'post',
				data:{owner:owner,
					source:source,
					appellation:appellation,
					job:job,
					mPhone:mPhone,
					email:email,
					birth:birth,
					customerId:customerId,
					fullName:fullName,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address},
				success:function (data){
					var htmls = "";
					if(data.returnCode == 1){
						htmls+="<tr id=\"tr_"+data.returnData.id+"\">"
						htmls+="<td><a href=\"workbench/contacts/toDetailPage.do?id="+data.returnData.id+"\" style=\"text-decoration: none;\">"+data.returnData.fullName+"</a></td>"
						htmls+="<td>"+data.returnData.email+"</td>"
						htmls+="<td>"+data.returnData.mPhone+"</td>"
						htmls+="<td><a href=\"javascript:void(0);\" name= \"deleteA\" remarkId=\""+data.returnData.id+"\" style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>Delete</a></td>"
						htmls+="</tr>"

						$("#contactList").append(htmls);
						$("#createContactsModal").modal("hide")
					}else{
						alert(data.message);
					}
				}
			})

		})
		$("#contactList").on("click","a[name='deleteA']",function (){

			if(window.confirm("Ready to delete?")){

				//Collect arguments
				var id=$(this).attr("remarkId");
				//Request
				$.ajax({
					url:'workbench/customer/deleteContact.do',
					data:{
						id:id
					},
					type:'post',
					dataType:'json',
					success:function (data) {
						if(data.returnCode=="1"){
							//refresh the list
							$("#tr_"+id).remove();
						}else{
							//warning message
							alert(data.message);
						}
					}
				});
			}
		})

		$("#modifyCustomerBtn").click(function (){

			var id = $("#customerId").val()

			$.ajax({

				url:'workbench/customer/queryOriginalCustomer.do',
				data:{id:id},
				dataType:'json',
				type:'post',
				success:function (data){

					$("#edit-customerOwner").val(data.owner);
					$("#edit-customerName").val(data.name);
					$("#edit-website").val(data.website);
					$("#edit-phone").val(data.phone);
					$("#edit-describe").val(data.description);
					$("#create-contactSummary1").val(data.contactSummary);
					$("#create-nextContactTime2").val(data.nextContactTime);
					$("#edit-address").val(data.address);

					$("#editCustomerModal").modal("show")
				}
			})
		})

		$("#updateCustomerBtn").click(function () {

			var owner = $("#edit-customerOwner").val();
			var name = $("#edit-customerName").val();
			var id = $("#customerId").val();
			var website = $("#edit-website").val();
			var phone = $("#edit-phone").val();
			var description = $("#edit-describe").val();
			var contactSummary = $("#create-contactSummary1").val();
			var nextContactTime = $("#create-nextContactTime2").val();
			var address = $("#edit-address").val();

			//form check
			if (name == null || name == "") {
				alert("Please fill the necessary information")
				return
			}

			var regPhone = /^(01|02|03|04|05|08|09)[0-9]{8}$/
			if (!regPhone.test(phone)) {
				alert("Illegal landline number format")
				return
			}

			var regDate = /^[1-9]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/
			if (!regDate.test(nextContactTime)) {

				alert("Illegal date format")
				return;
			}

			$.ajax({
				url:"workbench/customer/updateCustomerById.do",
				data:{
					owner:owner,
					name:name,
					id:id,
					website:website,
					phone:phone,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address
				},
				dataType:'json',
				type:'post',
				success:function (data){

					if(data.returnCode == 1){
						var id = $("#customerId").val();
						window.location.href = "workbench/customer/customerDetailPage.do?id="+id;
					}else {

						alert(data.message);
					}
				}
			})
		})

		$("#deleteCustomerBtn").click(function (){

			var id = $("#customerId").val()
			if (window.confirm("Ready to delete?")){

				$.ajax({
					url:'workbench/customer/deleteCustomerById.do',
					dataType:'json',
					type:'post',
					data:{id:id},
					success:function (data){
						if(data.returnCode == 1){
							window.location.href = "workbench/customer/index.do"
						}else{
							alert(data.message);
						}
					}
				})
			}
		})


	})

</script>

</head>
<body>

	<!-- modal to update the clue remark-->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- Remark id --%>
		<input type="hidden" id="remarkId" value="">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModifiesModalLabel">Update Remark</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">Content</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					<button type="button" class="btn btn-primary" id="updateRemarkBtnToModify">Update</button>
				</div>
			</div>
		</div>
	</div>

	<!-- Delete contact modal -->
	<div class="modal fade" id="removeContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">Delete Contact</h4>
				</div>
				<div class="modal-body">
					<p>Ready to delete?</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
					<button type="button" class="btn btn-danger" id="deleteContactBtn">Delete</button>
				</div>
			</div>
		</div>
	</div>

	
	<!-- Create contact modal -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">Create Contact</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-contactsOwner">
								  <c:forEach items="${userList}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">Source</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueSource">
								  	<option></option>
									<c:forEach items="${sourceList}" var="source">
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
									<c:forEach items="${appellationList}" var="appellation">
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
							<label for="create-birth" class="col-sm-2 control-label">Birth</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-birth">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">Customer Name</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName" value="${customer.name}" readonly>
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
					<button type="button" class="btn btn-primary" id="save-contact">Save</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Modify contact modal -->
    <div class="modal fade" id="editCustomerModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">Modify Customer</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
						<input type="hidden" id="customerId" value="${customer.id}">
                        <div class="form-group">
                            <label for="edit-customerOwner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-customerOwner">
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
                                </select>
                            </div>
                            <label for="edit-customerName" class="col-sm-2 control-label">Name<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-customerName">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">Website</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website">
                            </div>
                            <label for="edit-phone" class="col-sm-2 control-label">Landline</label>
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
                                <label for="create-contactSummary1" class="col-sm-2 control-label">Contact Summary</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="create-contactSummary1"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="create-nextContactTime2" class="col-sm-2 control-label">Next Contact Time</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control time" id="create-nextContactTime2">
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
                    <button type="button" class="btn btn-primary" id="updateCustomerBtn">Update</button>
                </div>
            </div>
        </div>
    </div>

	<!-- return btn -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- title -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${customer.name}</h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="modifyCustomerBtn"><span class="glyphicon glyphicon-edit"></span> Modify</button>
			<button type="button" class="btn btn-danger" id="deleteCustomerBtn"><span class="glyphicon glyphicon-minus"></span> Delete</button>
		</div>
	</div>
	
	<!-- detail infomation -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">Owner</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;" ><b id="owner">${customer.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Name</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;" ><b id="name">${customer.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">Website</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;" ><b id="website"><a href="http://${customer.website}" target="_blank">${customer.website}</a></b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;" >Landline</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;" ><b id="phone">${customer.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">Create by</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;" ><b id="createBy">${customer.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="createTime">${customer.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">Edit by</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy">${customer.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="editTime">${customer.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 40px;">
            <div style="width: 300px; color: gray;">Contact Summary</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b id="contactSummary">
					${customer.contactSummary}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 50px;">
            <div style="width: 300px; color: gray;">Next contact time</div>
            <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="nextContactTime">${customer.nextContactTime}</b></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
        </div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">Description</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="description">
					${customer.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 70px;">
            <div style="width: 300px; color: gray;">Address</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b id="address">
					${customer.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- remark -->
	<div style="position: relative; top: 10px; left: 40px;" id="remarkDivList">
		<div class="page-header">
			<h4>Remark</h4>
		</div>

		<!-- remark -->
		<c:forEach items="${customerRemarkList}" var="remark">
			<div class="remarkDiv" style="height: 60px;" id="div_${remark.id}">
				<img title=${remark.createBy} src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${remark.noteContent}</h5>
					<b>${remark.createBy}</b> <small style="color: gray;">  ${remark.editFlag ==0?remark.createTime:remark.editTime}   ${remark.editFlag ==0?"| create by: ":"| edit by: "} ${remark.editFlag=='1'?remark.editBy:remark.createBy}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;" id="getIdBtn">
						<a class="myHref" name="editA" remarkId="${remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" name="deleteA" remarkId="${remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>

		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="Add your comment..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 710px; top: 15px; display: none">
					<button id="cancelBtn" type="button" class="btn btn-default">Cancel</button>
					<button type="button" class="btn btn-primary" id="saveCreateActivityRemarkBtn">Save</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- transaction -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>Transaction</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable2" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>Name</td>
							<td>Amount</td>
							<td>Phase</td>
							<td>Source</td>
							<td>Expected date</td>
							<td>Type</td>
							<td></td>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${tranList}" var="tran">
							<tr>
								<td><a href="workbench/transaction/toDetailPage.do?id=${tran.id}" style="text-decoration: none;">${tran.name}</a></td>
								<td>${tran.money}</td>
								<td>${tran.stage}</td>
								<td>${tran.source}</td>
								<td>${tran.expectedDate}</td>
								<td>${tran.type}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>

		</div>
	</div>
	
	<!-- contact -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>Contact</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>Name</td>
							<td>Mail</td>
							<td>Cellphone</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="contactList">
						<c:forEach items="${contactsList}" var="contact">
							<tr id="tr_${contact.id}">
								<td><a href="workbench/contacts/toDetailPage.do?id=${contact.id}" style="text-decoration: none;">${contact.fullName}</a></td>
								<td>${contact.email}</td>
								<td>${contact.mPhone}</td>
								<td><a href="javascript:void(0);" name="deleteA" remarkId="${contact.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>Delete</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="create-contact" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>New Contact</a>
			</div>
		</div>
	</div>
	
	<div style="height: 200px;"></div>
</body>
</html>