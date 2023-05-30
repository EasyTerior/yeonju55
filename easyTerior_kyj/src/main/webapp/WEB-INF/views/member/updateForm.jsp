<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%-- JSTL --%>
<c:set var="contextPath" value="${ pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<link rel="stylesheet" href="resources/css/mypage.css">

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"></script>

<script>
//주소 채우기
function addressFill(){
	let add1 = $("#address").val();
	let add2 = $("#detailAddress").val();
	let add3 = $("#extraAddress").val();
	let fullAddress = add1+ " " + add2 + " " + add3;
	$("#memAddress").val(fullAddress);
	
}
</script>
<script type="text/javascript">
	// 비밀번호 동일 여부 확인
	function passwordCheck(){
		let memPassword1 = $("#memPassword1").val();
		let memPassword2 = $("#memPassword2").val();
		if (memPassword1 != memPassword2){
			$("#passMessage").text("비밀번호가 서로 일치하지 않습니다. 비밀번호를 확인해주세요.");
			$("#passMessage").css("color","red");
		}else{
			$("#passMessage").text("비밀번호가 서로 일치합니다.");
			$("#passMessage").css("color","green");
			$("#memPassword").val(memPassword1);
		}
		
	}
	
	$(document).ready(function(){
		// 회원가입 실패 후 modal 표시
		if(${ not empty msgType}){
			if(${msgType eq "실패 메세지"}){
				$("#checkType .modal-header.card-header").attr("class","modal-header card-header bg-warning");
			}
			$("#myModal").modal("show");
		}
	});
	
</script>

