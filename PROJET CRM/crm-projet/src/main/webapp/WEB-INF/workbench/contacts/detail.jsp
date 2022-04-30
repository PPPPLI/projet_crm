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

		$("#edit-birth").datetimepicker({
			minView: "month",
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			clearBtn:true,
			initialDate:new Date(),
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

		//add the remark
		$("#saveRemark").click(function (){

			var contactsId = $("#contactId").val()
			var noteContent = $.trim($("#remark").val())
			if(noteContent == null && noteContent == ""){
				alert("Please tape your remark!")
			}else{
				$.ajax({
					url:'workbench/contacts/addRemark.do',
					data:{contactsId:contactsId,noteContent:noteContent},
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

		//delete remark
		$("#remarkDivList").on("click","a[name='deleteA']",function () {
			if(window.confirm("Ready to delete?")){


				var id=$(this).attr("remarkId");

				$.ajax({
					url:'workbench/contacts/deleteRemarkById.do',
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
				url:'workbench/contacts/updateRemarkById.do',
				data:{
					id:id,
					noteContent:noteContent
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.returnCode=="1"){
						//Close the modal
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

		//modify the contact info
		$("#modifyContactBtn").click(function (){

			var id = $("#contactId").val()

			$.ajax({

				url:'workbench/contacts/queryContactForModify.do',
				data:{id:id},
				dataType:'json',
				type:'post',
				success:function (data){

					$("#edit-contactsOwner").val(data.owner);
					$("#edit-clueSource").val(data.source);
					$("#edit-surname").val(data.fullName);
					$("#edit-call").val(data.appellation);
					$("#edit-job").val(data.job);
					$("#edit-mphone").val(data.mPhone);
					$("#edit-email").val(data.email);
					$("#edit-birth").val(data.birth);
					$("#edit-customerName").val(data.customerId);
					$("#edit-describe").val(data.description);
					$("#create-contactSummary").val(data.contactSummary);
					$("#create-nextContactTime").val(data.nextContactTime);
					$("#edit-address1").val(data.address);

					$("#editContactsModal").modal("show")
				}
			})
		})


		$("#updateBtn").click(function () {


			var id = $("#contactId").val()
			var owner = $("#edit-contactsOwner").val();
			var source = $("#edit-clueSource").val();
			var fullName = $("#edit-surname").val();
			var appellation = $("#edit-call").val();
			var job = $("#edit-job").val();
			var mPhone = $("#edit-mphone").val();
			var email = $("#edit-email").val();
			var birth = $("#edit-birth").val();
			var customerId = $("#edit-customerName").val();
			var description = $("#edit-describe").val();
			var contactSummary = $("#create-contactSummary").val();
			var nextContactTime = $("#create-nextContactTime").val();
			var address = $("#edit-address1").val();

			//form check
			if (fullName == null || fullName == "") {
				alert("Please fill the necessary information")
				return
			}

			var regPhone = /^(01|02|03|04|05|06|07|08|09)[0-9]{8}$/
			if (!regPhone.test(mPhone)) {
				alert("Illegal landline number format")
				return
			}

			var regDate = /^[1-9]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/
			if (!regDate.test(nextContactTime)) {

				alert("Illegal date format")
				return;
			}

			var regDate = /^[1-9]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/
			if (!regDate.test(birth)) {

				alert("Illegal birthday format")
				return;
			}

			$.ajax({
				url:"workbench/contacts/updateContactById.do",
				data:{
					id:id,
					owner:owner,
					source:source,
					fullName:fullName,
					appellation:appellation,
					job:job,
					mPhone:mPhone,
					email:email,
					birth:birth,
					customerId:customerId,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address
				},
				dataType:'json',
				type:'post',
				success:function (data){

					if(data.returnCode == 1){
						var id = $("#contactId").val()
						window.location.href = "workbench/contacts/toDetailPage.do?id="+id;
					}else {

						alert(data.message);
					}
				}
			})
		})

		//delete the contact info
		$("#deleteContactBtn").click(function (){

			var id = $("#contactId").val()
			if (window.confirm("Ready to delete?")){

				$.ajax({
					url:'workbench/contacts/deleteContactByIds.do',
					dataType:'json',
					type:'post',
					data:{id:id},
					success:function (data){
						if(data.returnCode == 1){
							window.location.href = "workbench/contacts/index.do"
						}else{
							alert(data.message);
						}
					}
				})
			}
		})
	});
	
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


	
	<!-- Modify contact modal -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">Modify Contact</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="contactId" value="${contacts.id}">
						<div class="form-group">
							<label for="edit-contactsOwner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-contactsOwner">
								  <c:forEach items="${users}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="edit-clueSource" class="col-sm-2 control-label">Source</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueSource">
								  <option></option>
									<c:forEach items="${source}" var="s">
										<option value="${s.id}">${s.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-surname" class="col-sm-2 control-label">Name<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" >
							</div>
							<label for="edit-call" class="col-sm-2 control-label">Appellation</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
									<c:forEach items="${appellation}" var="a">
										<option value="${a.id}">${a.value}</option>
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
							<label for="edit-email" class="col-sm-2 control-label">Email</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">Birthday</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-birth">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">Company</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerName">
									<option></option>
									<c:forEach items="${customerList}" var="c">
										<option value="${c.id}">${c.name}</option>
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
									<input type="text" class="form-control" id="create-nextContactTime">
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
					<button type="button" class="btn btn-primary" id="updateBtn">Update</button>
				</div>
			</div>
		</div>
	</div>

	<!-- return btn -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- title-->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${contacts.fullName}</h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="modifyContactBtn"><span class="glyphicon glyphicon-edit"></span> Modify</button>
			<button type="button" class="btn btn-danger" id="deleteContactBtn"><span class="glyphicon glyphicon-minus"></span> Delete</button>
		</div>
	</div>
	
	<!-- detail information -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">Owner</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Source</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">Company</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Name</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.fullName}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">Email</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Phone</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.mPhone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">Job</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.job}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Birthday</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${contacts.birth}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">Create by</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${contacts.createBy}&nbsp;</b><small style="font-size: 10px; color: gray;">${contacts.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">Edit by</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${contacts.editBy}&nbsp;</b><small style="font-size: 10px; color: gray;">${contacts.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">Description</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${contacts.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">Contact Summary</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${contacts.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">Next Contact Time</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${contacts.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 90px;">
            <div style="width: 300px; color: gray;">Address</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${contacts.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	<!-- remark -->
	<div style="position: relative; top: 20px; left: 40px;" id="remarkDivList">
		<div class="page-header">
			<h4>Remark</h4>
		</div>
		<!-- remark -->
		<c:forEach items="${contactsRemarkList}" var="remark">
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
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="Add remark..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 710px; top: 15px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">Cancel</button>
					<button type="button" class="btn btn-primary" id="saveRemark">Save</button>
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
				<table id="activityTable3" class="table table-hover" style="width: 900px;">
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
	<div style="height: 200px;"></div>
</body>
</html>