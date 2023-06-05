<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%-- JSTL --%>
<c:set var="contextPath" value="${ pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		// 회원가입 후 modal 표시
		if(${ not empty msgType}){
			if(${msgType eq "실패 메세지"}){ 
				$("#checkType .modal-header.card-header").attr("class", "modal-header card-header bg-warning");
			}
			$("#myModal").modal("show");
		}
	});
	
</script>
<title>loginForm.do</title>
</head>
<body>
<main class="main">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<jsp:include page="../common/submenu.jsp"></jsp:include>
	<section class="fixed-top container-fluid overflow-auto" style="height:100%;margin:137px 0 0;padding:56px 0 0 100px;">
	<div class="container-fluid" style="min-height:100vh;margin-bottom: 200px;">
		<div class="container-fluid">
			<div class="mb-5"><h2 class="text-center">회원 탈퇴</h2></div>
			
			<div class="container m-auto" style="width:70%;">
				<form>
				<input type="hidden" name="memID" value="${ memResult.memID }" />
				<p class="fs-5 fw-bold text-center">${ memResult.memID }님 정말로 탈퇴하시겠습니까?</p>
				<p class="text-center">탈퇴하시려면 비밀번호를 입력해주세요.</p>
				
					<div class="row mb-3 position-relative" style="width:600px;margin:0 auto;">
					    <label for="memPassword1" class="col-sm-2 col-form-label">비밀번호</label>
					    <div class="col-sm-7">
					        <input type="password" placeholder="비밀번호를 입력해주세요." name="memPassword" id="memPassword" class="form-control" />
					    </div>
					    <div class="valid-tooltip"></div>
					</div>
					<div class="m-auto offset-sm-2 text-center">
					        <button type="submit" class="btn btn-primary">탈퇴하기</button>
					    </div>
				</form>
			</div>
			
		</div>
	</div>
	</section>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</main>

<!-- The Modal -->
<div class="modal fade" id="myModal"><!-- animation : fade -->
  <div class="modal-dialog">
    <div id="checkType" class="card modal-content">

      <!-- Modal Header -->
      <div class="modal-header card-header">
        <h4 class="modal-title text-center">${ msgType }</h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <!-- Modal body -->
      <div class="modal-body">
        <p id="checkMessage" class="text-center">${ msg }</p>
      </div>

      <!-- Modal footer -->
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Close</button>
      </div>

    </div>
  </div>
</div>
</body>
</html>