<title>updateForm.do</title>
</head>
<body>
<main class="main">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<jsp:include page="../common/submenu.jsp"></jsp:include>
	
	<section class="fixed-top container-fluid overflow-auto" style="height:100%;margin:137px 0 0;padding:56px 0 0 100px;">
	
	<div class="container-fluid" style="min-height:100vh;margin-bottom: 200px;">
		<div class="container-fluid">
		<h2 style="text-align:center">마이 페이지</h2>
		<br>
			<div style="display:flex; justify-content: center; text-align:center;"> 
			
			<div style="height: 700px; width: 30%;">
				<img style="width:250px; height:250px" src="resources/images/common/person.png"/ >
				<input type="hidden" name=memName id="memName" value="${ memResult.memName }" />
				
				<p><b>${memResult.memName}님 환영합니다.</b></p>
				
				<br>
				
				<ul class="updateli" >
				  <li><a href="updateForm.do"><b>개인정보 수정</b></a></li>
				  <li><a href="updatePWForm.do">비밀번호 변경</a></li>
				  <li><a href="updateImg.do">저장한 이미지 확인</a></li>
				  <li><a href="updateResult.do">취향 결과 확인</a></li>

				</ul>
			</div>

		<div class="card " style=" width:70%">
			
			<div class="card-header"><h3 class="text-center">개인 정보 수정</h3></div>
			<div class="card-body">
				<form action="update.do" method="POST" class="form container">
					<!-- CSRF token -->
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					<input type="hidden" id="memID" name="memID" value="${ memResult.memID }" />
					<input type="hidden" id="memPassword" name="memPassword" /> <!-- memPassword1와 memPassword2가 일치해야만이 memPassword가 될 것 -->
					<input type="hidden" name=memName id="memName" value="${ memResult.memName }" />
					
					<table class="table table-bordered text-center">
						<tbody>
							<tr>
								<th class="align-middle" style="width:150px;"><label for="memPassword1">사용자 비밀번호</label></th>
								<td class="align-middle">
									<input type="password" onkeyup="passwordCheck()" name=memPassword1 id="memPassword1" value=""class="form-control" maxlength=20 placeholder="비밀번호를 입력하세요."  />
								</td>
							</tr>
							<tr>
								<th class="align-middle" style="width:150px;"><label for="memPassword2">사용자 비밀번호 확인</label></th>
								<td class="align-middle">
									<input type="password" onkeyup="passwordCheck()" name=memPassword2 id="memPassword2" class="form-control" maxlength=20 placeholder="비밀번호를 확인하세요."  />
								</td>
							</tr>
							
						
							<tr>
								<th class="align-middle" style="width:150px;"><label for="memNickname">닉네임</label></th>
								<td class="align-middle">
									<input type="text" name=memNickname id="memNickname" value="${ memResult.memNickname }" class="form-control" maxlength=20  placeholder="닉네임을 입력하세요." required="required" />
								</td>
							</tr>
							<tr>
								<th class="align-middle" style="width:150px;"><label for="memPhone">핸드폰 번호</label></th>
								<td class="align-middle">
									<input type="text" name=memPhone id="memPhone" value="${ memResult.memPhone }" class="form-control" placeholder="핸드폰 번호를 입력하세요." required="required" />
								</td>
							</tr>
							
							<tr>
								<th class="align-middle" style="width:150px;"><label for="memEmail">이메일</label></th>
								<td class="align-middle">
									<input type="email" name=memEmail id="memEmail" value="${ memResult.memEmail }" class="form-control" maxlength=150 placeholder="이메일을 입력하세요." pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" required="required" />
								</td>
							</tr>
							
							<tr>
								<th class="align-middle" style="width:150px;"><label for="memAddress">주소</label></th>
								<td class="align-middle">
									<input type="text" readonly="readonly" name=memAddress id="memAddress" value="${ memResult.memAddress }" class="form-control" maxlength=150 placeholder="주소를 입력하세요." required="required" />
								</td>
							</tr>
							
							<tr>
							<th class="align-middle" style="width:150px;"><label for="memAddress">주소 변경하기</label></th>
							<td><div class="row mb-3">
					    
					    <input type="hidden" name="memAddress" id="memAddress" />
					    <div class="col-sm-10">
					    	<div class="row mb-2">
					    		<div class="col-auto">
					    			<button type="button" class="btn btn-sm btn-light align-top" onclick="addressFullFill()">우편번호 찾기</button>
					    		</div>
					    		<div class="col-auto">
					    			<input type="text" id="postcode" class="form-control"  placeholder="우편번호" />
					    		</div>
					    	</div>
					    	<div class="row">
					    		<div class="col-auto">
					    			<input type="text" onchange="addressFill()" id="address" class="form-control" style="width: 300px;" placeholder="주소"  />
					    		</div>
					    		<div class="col-auto">
					    			<input type="text" onchange="addressFill()" id="detailAddress" class="form-control" placeholder="상세주소" />
					    		</div>
					    		<div class="col-auto">
					    			<input type="text" "
    width: 150px;
" id="extraAddress" class="form-control" placeholder="참고항목" />
					    		</div>
					    	</div>
					    </div>
					</div>
					</td>
							</tr>
							
						</tbody>
						<tfoot>
							<tr>
								<td colspan="2" class="pull-right">
									<p id="passMessage" class="text-center fw-bold"></p>
									<button type="submit" class="btn btn-info">수정하기</button>
									<button type="reset" class="btn btn-secondary">취소하기</button>
								</td>
							</tr>
						</tfoot>
					</table>
				</form>
			</div>
		</div>
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
        <h4 id="titleMsg" class="modal-title text-center">${ msgType }</h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <!-- Modal body -->
      <div class="modal-body">
        <p id="checkMessage" class="text-center">${ msg }</p>
      </div>

      <!-- Modal footer -->
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-bs-dismiss="modal">닫기</button>
      </div>

    </div>
  </div>
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    function addressFullFill() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    // 조합된 참고항목을 해당 필드에 넣는다.
                    document.getElementById("extraAddress").value = extraAddr;
                
                } else {
                    document.getElementById("extraAddress").value = '';
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('postcode').value = data.zonecode;
                document.getElementById("address").value = addr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("detailAddress").focus();
            }
        }).open();
    }
</script>
</body>
</html>