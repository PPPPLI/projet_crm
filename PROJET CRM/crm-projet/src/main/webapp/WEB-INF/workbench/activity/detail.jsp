<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

<script type="text/javascript">

    //hide the save and cancel button by default
    var cancelAndSaveBtnDefault = true;

    $(function(){
        $("#remark").focus(function(){
            if(cancelAndSaveBtnDefault){
                //set remarkDiv height to 130px
                $("#remarkDiv").css("height","130px");
                //display
                $("#cancelAndSaveBtn").show("2000");
                cancelAndSaveBtnDefault = false;
            }
        });

        $("#cancelBtn").click(function(){
            //display
            $("#cancelAndSaveBtn").hide();
            //set remarkDiv height to 90px
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

        //add the click event to the save button
        $("#saveCreateActivityRemarkBtn").click(function () {
            //collect the arguments
            var noteContent=$.trim($("#remark").val());
            var id=$("#activityId").val()
            //form check
            if(noteContent==""){
                alert("Please tape your comment");
                return;
            }

            $.ajax({
                url:'workbench/activity/insertActivityRemark.do',
                data:{
                    noteContent:noteContent,
                    id:id
                },
                type:'post',
                dateType:'json',
                success:function (data) {
                    if(data.returnCode=="1"){
                        //clear the textarea
                        $("#remark").val("");
                        //refresh the list
                        var htmlStr="";
                        htmlStr+="<div id=\"div_"+data.returnData.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">";
                        htmlStr+="<img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
                        htmlStr+="<div style=\"position: relative; top: -40px; left: 40px;\" >";
                        htmlStr+="<h5>"+data.returnData.noteContent+"</h5>";
                        htmlStr+="<b>${sessionScope.sessionUser.name}</b>  <small style=\"color: gray;\"> "+data.returnData.createTime+" | create by: ${sessionScope.sessionUser.name}</small>";
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
            });
        });

        //add the click event to all the delete buttons
        $("#remarkDivList").on("click","a[name='deleteA']",function () {
            if(window.confirm("Ready to delete?")){

                //collect the arguments
                var id=$(this).attr("remarkId");

                $.ajax({
                    url:'workbench/activity/deleteActivityRemark.do',
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

        //add the click event for all the activity remark buttons
        $("#remarkDivList").on("click","a[name='editA']",function () {
            //get remark id and noteContent
            var id=$(this).attr("remarkId");
            var noteContent=$("#div_"+id+" h5").text();
            //put the remark id and noteContent to the remark modify modal
            $("#remarkId").val(id);
            $("#noteContent").val(noteContent);
            //display the modal
            $("#editRemarkModal").modal("show");
        });

        //add the click event to the update button
        $("#updateRemarkBtnToModify").click(function () {
            //collect the arguments
            var id=$("#remarkId").val();
            var noteContent=$.trim($("#noteContent").val());
            //form check
            if(noteContent==""){
                alert("Please tape your comment");
                return;
            }

            $.ajax({
                url:'workbench/activity/updateActivityRemark.do',
                data:{
                    id:id,
                    noteContent:noteContent
                },
                type:'post',
                dataType:'json',
                success:function (data) {
                    if(data.returnCode=="1"){
                        //close the modal
                        $("#editRemarkModal").modal("hide");
                        //refresh the remark list
                        $("#div_"+data.returnData.id+" h5").text(data.returnData.noteContent);
                        $("#div_"+data.returnData.id+" small").text(" "+data.returnData.editTime+" edit by: ${sessionScope.sessionUser.name}");
                    }else{
                        //notice
                        alert(data.message);
                        //keep the modal on
                        $("#editRemarkModal").modal("show");
                    }
                }
            });
        });
        $("#modifyBtn").click(function (){

            $("#editActivityModal").modal("show")
        })

        $("#updateRemarkBtn").click(function (){
            var owner = $("#edit-marketActivityOwner").val();
            var name = $("#edit-marketActivityName").val();
            var startDate = $("#edit-startTime").val();
            var endDate = $("#edit-endTime").val();
            var cost = $("#edit-cost").val();
            var description = $("#edit-describe").val();
            var id = $("#activityId").val();

            if(owner == "" || name ==""){
                alert("Please fill the necessary information");
                return
            }
            if(startDate != "" && endDate != ""){

                if(startDate > endDate){

                    alert("enddate can't be early than startdate");
                    return;
                }
            }
            var regDate = /^[1-9]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/
            if(!regDate.test(startDate)&&regDate.test(endDate)){

                alert("Illegal date format")
                return;
            }
            var regCost = /^[1-9]\d*|0$/;

            if(!regCost.test(cost)){

                alert("The cost can't be negative");
                return
            }

            $.ajax({
                url:'workbench/activity/modifyActivity.do',
                data:{'id':id,'name':name,
                'owner':owner,'startDate':startDate,
                'endDate':endDate,'cost':cost,'description':description},
            dataType:'json',
                type:'post',
                success:function (data){
                    if(data.returnCode == 1){
                        $("#ownerInfo").text(data.returnData.owner);
                        $("#nameInfo").text(data.returnData.name);
                        $("#startDateInfo").text(data.returnData.startDate);
                        $("#endDataInfo").text(data.returnData.endDate);
                        $("#editTimeInfo").text(data.returnData.editTime);
                        $("#editByInfo").text(data.returnData.editBy);
                        $("#costInfo").text(data.returnData.cost);
                        $("#descriptionInfo").text(data.returnData.description);
                        $("#editActivityModal").modal("hide");
                    }else{
                        alert(data.message);
                    }
                }
            })
        })

        $("#deleteBtn").click(function (){

            var id = $("#activityId").val();
            if (window.confirm("Ready to delete?")){

                $.ajax({
                    url:'workbench/activity/deleteActivityAndRemark.do',
                    dataType:'json',
                    type:'post',
                    data:{id:id},
                    success:function (data){
                        if(data.returnCode == 1){
                            window.location.href = "workbench/activity/index.do"
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
	
	<!-- modification of activity remark modal -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- hidden for remark id --%>
		<input type="hidden" id="remarkId" value="">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModifiesModalLabel">Modify remark</h4>
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

    <!-- modification of activity modal -->
    <div class="modal fade" id="editActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">Modify activity</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">
                        <input type="hidden" id="activityId" value="${detailActivityResult.id}">
                        <div class="form-group">
                            <label for="edit-marketActivityOwner" class="col-sm-2 control-label">Owner<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-marketActivityOwner">
                                    <c:forEach items="${ids}" var="user">
                                        <option value="${user.id}">${user.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">Name<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="${detailActivityResult.name}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-startTime" class="col-sm-2 control-label">StartDate</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-startTime" value="${detailActivityResult.startDate}">
                            </div>
                            <label for="edit-endTime" class="col-sm-2 control-label">EndDate</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-endTime" value="${detailActivityResult.endDate}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-cost" class="col-sm-2 control-label">Cost</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-cost" value="${detailActivityResult.cost}">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">Description</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-describe">${detailActivityResult.description}</textarea>
                            </div>
                        </div>

                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">Update</button>
                </div>
            </div>
        </div>
    </div>

	<!-- return button -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- Title -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>Activity-${detailActivityResult.name}</h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="modifyBtn"><span class="glyphicon glyphicon-edit"></span> Edit</button>
			<button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> Delete</button>
		</div>
	</div>
	
	<!-- Detail information -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">Owner</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="ownerInfo">${detailActivityResult.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">Name</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="nameInfo">${detailActivityResult.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">StartDate</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="startDateInfo">${detailActivityResult.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">EndDate</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="endDataInfo">${detailActivityResult.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">Cost</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="costInfo">${detailActivityResult.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">Create by</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="createByInfo">${detailActivityResult.createBy}</b><small style="position:absolute;left:200px;font-size: 10px; color: gray;" id="createTimeInfo">${detailActivityResult.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">Edit by</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editByInfo">${detailActivityResult.editBy}</b><small style="position:absolute;left:200px;font-size: 10px; color: gray;" id="editTimeInfo">${detailActivityResult.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">Description</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="descriptionInfo">
					${detailActivityResult.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- Comment -->
    <div id="remarkDivList" style="position: relative; top: 30px; left: 40px;">
        <div class="page-header">
            <h4>Comment</h4>
        </div>
            <c:forEach items="${detailRemarkResult}" var="remark">
                <div id="div_${remark.id}" class="remarkDiv" style="height: 60px;">
                    <img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
                    <div style="position: relative; top: -40px; left: 40px;" >
                        <h5>${remark.noteContent}</h5>
                        <b>${remark.createBy}</b> <small style="color: gray;">${remark.editFlag=='1'?remark.editTime:remark.createTime} ${remark.editFlag=='1'?'| edit by: ':'| create by: '}${remark.editFlag=='1'?remark.editBy:remark.createBy}</small>
                        <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
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
    <div style="height: 200px;"></div>
</body>
</html>