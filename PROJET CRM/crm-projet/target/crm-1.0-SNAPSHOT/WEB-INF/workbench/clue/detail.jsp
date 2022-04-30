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

		$("#edit-nextContactTime").datetimepicker({
			minView: "month",
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});

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

		//Add the clue remark
		$("#saveCreateActivityRemarkBtn").click(function (){
			var clueId =$("#clueId").val()
			var noteContent = $.trim($("#remark").val())
			if(noteContent == null && noteContent == ""){
				alert("Please tape your remark!")
			}else{
				$.ajax({
					url:'workbench/clue/addClueRemark.do',
					data:{clueId:clueId,noteContent:noteContent},
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

		//delete clue remark
		$("#remarkDivList").on("click","a[name='deleteA']",function () {
			if(window.confirm("Ready to delete?")){

				//Collect the arguments
				var id=$(this).attr("remarkId");
				//request
				$.ajax({
					url:'workbench/clue/deleteClueRemark.do',
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
			//put id and noteContent in modify remark modal
			$("#remarkId").val(id);
			$("#noteContent").val(noteContent);
			//display the modal
			$("#editRemarkModal").modal("show");
		});

		//add the click event to update button
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
				url:'workbench/clue/updateClueRemark.do',
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
						//refresh the list
						$("#div_"+data.returnData.id+" h5").text(data.returnData.noteContent);
						$("#div_"+data.returnData.id+" small").text(" "+data.returnData.editTime+" | edit by: ${sessionScope.sessionUser.name}");
					}else{
						//notice
						alert(data.message);
						//keep the modal on
						$("#editRemarkModal").modal("show");
					}
				}
			});
		});

		//Update the Clue
		$("#clueModifyBtn").click(function (){
			var id = $("#clueId").val()
			$.ajax({
				url:'workbench/clue/getClueById.do',
				data:{id:id},
				dataType:'json',
				type:'post',
				success:function (data){

					$("#edit-clueOwner").val(data.owner)
					$("#edit-call").val(data.appellation)
					$("#edit-source").val(data.source)
					$("#edit-status").val(data.state)
					$("#editClueModal").modal("show");
				}
			})
		})
		//Click on update
		$("#updateClueBtn").click(function (){

			var id = $("#clueId").val();
			var fullName = $.trim($("#edit-surname").val());
			var appellation = $("#edit-call").val();
			var owner = $("#edit-clueOwner").val();
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
						$("#appellation").text(data.returnData.appellation + data.returnData.fullName);
						$("#owner").text(data.returnData.owner);
						$("#company").text(data.returnData.company);
						$("#company1").text(data.returnData.company);
						$("#job").text(data.returnData.job);
						$("#email").text(data.returnData.email);
						$("#phone").text(data.returnData.phone);
						$("#website").text(data.returnData.website);
						$("#mPhone").text(data.returnData.mPhone);
						$("#state").text(data.returnData.state);
						$("#source").text(data.returnData.source);
						$("#description").text(data.returnData.description);
						$("#contactSummary").text(data.returnData.contactSummary);
						$("#nextContactTime").text(data.returnData.nextContactTime);
						$("#address").text(data.returnData.address);
						$("#editBy").text(data.returnData.editBy);
						$("#editTime").text(data.returnData.editTime);


					}else{
						alert(data.message);
					}
				}
			})
		})

		//Delete the Clue
		$("#clueDeleteBtn").click(function (){
			var id = $("#clueId").val();
			if (window.confirm("Ready to delete?")){

				$.ajax({
					url:'workbench/clue/deleteClueAndRemark.do',
					dataType:'json',
					type:'post',
					data:{id:id},
					success:function (data){
						if(data.returnCode == 1){
							window.location.href = "workbench/clue/index.do"
						}else{
							alert(data.message);
						}
					}
				})
			}

		})


		//add the click event to the activity relation button
		$("#bundActivityBtn").click(function () {
			//initialise the search content
			$("#searchActivityTxt").val("");
			$.ajax({
				url:'workbench/clue/queryAllActivities.do',
				dataType:'json',
				type: 'post',
				//print on the page
				success:function (data) {
					var stringHtml = '';
					$.each(data, function (index, obj) {
						stringHtml += "<tr class=\"active\">";
						stringHtml += "<td><input type=\"checkbox\"  value=\"" + obj.id + "\"></td>";
						stringHtml += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/detailInfoById.do?id=" + obj.id + "'\">" + obj.name + "</a></td>";
						stringHtml += "<td>" + obj.owner + "</td>";
						stringHtml += "<td>" + obj.startDate + "</td>";
						stringHtml += "<td>" + obj.endDate + "</td>";
						stringHtml += "</tr>";

					})
					$("#activitySearchBody").html(stringHtml);
					//open the modal
					$("#bundModal").modal("show");
				}
			})
		})

		$("#searchActivityTxt").keyup(function () {
			//Collect arguments
			var name=this.value;
			//Request
			$.ajax({
				url:'workbench/clue/queryActivityByName.do',
				data:{
					name:name,
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					//List the result
					var htmlStr="";
					$.each(data,function (index,obj) {
						htmlStr+="<tr>";
						htmlStr+="<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
						htmlStr+="<td>"+obj.name+"</td>";
						htmlStr+="<td>"+obj.startDate+"</td>";
						htmlStr+="<td>"+obj.endDate+"</td>";
						htmlStr+="<td>"+obj.owner+"</td>";
						htmlStr+="</tr>";
					});
					$("#activitySearchBody").html(htmlStr);
				}
			});
		});

		//and the click event to the bundBtn
		$("#bundBtn").click(function () {
			//Collect arguments
			//get all of the selected checkbox
			var chckedIds=$("#activitySearchBody input[type='checkbox']:checked");
			//form check
			if(chckedIds.size()==0){
				alert("Please chose the activity");
				return;
			}
			var id="";
			$.each(chckedIds,function () {
				id+="id="+this.value+"&";
			});
			id+="clueId=${clue.id}";

			//Request
			$.ajax({
				url:'workbench/clue/addRelation.do',
				data:id,
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.returnCode=="1"){
						//Close the modal
						$("#bundModal").modal("hide");
						//Refresh the list
						var htmlStr="";
						$.each(data.returnData,function (index,obj) {
							htmlStr+="<tr id=\"tr_"+obj.id+"\">";
							htmlStr+="<td>"+obj.name+"</td>";
							htmlStr+="<td>"+obj.startDate+"</td>";
							htmlStr+="<td>"+obj.endDate+"</td>";
							htmlStr+="<td>"+obj.owner+"</td>";
							htmlStr+="<td><a href=\"javascript:void(0);\" activityId=\""+obj.id+"\"  style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>";
							htmlStr+="</tr>";
						});
						$("#activityBody").html(htmlStr);
					}else{
						//Notice
						alert(data.message);
						//Keep the modal on
						$("#bundModal").modal("show");
					}
				}
			});
		});

		//delete the relation
		$("#activityBody").on("click","a",function () {
			//Collect arguments
			var activityId=$(this).attr("activityId");
			var clueId="${clue.id}";

			if(window.confirm("Ready to delete?")){
				//Request
				$.ajax({
					url:'workbench/clue/deleteRelation.do',
					data:{
						activityId:activityId,
						clueId:clueId
					},
					type:'post',
					dataType:'json',
					success:function (data) {
						if(data.returnCode=="1"){
							//Refresh the list
							$("#tr_"+activityId).remove();
						}else{
							//Notice
							alert(data.message);
						}
					}
				});
			}
		});

		$("#transferBtn").click(function (){

			window.location.href = "workbench/clue/toTransferPage.do?id=${clue.id}";
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
					<h4 class="modal-title" id="myModifiesModalLabel">Modify Remark</h4>
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

	<!-- Activity Clue Relation -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">Activity Clue Relation</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="searchActivityTxt" style="width: 300px;">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox"/></td>
								<td>Name</td>
								<td>StartDate</td>
								<td>EndDate</td>
								<td>Owner</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activitySearchBody">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
					<button type="button" class="btn btn-primary" id="bundBtn">Associate</button>
				</div>
			</div>
		</div>
	</div>

    <!-- Modify clus modal -->
    <div class="modal fade" id="editClueModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 90%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">Modify Clue</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
						<input type="hidden" id="clueId" value="${clue.id}">
                        <div class="form-group">
                            <label for="edit-clueOwner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-clueOwner">
									<c:forEach items="${users}" var="s">
										<option value="${s.id}">${s.name}</option>
									</c:forEach>
                                </select>
                            </div>
                            <label for="edit-company" class="col-sm-2 control-label">Company<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-company" value="${clue.company}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-call" class="col-sm-2 control-label">Appellation</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-call" >
									<c:forEach items="${dicValuesAppellation}" var="a">
										<option value="${a.id}">${a.value}</option>
									</c:forEach>
                                </select>
                            </div>
                            <label for="edit-surname" class="col-sm-2 control-label">Name<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-surname" value="${clue.fullName}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-job" class="col-sm-2 control-label">Job</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-job" value="${clue.job}">
                            </div>
                            <label for="edit-email" class="col-sm-2 control-label">Email</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-email" value="${clue.email}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-phone" class="col-sm-2 control-label">Landline</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-phone" value="${clue.phone}">
                            </div>
                            <label for="edit-website" class="col-sm-2 control-label">Website</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" value="${clue.website}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-mPhone" class="col-sm-2 control-label">Cellphone</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-mPhone" value="${clue.mPhone}">
                            </div>
                            <label for="edit-status" class="col-sm-2 control-label">Stage</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-status" name="${clue.state}">
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
                                <select class="form-control" id="edit-source" name="${clue.source}">
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
                                <textarea class="form-control" rows="3" id="edit-describe">${clue.description}</textarea>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="edit-contactSummary" class="col-sm-2 control-label">Contact Summary</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary">${clue.contactSummary}</textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">Next Contact Time</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control" id="edit-nextContactTime" value="${clue.nextContactTime}">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">Address</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">${clue.address}</textarea>
                                </div>
                            </div>
                        </div>
                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="updateClueBtn">Update</button>
                </div>
            </div>
        </div>
    </div>

	<!-- Return btn -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- Title -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3> <small id="company">${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -60px; left: 700px;">
			<button type="button" class="btn btn-default" id="transferBtn"><span class="glyphicon glyphicon-retweet"></span>Transfer</button>
			<button type="button" class="btn btn-default" id="clueModifyBtn"><span class="glyphicon glyphicon-edit"></span> Modify</button>
			<button type="button" class="btn btn-danger" id="clueDeleteBtn"><span class="glyphicon glyphicon-minus"></span> Delete</button>
		</div>
	</div>
	
	<!-- Detail info -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">Name</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="appellation">${clue.fullName}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Owner</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="owner">${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">Company</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="company1">${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Job</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="job">${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">Email</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="email">${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Landline</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="phone">${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">Website</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="website">${clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Cellphone</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="mPhone">${clue.mPhone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">Stage</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="state">${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Source</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="source">${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">Create by</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="createBy">${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="createTime">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">Edit by</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy">${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;  " id="editTime">${clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">Description</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="description">
					${clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">Contact Summary</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="contactSummary">
					${clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">Next Contact Time</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="nextContactTime">${clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">Address</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b id="address">
                    ${clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- Remark -->
	<div style="position: relative; top: 40px; left: 40px;" id="remarkDivList">
		<div class="page-header">
			<h4>Remark</h4>
		</div>

		<!-- remark -->
		<c:forEach items="${clueRemarks}" var="remark">
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
	
	<!-- Activity -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>Activity</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>Name</td>
							<td>StartDate</td>
							<td>EndDate</td>
							<td>Owner</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<c:forEach items="${activities}" var="activity">
							<tr id="${activity.id}">
								<td>${activity.name}</td>
								<td>${activity.startDate}</td>
								<td>${activity.endDate}</td>
								<td>${activity.owner}</td>
								<td><a href="javascript:void(0);" activityId="${activity.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>Disassociate</a></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="bundActivityBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>Associate</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>