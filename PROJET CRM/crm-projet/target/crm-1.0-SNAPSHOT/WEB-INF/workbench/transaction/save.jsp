<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
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
	<script type="text/javascript">
	$(function () {
		//add the change event to the stage text form
		$("#create-stage").change(function () {
			//Collect arguments

			var stageValue=$("#create-stage option:selected").text();
			//form check
			if(stageValue==""){
				//clear the possibility text form
				$("#create-possibility").val("");
				return;
			}
			//request
			$.ajax({
				url:'workbench/transaction/getPossibilityByStage.do',
				data:{
					stageValue:stageValue
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					//insert automatic possibility result in the text form
					$("#create-possibility").val(data);
				}
			});
		});

		//auto-liaison for company
		$("#create-customerName").typeahead({
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

		$("#create-customerName").blur(function (){

			var customerName = $("#create-customerName").val()

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

		$("#cancelBtn").click(function (){
			window.location.href = "workbench/transaction/index.do";
		})

		//time button
		$("#create-expectedDate").datetimepicker({
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

		//add click event to the save btn
		$("#saveCreateTranBtn").click(function () {
			//Collect argument
			var owner          =$("#create-owner").val();
			var money          =$.trim($("#create-money").val());
			var name           =$.trim($("#create-name").val());
			var expectedDate   =$("#create-expectedDate").val();
			var customerId   =	$("#customerId").val();
			var stage          =$("#create-stage").val();
			var type           =$("#create-type").val();
			var source         =$("#create-source").val();
			var activityId     =$("#create-activityId").val();
			var contactsId     =$("#create-contactsId").val();
			var description    =$.trim($("#create-description").val());
			var contactSummary =$.trim($("#create-contactSummary").val());
			var nextContactTime=$("#create-nextContactTime").val();
			var possibility = $("#create-possibility").val()

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
				url:'workbench/transaction/addTran.do',
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
					possibility:possibility
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.returnCode=="1"){
						//Jump to the transaction main page
						window.location.href="workbench/transaction/index.do";
					}else{
						//notice
						alert(data.message);
					}
				}
			});
		});

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
			$("#create-contactsId").val(id);
			$("#create-contactsName").val(name);
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
			$("#create-activityId").val(id);
			$("#create-activityName").val(name);
			$("#findMarketActivity").modal("hide")

		});

		$("#create-stage").change(function (){

			var stageValue = $("#create-stage option:selected").text();
			if(stageValue == ''){
				$("#create-possibility").val(" ");
			}
			$.ajax({
				url:'workbench/transaction/getPossibilityByStage.do',
				data:{stageValue:stageValue},
				dataType:'json',
				type:'get',
				success:function (data){
					$("#create-possibility").val(data+'%');
				}
			})
		})
	});
</script>
</head>
<body>

	<!-- search avtivity modal -->
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
		<h3>Create Transaction</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveCreateTranBtn">Save</button>
			<button type="button" class="btn btn-default" id="cancelBtn">Cancel</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-owner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-owner">
				  <c:forEach items="${userList}" var="u">
                    <option value="${u.id}">${u.name}</option>
                  </c:forEach>
				</select>
			</div>
			<label for="create-money" class="col-sm-2 control-label">Amount<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-name" class="col-sm-2 control-label">Name<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-name">
			</div>
			<label for="create-expectedDate" class="col-sm-2 control-label">Expected Time<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-expectedDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-customerName" class="col-sm-2 control-label">Company<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="customerId" value="">
				<input type="text" class="form-control" id="create-customerName" >
			</div>
			<label for="create-stage" class="col-sm-2 control-label">Phase<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-stage">
			  	<option></option>
                  <c:forEach items="${stageList}" var="s">
                     <option value="${s.id}">${s.value}</option>
                  </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-type" class="col-sm-2 control-label">Type</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-type">
				  <option></option>
				  <c:forEach items="${typeList}" var="tt">
                    <option value="${tt.id}">${tt.value}</option>
                  </c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">Possibility</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-source" class="col-sm-2 control-label">Source</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-source">
				  <option></option>
				  <c:forEach items="${sourceList}" var="so">
                    <option value="${so.id}">${so.value}</option>
                  </c:forEach>
				</select>
			</div>
			<label for="create-activityName" class="col-sm-2 control-label">Activity Source&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findMarketActivity"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
                <input type="hidden" id="create-activityId">
				<input type="text" class="form-control" id="create-activityName" data-toggle="modal" data-target="#findMarketActivity" placeholder="Click for search" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">Contact&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" data-target="#findContacts"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
                <input type="hidden" id="create-contactsId" >
				<input type="text" class="form-control" id="create-contactsName" data-toggle="modal" data-target="#findContacts" placeholder="Click for search" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-description" class="col-sm-2 control-label">Description</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">Contact Summary</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">Next Contact Time</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>