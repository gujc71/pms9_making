<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title><s:message code="common.pageTitle"/></title>
    <link href="css/sb-admin/bootstrap.min.css" rel="stylesheet">
    <link href="css/sb-admin/metisMenu.min.css" rel="stylesheet">
    <link href="css/sb-admin/sb-admin-2.css" rel="stylesheet">
    <link href="css/sb-admin/font-awesome.min.css" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

    <script src="js/jquery-2.2.3.min.js"></script>
    <script src="css/sb-admin/bootstrap.min.js"></script>
    <script src="css/sb-admin/metisMenu.min.js"></script>
    <script src="css/sb-admin/sb-admin-2.js"></script>
	<script src="js/project9.js"></script>
	
	<link rel="stylesheet" type="text/css" href="js/easyui/easyui.css">
	<link rel="stylesheet" type="text/css" href="js/easyui/icon.css">
	<link rel="stylesheet" type="text/css" href="js/easyui/demo.css">
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js"></script>
<link href="js/dynatree/ui.dynatree.css" rel="stylesheet"/>
<script src="js/jquery-ui.js"></script>
<script src="js/dynatree/jquery.dynatree.js"></script>
	    
<script type="text/javascript">
$(function() {
	var dataSet = {"total":<c:out value="${listview.size()}" />,"rows":[
		<c:forEach var="listview" items="${listview}" varStatus="status">
			{"id":'<c:out value="${listview.tsno}" />', "tsno":'<c:out value="${listview.tsno}" />'
			,"tstitle":'<c:out value="${listview.tstitle}" />',"tsstartdate":"<c:out value="${listview.tsstartdate}" />"
			,"tsenddate":"<c:out value="${listview.tsenddate}" />", "tsrate":"<c:out value="${listview.tsrate}" />"
			,"userno": "<c:out value="${listview.userno}" />", "usernm": "<c:out value="${listview.usernm}" />"
			<c:if test="${listview.tsparent!=null}">,"_parentId":"<c:out value="${listview.tsparent}" />"</c:if> } <c:if test="${!status.last}">,</c:if>
		</c:forEach>
    ]};
    
    $('#tg').treegrid({  
        data: dataSet,
        onDblClickCell : function(field, row) {
			edit();
			if (field==="usernm") { 
				fn_searchUsers(row);
			}
        } 
    });

});
function formatProgress(value){
    if (value){
        var s = '<div style="width:100%;border:1px solid #ccc">' +
                '<div style="width:' + value + '%;background:#cc0000;color:#fff">' + value + '%' + '</div>'
                '</div>';
        return s;
    } else {
        return '';
    }
}
var editingId;
function edit(){
    if (editingId != undefined){
        $('#tg').treegrid('select', editingId);
        return;
    }
    var row = $('#tg').treegrid('getSelected');
    if (row){
        editingId = row.tsno
        $('#tg').treegrid('beginEdit', editingId);
    }
}
function save(){
	if (editingId === undefined){return;}
    var t = $('#tg');
    t.treegrid('endEdit', editingId);
    // 현재 선택된 행
    var node = t.treegrid('getSelected');
 	t.treegrid('endEdit', editingId);
    // 부모 노드 정보 추출
 	var parentId=null;
 	var parent = t.treegrid('getParent', node.tsno);
 	if (parent) {
 		parentId = parent.id;
 	}	
 	node.tsparent=parentId;
 	node.prno='<c:out value="${projectInfo.prno}" />';
 	// 데이터 전송
 	$.ajax({
 		url : "taskSave",
 		type: "post",
 		dataType: "json",
 		data: node
 	}).done(function(data){
 		$('#tg').treegrid('update', {
 			id : "N",
			row : {id: data, tsno: data}
 		});		
 	});
 	
 	editingId = undefined;        
}
function cancel(){
    if (editingId != undefined){
        $('#tg').treegrid('cancelEdit', editingId);
        editingId = undefined;
    }
}
var idIndex = 100;
function append(){
    idIndex++;
    var d1 = new Date();
    var d2 = new Date();
    d2.setMonth(d2.getMonth()+1);
    var parentid = null;
    var node = $('#tg').treegrid('getSelected');
    if (node) parentid=node.tsno;
    $('#tg').treegrid('append',{
        parent: parentid,
        data: [{
            id: 'N',
            tsno: 'N',
            tstitle: 'New Task'+idIndex,
            usernm: "",
            userno: "",
            tsstartdate: $.fn.datebox.defaults.formatter(d1),
            tsenddate: $.fn.datebox.defaults.formatter(d2),
            tsrate: parseInt(Math.random()*100)
        }]
    });
	editingId = 'N';
	$('#tg').treegrid('select', editingId);
	$('#tg').treegrid('beginEdit', editingId);    
}

