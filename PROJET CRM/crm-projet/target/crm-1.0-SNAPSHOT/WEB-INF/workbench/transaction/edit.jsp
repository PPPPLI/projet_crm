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
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

</head>
<body>
	<script type="text/javascript">

		$(function (){

			//back to the transaction main page
			$("#cancelBtn").click(function (){
				window.location.href = "workbench/transaction/index.do";
			})

			//get the source id for source select
			$("#edit-clueSource").val($("#sourceId").val());

			//get the type id for type select
			$("#edit-transactionType").val($("#typeId").val());

			//get the stage id for stage select
			$("#edit-transactionStage").val($("#stageId").val());

			//get the owner id for owner select
			$("#edit-transactionOwner").val($("#ownerId").val());

			//time button
			$("#edit-expectedClosingDate").datetimepicker({
				minView: "month",
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				clearBtn:true,
				initialDate:new Date(),
			});

			$("#create-nextContactTime").datetimepicker({

				minView: "month",
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				clearBtn:true,
				initialDate:new Date(),
				pickerPosition: "top-left"
			})

			//auto-liaison for company
			$("#edit-accountName").typeahead({
				source:function (jquery,process) {
					$.ajax({
						url:'workbench/transaction/queryCustomerNameByName.do',
						data:{
							customerName:jquery
						},
						type:'post',
						dataType:'json',
						success:function (data) {
							process(data);
						}
					});
				}
			});

			$("#edit-accountName").blur(function (){

				var customerName = $("#edit-accountName").val()

				$.ajax({
					url:'workbench/transaction/queryCustomerIdByName.do',
					data:{customerName:customerName},
					dataType:'json',
					type:'post',
					success:function (data){
						$("#customerId").val(data.id)
					}
				})
			})

			//search the contact info
			$("#search-input").keyup(function (){
				var customerId = $("#search-input").val()
				$.ajax({
					url:'workbench/transaction/queryContactForTrans.do',
					data:{customerId:customerId},
					dataType:'json',
					type:'post',
					success:function (data){
						var stringHtml = '';
						$.each(data,function (i,n){

							stringHtml += '<tr>';
							stringHtml += '<td><input type="radio" name="xz" value="'+n.id+'"/></td>';
							stringHtml += '<td id="'+n.id+'">'+n.fullName+'</td>';
							stringHtml += '<td>'+n.email+'</td>';
							stringHtml += '<td>'+n.mPhone+'</td>';
							stringHtml += '<td>'+n.customerId+'</td>';
							stringHtml += '</tr>';
						})
						$("#contact-list").html(stringHtml);
					}
				})
				return false;
			})

			$("#submitActivityBtn").click(function (){
				var id = $("input[name=xz]:checked").val();
				var name = $("#"+id).html();
				$("#edit-contactsId").val(id);
				$("#edit-contactsName").val(name);
				$("#findContacts").modal("hide")

			});

			//search the activity info
			$("#search-input2").keyup(function (event){

				$.ajax({
					url:"workbench/clue/queryActivityByName.do",
					data:{
						"name":$.trim($("#search-input2").val())
					},
					type:"post",
					dataType:"json",
					success:function (data){
						var html = "";

						$.each(data,function (i,n){

							html += '<tr>';
							html += '<td><input type="radio" name="xz" value="'+n.id+'"/></td>';
							html += '<td id="'+n.id+'">'+n.name+'</td>';
							html += '<td>'+n.startDate+'</td>';
							html += '<td>'+n.endDate+'</td>';
							html += '<td>'+n.owner+'</td>';
							html += '</tr>';
						})

						$("#activity-list").html(html);

					}
				})
				return false;
			})

			$("#submitActivityBtn2").click(function (){
				var id = $("input[name=xz]:checked").val();
				var name = $("#"+id).html();
				$("#edit-ActivityId").val(id);
				$("#edit-activitySrc").val(name);
				$("#findMarketActivity").modal("hide")

			});

			//get possibility
			$("#edit-transactionStage").change(function (){

				var stageValue = $("#edit-transactionStage option:selected").text();
				if(stageValue == ''){
					$("#edit-possibility").val(" ");
				}
				$.ajax({
					url:'workbench/transaction/getPossibilityByStage.do',
					data:{stageValue:stageValue},
					dataType:'json',
					type:'get',
					success:function (data){
						$("#edit-possibility").val(data+'%');
					}
				})
			})




			//add click event to the update btn
			$("#updateTranBtn").click(function () {
				//收集参数
				var owner          =$("#edit-transactionOwner").val();
				var money          =$.trim($("#edit-amountOfMoney").val());
				var name           =$.trim($("#edit-transactionName").val());
				var expectedDate   =$("#edit-expectedClosingDate").val();
				var customerId   =	$("#customerId").val();
				var stage          =$("#edit-transactionStage").val();
				var type           =$("#edit-transactionType").val();
				var source         =$("#edit-clueSource").val();
				var activityId     =$("#edit-activityId").val();
				var contactsId     =$("#edit-contactsId").val();
				var description    =$.trim($("#create-describe").val());
				var contactSummary =$.trim($("#create-contactSummary").val());
				var nextContactTime=$("#create-nextContactTime").val();
				var possibility = $("#edit-possibility").val()
				var id = $("#tranId").val();

				//form check
				if (name == null || name == "" || customerId == null || customerId == "" || money == null || money == "" || expectedDate == null || expectedDate == "" ||
						stage == null || stage == "" || contactsId == null || contactsId == "") {
					alert("Please fill the necessary information")
					return
				}

				var regDate = /^[1-9]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/
				if (!regDate.test(nextContactTime)) {

					alert("Illegal date format")
					return;
				}

				var regDate = /^[1-9]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/
				if (!regDate.test(expectedDate)) {

					alert("Illegal birthday format")
					return;
				}
				//send the request
				$.ajax({
					url:'workbench/transaction/updateTran.do',
					data:{
						owner          :owner          ,
						money          :money          ,
						name           :name           ,
						expectedDate   :expectedDate   ,
						customerId     :customerId     ,
						stage          :stage          ,
						type           :type           ,
						source         :source         ,
						activityId     :activityId     ,
						contactsId     :contactsId     ,
						description    :description    ,
						contactSummary :contactSummary ,
						nextContactTime:nextContactTime,
						possibility:possibility,
						id:id
					},
					type:'post',
					dataType:'json',
					success:function (data) {
						if(data.returnCode=="1"){
							//jump to the transaction main page
							window.location.href="workbench/transaction/index.do";
						}else{
							//notice
							alert(data.message);
						}
					}
				});
			});
		})
	</script>

	<!-- search activity modal -->
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">Search Activity</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
							<div class="form-group has-feedback">
								<input type="text" class="form-control" style="width: 300px;" id="search-input2">
								<span class="glyphicon glyphicon-search form-control-feedback"></span>
							</div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
						<tr style="color: #B3B3B3;">
							<td></td>
							<td>Name</td>
							<td>StartDate</td>
							<td>EndDate</td>
							<td>Owner</td>
						</tr>
						</thead>
						<tbody id="activity-list">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
					<button type="button" class="btn btn-primary" id="submitActivityBtn2">Commit</button>
				</div>
			</div>
		</div>
	</div>

	<!-- search contact modal -->
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">Search Contact</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
							<div class="form-group has-feedback">
								<input type="text" class="form-control" style="width: 300px;" id="search-input" placeholder="Tape the company name">
								<span class="glyphicon glyphicon-search form-control-feedback"></span>
							</div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
						<tr style="color: #B3B3B3;">
							<td></td>
							<td>Name</td>
							<td>Email</td>
							<td>Phone</td>
							<td>Company</td>
						</tr>
						</thead>
						<tbody id="contact-list">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
					<button type="button" class="btn btn-primary" id="submitActivityBtn">Commit</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>Update Transaction</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="updateTranBtn">Update</button>
			<button type="button" class="btn btn-default" id="cancelBtn">Cancel</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="edit-transactionOwner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="tranId" value="${tran.id}">
				<input type="hidden" id="ownerId" value="${tran.owner}">
				<select class="form-control" id="edit-transactionOwner">
					<c:forEach items="${userList}" var="u">
						<option value="${u.id}">${u.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-amountOfMoney" class="col-sm-2 control-label">Amount</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-amountOfMoney" value="${tran.money}">
			</div>
		</div>

		<div class="form-group">
			<label for="edit-transactionName" class="col-sm-2 control-label">Name<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-transactionName" value="${tran.name}">
			</div>
			<label for="edit-expectedClosingDate" class="col-sm-2 control-label">Expected Time<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="edit-expectedClosingDate" value="${tran.expectedDate}">
			</div>
		</div>

		<div class="form-group">
			<label for="edit-accountName" class="col-sm-2 control-label">Company<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="customerId" value="${customer.id}">
				<input type="text" class="form-control" id="edit-accountName" value="${customer.name}">
			</div>
			<label for="edit-transactionStage" class="col-sm-2 control-label">Phase<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="stageId" value="${tran.stage}">
			  <select class="form-control" id="edit-transactionStage">
			  	<option></option>
				  <c:forEach items="${stageList}" var="s">
					  <option value="${s.id}">${s.value}</option>
				  </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-transactionType" class="col-sm-2 control-label">Type</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="typeId" value="${tran.type}">
				<select class="form-control" id="edit-transactionType">
				  <option></option>
					<c:forEach items="${typeList}" var="tt">
						<option value="${tt.id}">${tt.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-possibility" class="col-sm-2 control-label">Possibility</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-possibility" value="${tran.possibility}">
			</div>
		</div>

		<div class="form-group">
			<label for="edit-clueSource" class="col-sm-2 control-label">Source</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="sourceId" value="${tran.source}">
				<select class="form-control" id="edit-clueSource" >
				  <option></option>
					<c:forEach items="${sourceList}" var="so">
						<option value="${so.id}">${so.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-activitySrc" class="col-sm-2 control-label">Activity Source&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="edit-activityId" value="${activity.id}">
				<input type="text" class="form-control" id="edit-activitySrc" value="${activity.name}" data-toggle="modal" data-target="#findMarketActivity" placeholder="Click for search" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactsName" class="col-sm-2 control-label">Contact&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="edit-contactsId" value="${contacts.id}">
				<input type="text" class="form-control" id="edit-contactsName" value="${contacts.fullName}" data-toggle="modal" data-target="#findContacts" placeholder="Click for search" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">Description</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe">${tran.description}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">Contact Summary</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary">${tran.contactSummary}</textarea>
			</div>
		</div>

		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">Next Contact Time</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-nextContactTime" value="${tran.nextContactTime}">
			</div>
		</div>
		
	</form>
</body>
</html>