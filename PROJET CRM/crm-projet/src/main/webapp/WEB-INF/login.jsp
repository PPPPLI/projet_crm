<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
	<meta charset="UTF-8">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript">
		$(function () {
			//add the keydown event to the whole page
			$(window).keydown(function (e) {
				//entry key to login
				if(e.keyCode==13){
					$("#loginBtn").click();
				}
			});

			$("#loginAct").focus(function (){

				$("#msg").text("")
				return
			})

			$("#loginPwd").focus(function (){

				$("#msg").text("")
				return
			})

			//add the click event to button login
			$("#loginBtn").click(function () {
				//Collect arguments
				var loginAct=$.trim($("#loginAct").val());
				var loginPwd=$.trim($("#loginPwd").val());
				var isRemPwd=$("#isRemPwd").prop("checked");
				//form check
				if(loginAct==""){
					$("#msg").text("Please check your account")
					return;
				}
				if(loginPwd==""){
					$("#msg").text("Please check your account");
					return;
				}



				//display (Loading....)
				//send the request
				$.ajax({
					url:'login.do',
					data:{
						loginAct:loginAct,
						loginPwd:loginPwd,
						isRemPwd:isRemPwd
					},
					type:'post',
					dataType:'json',
					success:function (data) {
						if(data.returnCode== "1"){
							//go to the main page
							window.location.href="workbench/index.do";
						}else{
							//alert message if fail
							$("#msg").text(data.message);
						}
					},
					beforeSend:function () {
						//wait for the response
						$("#msg").text("Loading....");
						return true;
					}
				});
			});
		});
	</script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
	<img src="image/welcome_page.jpg" style="width: 15%;  position: relative; top: 68px;left: 520px">
</div>

	<div style="position:relative;top:168px;left:650px; font-size: 23px; font-weight: 400; color:orangered; font-family: 'times new roman';font-weight: bold">Customer Relationship Management</div>


<div style="position: absolute; top: 200px; right: 520px;width:490px;height:400px;border:1px solid #D5D5D5">
	<div style="position: absolute; top: 0px; right: 80px;">
		<div class="page-header" >
			<p style="font-size:x-large;position: relative;right: 15px">Welcome,</p>
		</div>
		<form action="workbench/index.html" class="form-horizontal" role="form">
			<div class="form-group form-group-lg">
				<div style="width: 350px;">
					<input class="form-control" id="loginAct" type="text" value="${cookie.loginAct.value}" placeholder="Username">
				</div>
				<div style="width: 350px; position: relative;top: 20px;">
					<input class="form-control" id="loginPwd" type="password" value="${cookie.loginPwd.value}" placeholder="Password">
				</div>
				<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
					<label>
						<c:if test="${not empty cookie.loginAct and not empty cookie.loginPwd}">
							<input type="checkbox" id="isRemPwd" checked>
						</c:if>
						<c:if test="${empty cookie.loginAct or empty cookie.loginPwd}">
							<input type="checkbox" id="isRemPwd">
						</c:if>
						Remember me
					</label>
					&nbsp;&nbsp;
					<span id="msg" style="color: red; font-size:larger"></span>
				</div>
				<button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">Connect</button>
			</div>
		</form>
	</div>
</div>
</body>
</html>