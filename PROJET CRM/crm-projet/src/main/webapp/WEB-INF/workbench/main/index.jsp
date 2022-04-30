<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

	</style>
</head>
<body style="overflow: hidden">

		<script type="text/javascript">
			Date.prototype.format =function(format)

			{

				var o = {

					"M+" : this.getMonth()+1, //month

					"d+" : this.getDate(), //day

					"h+" : this.getHours(), //hour

					"m+" : this.getMinutes(), //minute

					"s+" : this.getSeconds(), //second

					"q+" : Math.floor((this.getMonth()+3)/3), //quarter

					"S" : this.getMilliseconds() //millisecond

				}

				if(/(y+)/.test(format)) format=format.replace(RegExp.$1,

						(this.getFullYear()+"").substr(4- RegExp.$1.length));

				for(var k in o)if(new RegExp("("+ k +")").test(format))

					format = format.replace(RegExp.$1,

							RegExp.$1.length==1? o[k] :

									("00"+ o[k]).substr((""+ o[k]).length));

				return format;

			}

			$(function (){

				setInterval("document.getElementById('date').innerHTML='{' + new Date().format('yyyy-MM-dd hh:mm:ss')+ '}'");
			})
		</script>
		<div style="margin:auto;display:block;position: relative;top: 100px;left: 495px;font-size: xx-large;font-weight: bold"><span style="color: #2d6ca2; font-size: xx-large">{Welcome,&nbsp;${sessionScope.sessionUser.name}}</span></div>
		<span style="margin:auto;display:block;position: relative;top: 120px;left: 520px;font-size: large;font-weight: bold" id="date"></span>
		<img src="image/main_page.jpg" style="margin:auto;width:30% ;position: relative; left: 430px; top: 200px" />


</body>
</html>