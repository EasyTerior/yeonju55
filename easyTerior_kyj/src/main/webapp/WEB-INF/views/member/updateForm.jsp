<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%-- JSTL --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="contextPath" value="${ pageContext.request.contextPath }" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
	crossorigin="anonymous" type="text/javascript"></script>
<script
	src="https://cdn.jsdelivr.net/npm/jquery@3.6.4/dist/jquery.min.js"
	type="text/javascript"></script>


<script type="text/javascript">
	$(document).ready(function(){
		// 주소 채우기
		$("#address").on("input", function(){
			addressFill();
			return false;
		});
		$("#detailAddress").on("input", function(){
			addressFill();
			return false;
		});
		$("#extraAddress").on("input", function(){
			addressFill();
			return false;
		});
		
		// 비밀번호 동일 여부 확인
		$("#memPassword1").on("input", function(){
			passwordCheck();
			return false;
		});
		$("#memPassword2").on("input", function(){
			passwordCheck();
			return false;
		});
		
		// 회원정보 수정 실패 후 modal 표시
		if (${not empty msgType}) {
			if (${msgType eq "실패 메세지"}) {
				$("#checkType .modal-header.card-header").attr("class", "modal-header card-header bg-warning");
			}
			$("#myModal").modal("show");
		}
		
		$(".updateList .on").addClass("fw-bold");
	});
	
	function addressFill() {
		var add1 = $("#address").val();
		var add2 = $("#detailAddress").val();
		var add3 = $("#extraAddress").val();
		var fullAddress = add1 + " " + add2 + " " + add3;
		$("#memAddress").val(fullAddress);
	}
	
	function passwordCheck() {
		var memPassword1 = $("#memPassword1").val();
		var memPassword2 = $("#memPassword2").val();
		if (memPassword1 != memPassword2) {
			$("#passMessage").text("비밀번호가 서로 일치하지 않습니다. 비밀번호를 확인해주세요.");
			$("#passMessage").css("color", "red");
		} else {
			$("#passMessage").text("비밀번호가 서로 일치합니다.");
			$("#passMessage").css("color", "green");
			$("#memPassword").val(memPassword1);
		}
	}
</script>

<title>updateForm.do</title>

