<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript">

	//load the page
	$(function(){
		
		//black text in the navigation
		$(".liClass > a").css("color" , "black");
		
		//select the first choice by default
		$(".liClass:first").addClass("active");
		
		//the first choice turn to white
		$(".liClass:first > a").css("color" , "white");
		
		//event for the settings
		$(".liClass").click(function(){
			//remove the motivation
			$(".liClass").removeClass("active");
			//all text turn to black
			$(".liClass > a").css("color" , "black");
			//selected
			$(this).addClass("active");
			//turn to white
			$(this).children("a").css("color","white");
		});
		
		
		window.open("workbench/main/index.do","workareaFrame");

		//logout in security
		$("#logoutBtn").click(function (){

			window.location.href = "logOut.do";
		});

		$("#update_password").click(function (){
			var id = $("#userId").val()
			var actualPassword = $("#oldPwd").val();
			var newPassword = $("#newPwd").val();
			var confirm = $("#confirmPwd").val();
			if(newPassword != confirm){

				alert("Please entry the same password")
			}

			$.ajax({
				url:'workbench/updatePassword.do',
				data:{actualPassword:actualPassword,newPassword:newPassword,id:id},
				dataType:'json',
				type:'post',
				success:function (data){
					if(data.returnCode == 1){
						alert(data.message);
						$('#editPwdModal').modal('hide');
						$("#pwdForm")[0].reset();
					}else{
						alert(data.message);
					}
				}

			})
		})
	});
	
</script>

</head>
<body>
	
	<!-- Information -->
	<div class="modal fade" id="myInformation" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">Information</h4>
				</div>
				<div class="modal-body">
					<div style="position: relative; left: 40px;">
						Name：<b>${sessionScope.sessionUser.name}</b><br><br>
						Account：<b>${sessionScope.sessionUser.loginAct}</b><br><br>
						Department：<b>${sessionScope.sessionUser.department}</b><br><br>
						Email：<b>${sessionScope.sessionUser.email}</b><br><br>
						Expire time：<b>${sessionScope.sessionUser.expireTime}</b><br><br>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>

	<!-- modal for update the password -->
	<div class="modal fade" id="editPwdModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 70%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">Modify Password</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="pwdForm">
						<div class="form-group">
							<label for="oldPwd" class="col-sm-2 control-label">Actual Password</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="oldPwd" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="newPwd" class="col-sm-2 control-label">New Password</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="newPwd" style="width: 200%;">
							</div>
						</div>
						
						<div class="form-group">
							<label for="confirmPwd" class="col-sm-2 control-label">Confirm</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="confirmPwd" style="width: 200%;">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="update_password">Update</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Logout modal -->
	<div class="modal fade" id="exitModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">Logout</h4>
				</div>
				<div class="modal-body">
					<p>Ready to leave？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="logoutBtn">Confirm</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Top -->
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 15px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM</div>
		<div style="position: absolute; top: 15px; right: 15px;">
			<ul>
				<li class="dropdown user-dropdown">
					<a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle" data-toggle="dropdown">
						<input type="hidden" id="userId" value="${sessionScope.sessionUser.id}">
						<span class="glyphicon glyphicon-user"></span> ${sessionScope.sessionUser.name} <span class="caret"></span>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</a>
					<ul class="dropdown-menu" style="position: absolute; left:-70px;text-align: justify;width: auto;height: fit-content">
						<li><a href="settings/index.html"><span class="glyphicon glyphicon-wrench"></span> Settings</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation"><span class="glyphicon glyphicon-file"></span> Information</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal" data-target="#editPwdModal" id="change_password"><span class="glyphicon glyphicon-edit"></span> Password</a></li>
						<li><a href="javascript:void(0);" data-toggle="modal" data-target="#exitModal"><span class="glyphicon glyphicon-off"></span> Logout</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
	
	<!-- Middle -->
	<div id="center" style="position: absolute;top: 50px; bottom: 30px; left: 0px; right: 0px;">
	
		<!-- Navigation -->
		<div id="navigation" style="left: 0px; width: 18%; position: relative; height: 100%; overflow:auto;">
		
			<ul id="no1" class="nav nav-pills nav-stacked" style="font-weight:normal;font-size: medium" >
				<li class="liClass"><a href="workbench/main/index.do" target="workareaFrame"><span class="glyphicon glyphicon-home"></span> Workbench</a></li>
				<li class="liClass"><a href="workbench/activity/index.do" target="workareaFrame"><span class="glyphicon glyphicon-play-circle"></span> Activity Dashboard</a></li>
				<li class="liClass"><a href="workbench/clue/index.do" target="workareaFrame"><span class="glyphicon glyphicon-search"></span> Potential Client</a></li>
				<li class="liClass"><a href="workbench/customer/index.do" target="workareaFrame"><span class="glyphicon glyphicon-user"></span> Customer</a></li>
				<li class="liClass"><a href="workbench/contacts/index.do" target="workareaFrame"><span class="glyphicon glyphicon-earphone"></span> Contact</a></li>
				<li class="liClass"><a href="workbench/transaction/index.do" target="workareaFrame"><span class="glyphicon glyphicon-usd"></span> Transaction</a></li>
				<li class="liClass"><a href="visit/index.html" target="workareaFrame"><span class="glyphicon glyphicon-phone-alt"></span> After-Sale</a></li>
				<li class="liClass">
					<a href="#no2" class="collapsed" data-toggle="collapse"><span class="glyphicon glyphicon-stats"></span>Chart</a>
					<ul id="no2" class="nav nav-pills nav-stacked collapse">
						<li class="liClass"><a href="workbench/chart/transaction/activityChartIndex.do" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> Activity Chart</a></li>
						<li class="liClass"><a href="chart/clue/index.html" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> Potential Client Chart</a></li>
						<li class="liClass"><a href="chart/customerAndContacts/index.html" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> Client And Contact Chart</a></li>
						<li class="liClass"><a href="workbench/chart/transaction/index.do" target="workareaFrame">&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-chevron-right"></span> Transaction Chart</a></li>
					</ul>
				</li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-file"></span> Report Form</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-shopping-cart"></span> Sales Order</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-send"></span> Invoice</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-earphone"></span> Follow-Up</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-leaf"></span> Product</a></li>
				<li class="liClass"><a href="javascript:void(0);" target="workareaFrame"><span class="glyphicon glyphicon-usd"></span> Price</a></li>
			</ul>
			
			<!-- Line -->
			<div id="divider1" style="position: absolute; top : 0px; right: 0px; width: 1px; height: 100% ; background-color: #B3B3B3;"></div>
		</div>
		
		<!-- Work zone -->
		<div id="workarea" style="position: absolute; top : 0px; left: 18%; width: 82%; height: 100%; margin: auto">
			<iframe style="margin: auto;border-width: 0px; width: 100%; height: 100%;" name="workareaFrame"></iframe>
		</div>
		
	</div>
	
	<div id="divider2" style="height: 1px; width: 100%; position: absolute;bottom: 30px; background-color: #B3B3B3;"></div>
	
	<!-- Bottom -->
	<div id="down" style="height: 30px; width: 100%; position: absolute;bottom: 0px;"></div>
	
</body>
</html>