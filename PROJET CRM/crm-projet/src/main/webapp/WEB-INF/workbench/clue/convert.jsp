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
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){

		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});
		$("#openSearchModalBtn,#activityName").click(function (){

			$("#aName").val("")
			$("#activitySearchBody").html(" ")
			$("#searchActivityModal").modal("show");

		})
		$("#aName").keyup(function (event){

			$.ajax({
				url:"workbench/clue/queryActivityByName.do",
				data:{
					"name":$.trim($("#aName").val())
				},
				type:"get",
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

					$("#activitySearchBody").html(html);

				}
			})
			return false;
		})
		//add click event to search button
		$("#submitActivityBtn").click(function (){
			var id = $("input[name=xz]:checked").val();
			var name = $("#"+id).html();
			$("#activityId").val(id);
			$("#activityName").val(name);
			$("#searchActivityModal").modal("hide")

		});

		//back to the detail page
		$("#cancelbtn").click(function (){
			var id = $("#clueId").val()
			window.location.href= 'workbench/clue/detail.do?id='+id+'';
		})
		//add click event to switch button
		$("#convertBtn").click(function (){
			var regDate = /^[1-9]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/
			var regExp = /^[1-9]\d*|0$/;
			var isCreate = $("#isCreateTransaction").prop("checked")
			var expectedDate = $("#expectedClosingDate").val()
			var money = $("#amountOfMoney").val()
			var name = $("#tradeName").val()
			var stage = $("#stage").val()
			var activityId = $("#activityId").val()
			var clueId = $("#clueId").val()
			if(!regExp.test(money)){
				alert("Illegal Amount")
				return
			}
			if(!regDate.test(expectedDate)){

				alert("Illegal date format")
				return;
			}
			if(window.confirm("Ready to Switch?")){

				$.ajax({

					url:'workbench/clue/transferClue.do',
					data: {'isCreate':isCreate,'expectedDate':expectedDate,'money':money,
						'name':name,'stage':stage,'activityId':activityId,'clueId':clueId},
					dataType: 'json',
					type: 'post',
					success:function (data){

						if(data.returnCode == 1){

							window.location.href = "workbench/clue/index.do"
						}else {

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
	
	<!-- Search activity modal -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">Search the activity</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="aName" style="width: 300px;" placeholder="Activity name search" >
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
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
					<button type="button" class="btn btn-primary" id="submitActivityBtn">Commit</button>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>Clue Transfer <small>   ${clue.appellation} ${clue.fullName}-${clue.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		New Client：${clue.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		New Contact：${clue.appellation} ${clue.fullName}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		Open a transaction
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form id="tranForm" action="workbench/clue/convert.do" method="post">
			<input type="hidden" name="flag" value="a">
			<input type="hidden" id="clueId" value="${clue.id}">
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">Amount</label>
		    <input type="text" class="form-control" id="amountOfMoney" name="money">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">Name of transaction</label>
		    <input type="text" class="form-control" id="tradeName" name="name">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">Estimated agreement date(yyyy-mm-dd)</label>
		    <input type="text" class="form-control time" id="expectedClosingDate"name="expectedDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">Phase</label>
		    <select id="stage"  class="form-control" name="stage">
		    	<option></option>
				<c:forEach items="${dicValues}" var="s">
					<option value="${s.id}">${s.value}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activityName">Activity source&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchModalBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input type="text" class="form-control" id="activityName" placeholder="Click for search" readonly>
			  <input type="hidden" id="activityId">
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		Owner：<br>
		<b>${clue.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" type="button" id="convertBtn" value="Switch">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="Cancel" id="cancelbtn">
	</div>
</body>
</html>