function removeIt(){
    var node = $('#tg').treegrid('getSelected');
    if (!node) {return;}
    
	$.ajax({
		url : "taskDelete",
		cache : false,
		dataType : "json",
		data : {tsno:node.tsno}
	}).done(function(data){
		$('#tg').treegrid('remove', node.tsno);
	});
	
}
// 사용자 선택
function fn_searchUsers(row){
    $.ajax({
        url: "popupUsers",
        type: "post"       
    }).success(function(result){
                $("#popupUsers").html(result);
       			if (row.userno){
       				set_Users(row.userno, row.usernm); 
       			}
        }           
    );
    $("#popupUsers").modal("show");
}
function deptTreeInUsersActivate(node) {
    if (node==null || node.data.key==0) return;
   
    $.ajax({
        url: "popupUsers4Users",
        type:"post",
        data: { deptno : node.data.key }       
    }).success(function(result){
                $("#userlist4Users").html(result);
        }           
    );
}

function fn_selectUsers(userno, usernm) {
	var node = $('#tg').treegrid('getSelected');
	
	$('#tg').treegrid('update', {
		id : node.tsno,
		row : {userno : userno, usernm:usernm}
	});
	$('#tg').treegrid('endEdit', editingId);
	$('#tg').treegrid('beginEdit', editingId);
    $("#popupUsers").modal("hide");
}
</script>   
</head>

<body>

    <div id="wrapper">

		<jsp:include page="../common/navigation.jsp" />
		
        <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header"><i class="fa fa-gear fa-fw"></i> <s:message code="project.title"/></h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
				<div class="panel panel-default">
					<div class="panel-heading">
                        <c:out value="${projectInfo.prtitle}"/> (<c:out value="${projectInfo.prstartdate}"/> ~ <c:out value="${projectInfo.prenddate}"/>)
					</div>
	                <!-- div class="panel-body">
	                	<c:out value="${projectInfo.prstatus}"/>
	                </div -->
                </div>
                <button class="btn btn-outline btn-primary" onclick="fn_moveToURL('projectList')" ><s:message code="common.btnList"/></button>
                <button class="btn btn-outline btn-primary" onclick="fn_moveToURL('projectDelete?prno=<c:out value="${projectInfo.prno}"/>', '<s:message code="common.btnDelete"/>')" ><s:message code="common.btnDelete"/></button>
                <button class="btn btn-outline btn-primary" onclick="fn_moveToURL('projectForm?prno=<c:out value="${projectInfo.prno}"/>')" ><s:message code="common.btnUpdate"/></button>
            </div>
            <p>&nbsp;</p>
            <div class="row">
            	<div class="col-lg-5">
		            <ul class="nav nav-pills">
	                     <li class="active"><a href="ProjectRead?prno=<c:out value="${projectInfo.prno}"/>"><i class="fa fa-tasks fa-fw"></i>작업</a></li>
	                     <li><a href="taskCalendar?prno=<c:out value="${projectInfo.prno}"/>"><i class="fa fa-calendar  fa-fw"></i>일정</a></li>
	                     <li><a href="taskWorker?prno=<c:out value="${projectInfo.prno}"/>"><i class="fa fa-user fa-fw"></i>작업자</a></li>
	                     <li><a href="taskMine?prno=<c:out value="${projectInfo.prno}"/>">내것만</a></li>
	                 </ul>
                </div>
            </div>             
            <!-- /.row -->
            <div class="row">
			    <div style="margin:20px 0;">
			        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="edit()">Edit</a>
			        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="save()">Save</a>
			        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="cancel()">Cancel</a>
			        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="append()">append</a>
			        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="removeIt()">remove</a>
			    </div>
			    <table id="tg" class="easyui-treegrid" style="width:700px;height:250px"
			            data-options="
			                iconCls: 'icon-ok',
			                rownumbers: true,
			                animate: true,
			                collapsible: true,
			                fitColumns: true,
			                method: 'get',
			                idField: 'tsno',
			                treeField: 'tstitle',
			                showFooter: true
			            ">
			        <thead>
			            <tr>
			                <th data-options="field:'tstitle',width:180,editor:'text'">Task Name</th>
			                <th data-options="field:'usernm',width:60,align:'right'">Persons</th>
			                <th data-options="field:'tsstartdate',width:80,editor:'datebox'">Begin Date</th>
			                <th data-options="field:'tsenddate',width:80,editor:'datebox'">End Date</th>
			                <th data-options="field:'tsrate',width:120,formatter:formatProgress,editor:'numberbox'">Progress</th>
			            </tr>
			        </thead>
			    </table>            
            </div>
            <!-- /.row -->
            
        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->
    <div id="popupUsers" class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" 
    aria-labelledby="myLargeModalLabel"></div>     
</body>

</html>