<style type="text/css">
.hidden {
	display: none;
}
</style>
</head>
<body>
	<main class="main">
		<jsp:include page="../common/header.jsp"></jsp:include>
		<jsp:include page="../common/submenu.jsp"></jsp:include>
		<section class="fixed-top container-fluid overflow-auto"
			style="height: 100%; margin: 137px 0 0; padding: 56px 0 0 100px;">
			<div class="container-fluid"
				style="min-height: 100vh; margin-bottom: 200px;">
				<div class="container-fluid">
					<div class="mb-5">
						<h2 class="text-center">마이 페이지</h2>
					</div>
					<div class="row">
						<div class="col-4 bg-white">
							<input type="hidden" name="memName" id="memName"
								value="${ memResult.memName }" /> <img
								class="img d-block m-auto" style="width: 150px;"
								src="${ contextPath }/resources/images/common/person.png"
								alt="profile default">
							<p class="mt-3 mb-4 text-center fs-4 fw-bold ">${memResult.memName}님
								환영합니다.</p>
							<ul class="updateList m-auto" style="width: 200px;">
								<li id="editInfoBtn" class="mb-3 ps-2 on"><a
									href="#" class="link-dark text-decoration-none">개인정보 수정</a></li>
								<li id="changePasswordBtn" class="mb-3 ps-2"><a href="#"
									class="link-dark text-decoration-none">비밀번호 변경</a></li>
								<li class="mb-3 ps-2"><a href="#"
									class="link-dark text-decoration-none">저장한 이미지 확인</a></li>
								<li class="mb-3 ps-2"><a href="#"
									class="link-dark text-decoration-none">취향 결과 확인</a></li>
							</ul>
						</div>
						<div class="col-7" style="background-color: rgb(241, 241, 241);">
							<div class="container m-auto" style="width: 70%;">
								<form action="update.do" method="POST"
									class="form container needs-validation mt-4">
									<div id="graypart">




										<div id="personalInfo" class="hidden">
											<legend class="mb-4 fs-4 text-center">개인 정보 수정</legend>
											<!-- CSRF token -->
											<input type="hidden" name="${ _csrf.parameterName }"
												value="${ _csrf.token }" /> <input type="hidden" id="memID"
												name="memID" value="${ memResult.memID }" /> <input
												type="hidden" id="memName" name="memName"
												value="${ memResult.memName }" /> <input type="hidden"
												id="memPassword" name="memPassword" />
											<!-- memPassword1와 memPassword2가 일치해야만이 memPassword가 될 것 -->

											<div class="row mb-3">
											<input type="hidden" id="memPassword" name="memPassword" value="${memResult.memAddress}" />
											
												<label for="memNickname" class="col-sm-3 col-form-label">닉네임</label>
												<div class="col-sm-9">
													<input type="text" class="form-control" id="memNickname"
														name="memNickname" value="${ memResult.memNickname }"
														placeholder="공백 없이 한글, 영어, 숫자로 10자 미만의 닉네임만 가능합니다."
														pattern="^[ㄱ-ㅎ가-힣a-zA-Z0-9]+" maxlength="10" required />
												</div>
											</div>
											<div class="row mb-3">
												<label for="memPhone" class="col-sm-3 col-form-label">휴대폰
													번호</label>
												<div class="col-sm-9">
													<input type="text" value="${ memResult.memPhone }"
														class="form-control" id="memPhone" name="memPhone"
														placeholder="000-0000-0000"
														pattern="^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$"
														required />
												</div>
											</div>
											<div class="row mb-3">
												<label for="memEmail" class="col-sm-3 col-form-label">이메일</label>
												<div class="col-sm-9">
													<input type="email" value="${ memResult.memEmail }"
														class="form-control" id="memEmail" name="memEmail"
														placeholder="email@email.com"
														pattern="^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$"
														required />
												</div>
											</div>
											<div class="row mb-3">
												<label for="memAddress" class="col-sm-3 col-form-label">현재
													주소</label>
												<div class="col-sm-9">
													<div class="col-auto">
														<input type="text" name="memAddress" id="memAddress"
															class="form-control" readonly="readonly"
															value="${memResult.memAddress}" />
													</div>
												</div>
											</div>
											<div class="row mb-3">
												<label for="memAddress" class="col-sm-3 col-form-label">변경할
													주소</label> <input type="hidden" name="memAddress" id="memAddress" />
												<div class="col-sm-9">
													<div class="row mb-2">
														<div class="col-auto">
															<button type="button" class="btn btn-info align-top"
																onclick="addressFullFill()">우편번호 찾기</button>
														</div>
														<div class="col-auto">
															<input type="text" id="postcode" class="form-control"
																placeholder="우편번호" />
														</div>
													</div>
													<div class="row">
														<div class="col-auto">
															<input type="text" onchange="addressFill()" id="address"
																class="form-control" style="width: 300px;"
																placeholder="주소" />
														</div>
														<div class="col-auto">
															<input type="text" onchange="addressFill()"
																id="detailAddress" class="form-control"
																placeholder="상세주소" />
														</div>
														<div class="col-auto">
															<input type="text" style="width: 150px;"
																id="extraAddress" class="form-control"
																placeholder="참고항목" />
														</div>
													</div>
												</div>
											</div>
										</div>

										<div id="changePW" class="hidden">
										<input type="hidden" id="memID"
												name="memID" value="${ memResult.memID }" />
										<input type="hidden" id="memNickname"
												name="memNickname" value="${ memResult.memNickname }" />
										<input type="hidden" id="memPhone"
												name="memPhone" value="${ memResult.memPhone }" />
										<input type="hidden" id="memAddress"
												name="memAddress" value="${ memResult.memAddress }" />
											<legend class="mb-4 fs-4 text-center">비밀번호 변경</legend>
											<div class="row mb-3 position-relative">
												<label for="memPassword1" class="col-sm-3 col-form-label">비밀번호</label>
												<div class="col-sm-9">
													<input type="password" placeholder="비밀번호 현재 패턴 적용 안 함"
														name="memPassword1" id="memPassword1" class="form-control"
														onkeyup="passwordCheck()" value="memPassword"/>
												</div>
												<div class="valid-tooltip"></div>
											</div>
											<div class="row mb-3 position-relative">
												<label for="memPassword2" class="col-sm-3 col-form-label">비밀번호
													확인</label>
												<div class="col-sm-9">
													<input type="password" placeholder="비밀번호 현재 패턴 적용 안 함"
														name="memPassword2" id="memPassword2" class="form-control"
														onkeyup="passwordCheck()" value="memPassword" />
													<div class="valid-tooltip"></div>

												</div>
												<br> <span id="passMessage"></span>
											</div>
										</div>

										<div class="row mb-3">
											<div class="col-sm-10 offset-sm-2 text-center">
												<button type="submit" class="btn btn-primary">수정하기</button>
												<button type="reset" class="btn btn-warning">취소하기</button>
											</div>
										</div>

									</div>
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
	<div class="modal fade" id="myModal">
		<!-- animation : fade -->
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
					<button type="button" class="btn btn-danger"
						data-bs-dismiss="modal">닫기</button>
				</div>

			</div>
		</div>
	</div>
	<script
		src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"
		type="text/javascript"></script>
	<script type="text/javascript">
