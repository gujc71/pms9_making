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
	
<link href='js/fullCalendar/fullcalendar.min.css' rel='stylesheet' />
<script src='js/fullCalendar/moment.min.js'></script>
<script src='js/fullCalendar/fullcalendar.min.js'></script>
	
<script type="text/javascript">
var dataset = [
    <c:forEach var="listview" items="${listview}" varStatus="status">
        <c:if test="${listview.tsstartdate != ''}">
            {"id":'<c:out value="${listview.tsno}" />'
            ,"title":'<c:out value="${listview.tstitle}" />'
            ,"start":"<c:out value="${listview.tsstartdate}" />"
            <c:if test="${listview.tsenddate != ''}">
                ,"end":"<c:out value="${listview.tsenddate}" />"
            </c:if>
            } <c:if test="${!status.last}">,</c:if>
        </c:if>
    </c:forEach>
];

$(document).ready(function() {
	$('#calendar').fullCalendar({
		header: {
			left: 'prev,next today',
			center: 'title',
			right: 'month,basicWeek,basicDay'
		},
		defaultDate: new Date(),
		navLinks: true, // can click day/week names to navigate views
		editable: false,
		eventLimit: true, // allow "more" link when too many events
		events: dataset
	});
	
});

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
	                     <li><a href="projectRead?prno=<c:out value="${projectInfo.prno}"/>"><i class="fa fa-tasks fa-fw"></i>작업</a></li>
	                     <li class="active"><a href="taskCalendar?prno=<c:out value="${projectInfo.prno}"/>"><i class="fa fa-calendar  fa-fw"></i>일정</a></li>
	                     <li><a href="taskWorker?prno=<c:out value="${projectInfo.prno}"/>"><i class="fa fa-user fa-fw"></i>작업자</a></li>
	                     <li><a href="taskMine?prno=<c:out value="${projectInfo.prno}"/>">내것만</a></li>
	                 </ul>
                </div>
            </div>             
            <div class="row">
                <div id='calendar' style="width: 90%"></div>
            </div>
        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->
</body>

</html>