//개인정보 수정 AJAX 요청
function updatePersonalInfo() {
	var name = $("#name").val();
	var email = $("#email").val();
	
	$.ajax({
		url: "updatePersonalInfo.jsp",
		method: "POST",
		data: { name: name, email: email },
		success: function(response) {
			$("#personalInfoResult").text(response);
		},
		error: function() {
			$("#personalInfoResult").text("오류가 발생했습니다.");
		}
	});
}



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
    
    $(document).ready(function() {
    	// Initially show the personal info section and hide the change password section
    	  $('#personalInfo').removeClass('hidden');
    	  $('#changePW').addClass('hidden');

    	  // 개인정보 수정 버튼 클릭 이벤트 처리
    	  $('#editInfoBtn').click(function() {
    	    // Hide the change password section
    	    $('#changePW').addClass('hidden');
    	    
    	    // Toggle the visibility of the personal info section
    	    $('#personalInfo').toggleClass('hidden');
    	  });

    	  // 비밀번호 변경 버튼 클릭 이벤트 처리
    	  $('#changePasswordBtn').click(function() {
    	    // Hide the personal info section
    	    $('#personalInfo').addClass('hidden');
    	    
    	    // Toggle the visibility of the change password section
    	    $('#changePW').toggleClass('hidden');
    	  });
/*
        // 개인정보 저장 버튼 클릭 이벤트 처리
        $('#saveInfoBtn').click(function() {
          // 입력된 개인정보 가져오기
          var nickname = $('#nickname').val();
          var phone = $('#phone').val();
          var email = $('#email').val();
          var address = $('#address').val();

          // TODO: 개인정보 저장 로직 작성

          // 저장 후 화면 갱신 등의 작업 수행

          // 개인정보 수정 폼 숨기기
          $('#personalInfo').addClass('hidden');
        });

        // 비밀번호 저장 버튼 클릭 이벤트 처리
        $('#savePasswordBtn').click(function() {
          // 입력된 비밀번호 가져오기
          var newPassword = $('#newPassword').val();
          var confirmPassword = $('#confirmPassword').val();

          // TODO: 비밀번호 저장 로직 작성

          // 저장 후 화면 갱신 등의 작업 수행

          // 비밀번호 변경 폼 숨기기
          $('#changePasswordForm').addClass('hidden');
        });
        
        */
      });
</script>
</body>
</html>