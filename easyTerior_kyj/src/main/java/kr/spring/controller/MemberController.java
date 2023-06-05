	package kr.spring.controller; // 해당 controller 아래서만 사용한다고 servlet-context.xml에 명시함
	
	import java.io.File;
	import java.io.IOException;
	import java.util.Enumeration;
	import java.util.concurrent.CompletableFuture;
	
	
	import javax.servlet.ServletRequest;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpSession;
	
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.security.crypto.password.PasswordEncoder;
	import org.springframework.stereotype.Controller;
	import org.springframework.web.bind.annotation.PostMapping;
	import org.springframework.web.bind.annotation.RequestMapping;
	import org.springframework.web.bind.annotation.RequestParam;
	import org.springframework.web.bind.annotation.ResponseBody;
	import org.springframework.web.servlet.mvc.support.RedirectAttributes;
	
	import com.oreilly.servlet.MultipartRequest;
	import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
	
	import kr.spring.entity.Member;
	import kr.spring.mapper.MemberMapper;
	
	@Controller // controller 기능을 위해 annotation 처리
	public class MemberController {
		@Autowired
		private MemberMapper memberMapper;
		
		@Autowired
		private PasswordEncoder pwEncoder; // 비밀번호 인코딩
	
		// 회원가입 페이지 이동 : 요청 URL - /joinForm.do
		@RequestMapping("/joinForm.do")
		public String joinForm() {
			return "member/joinForm"; // do 뺄 것.
		}
	
		// 아이디 중복 확인 기능 요청 URL - /registerCheck.do
		@RequestMapping("/registerCheck.do")
		public @ResponseBody int registerCheck(@RequestParam("memID") String memID) {
			// System.out.println(memID);
			Member mem = memberMapper.registerCheck(memID);
	
			if (mem != null || memID.equals("")) {
				return 0;
			} else {
				return 1;
			}
		}
	
		// 회원가입 기능 : 요청 URL - /join.do
		@RequestMapping("/join.do") // RedirectAttributes 로서 리다이렉트 이동 시 데이터를 들고 가되 한 번만 사용 가능.
		
		public CompletableFuture<String> join(Member mem, RedirectAttributes rttr) { // 매개변수로 id, pwd, 이름, 나이, 성별, 이메일 등 Member 정보가 들어옴
			mem.setMemProfile(""); // MemProfile에 null 이 되어있으면 not null인 경우 에러가 있을 수 있음.
			
			return CompletableFuture.supplyAsync(()-> {
				int cnt = 0;
				
				try {
					String encyPw = pwEncoder.encode(mem.getMemPassword());
					mem.setMemPassword(encyPw);
					cnt = memberMapper.join(mem);
				} catch (Exception e) {
					System.out.println("Exception e : " + e);
					System.out.println(mem);
					rttr.addFlashAttribute("msgType", "실패 메세지");
					rttr.addFlashAttribute("msg", "회원가입에 실패하셨습니다. 다시 시도해주세요.");
					return "redirect:/joinForm.do";
				} finally {
					if (cnt == 1) {
						rttr.addFlashAttribute("msgType", "성공 메세지");
						rttr.addFlashAttribute("msg", "회원가입에 성공하셨습니다. 환영합니다. " + mem.getMemID() + " 님!");
						return "redirect:/";
					}
				}
				return null;
			});
			
		}
	
		// 로그인 페이지로 이동 요청 URL - /loginForm.do
		@RequestMapping("/loginForm.do")
		public String loginForm() {
			return "member/loginForm";
		}
	
		// 로그인 기능 요청 URL - /login.do
		@RequestMapping("/login.do")
		public CompletableFuture<String> login(Member mem, HttpSession session, RedirectAttributes rttr) {
			return CompletableFuture.supplyAsync(() -> {
				Member memInfo = memberMapper.getMember(mem.getMemID());
				boolean isMatches = pwEncoder.matches(mem.getMemPassword(), memInfo.getMemPassword());
	
				if ((!isMatches) || (memInfo == null)) {
					rttr.addFlashAttribute("msgType", "실패 메세지");
					rttr.addFlashAttribute("msg", "로그인에 실패하셨습니다. 아이디와 비밀번호를 확인해주세요.");
					return "redirect:/loginForm.do";
				} else {
					rttr.addFlashAttribute("msgType", "성공 메세지");
					rttr.addFlashAttribute("msg", "로그인에 성공하셨습니다. 안녕하세요. " + memInfo.getMemName() + " 님!");
					session.setAttribute("memResult", memInfo);
					return "redirect:/";
				}
			});
			
			
		}
	
		// 로그아웃 기능 : 요청 URL - /logout.do
		@RequestMapping("/logout.do")
		public CompletableFuture<String> logout(HttpSession session, RedirectAttributes rttr) {
			session.invalidate();
			rttr.addFlashAttribute("msgType", "성공 메세지");
			rttr.addFlashAttribute("msg", "성공적으로 로그아웃 되었습니다.");
			return CompletableFuture.completedFuture("redirect:/");
		}
	
		// 회원정보 수정 form으로 이동 기능 : 요청 URL - /updateForm.do
		@RequestMapping("/updateForm.do")
		public String updateForm() {
			return "member/updateForm";
		}
		
		
		// 회원정보수정 기능 : 요청 URL - /update.do
		@RequestMapping("/update.do")
		public CompletableFuture<String> update(Member mem, HttpSession session, RedirectAttributes rttr) {
			return CompletableFuture.supplyAsync(() -> {
				try {
					String encyPw = pwEncoder.encode(mem.getMemPassword());
					mem.setMemPassword(encyPw);
					int cnt = memberMapper.update(mem);
					if (cnt == 1) {
						session.setAttribute("memResult", mem);
						rttr.addFlashAttribute("msgType", "성공 메세지");
						rttr.addFlashAttribute("msg", "성공적으로 회원정보가 수정되었습니다.");
						return "redirect:/";
					} else {
						rttr.addFlashAttribute("msgType", "실패 메세지");
						rttr.addFlashAttribute("msg", "회원정보 수정에 실패하셨습니다. 다시 시도해주세요.");
						return "redirect:/updateForm.do";
					}
				} catch (Exception e) {
					rttr.addFlashAttribute("msgType", "실패 메세지");
					rttr.addFlashAttribute("msg", "회원정보 수정에 실패하셨습니다. 다시 시도해주세요.");
					return "redirect:/updateForm.do";
				}
			});
		}	
	
		
			// 비밀번호 변경 form으로 이동 기능 : 요청 URL - /updatePWForm.do
			@RequestMapping("/updatePWForm.do")
			public String updatePWForm() {
				return "member/updatePWForm";
			}
			
	//		// 비밀번호 변경 기능 : 요청 URL - /updatePWForm.do
	//		@RequestMapping("/updatePW.do")
	//		public CompletableFuture<String> updatePW(@RequestParam("oldPw") String oldPw,
	//				@RequestParam("newPw") String newPw, HttpSession session, RedirectAttributes rttr) {
	//			Member memResult = (Member) session.getAttribute("memResult");
	//
	//			return CompletableFuture.supplyAsync(() -> {
	//				try {
	//					boolean isMatches = pwEncoder.matches(oldPw, memResult.getMemPassword());
	//					if (!isMatches) {
	//						rttr.addFlashAttribute("msgType", "실패 메세지");
	//						rttr.addFlashAttribute("msg", "기존 비밀번호가 일치하지 않습니다.");
	//						return "redirect:/updatePWForm.do";
	//					}
	//					
	//					//암호화
	//					String encyPw = pwEncoder.encode(newPw);
	//					memResult.setMemPassword(encyPw);
	//					int cnt = memberMapper.update(memResult);
	//
	//					if (cnt == 1) {
	//						session.setAttribute("memResult", memResult);
	//						rttr.addFlashAttribute("msgType", "성공 메세지");
	//						rttr.addFlashAttribute("msg", "비밀번호가 성공적으로 변경되었습니다.");
	//						return "redirect:/";
	//					} else {
	//						rttr.addFlashAttribute("msgType", "실패 메세지");
	//						rttr.addFlashAttribute("msg", "비밀번호 변경에 실패하셨습니다. 다시 시도해주세요.");
	//						return "redirect:/updatePWForm.do";
	//					}
	//				} catch (Exception e) {
	//					rttr.addFlashAttribute("msgType", "실패 메세지");
	//					rttr.addFlashAttribute("msg", "비밀번호 변경에 실패하셨습니다. 다시 시도해주세요.");
	//					return "redirect:/updatePWForm.do";
	//				}
	//			});
	//		}
	
			
				
			// 저장한 이미지 확인 form으로 이동 기능 : 요청 URL - /updateImg.do
			@RequestMapping("/updateImg.do")
			public String updateImg() {
				return "member/updateImg";
			}		
	
			// 취향 결과 확인 form으로 이동 기능 : 요청 URL - /updateResult.do
			@RequestMapping("/updateResult.do")
			public String updateResult() {
				return "member/updateResult";
			}		
	
		// 프로필 이미지 등록으로 이동 : 요청 URL - /imageForm.do
		@RequestMapping("/imageForm.do")
		public String imageForm() {
			return "member/imageForm";
		}
	
		// 프로필 이미지 등록 기능 : 요청 URL - /imageUpload.do
		@RequestMapping("/imageUpload.do")
		@PostMapping(value = "/imageUpload.do", produces = "application/json;charset=UTF-8")
		public @ResponseBody CompletableFuture<String> imageUpload(HttpServletRequest request, HttpSession session,
				RedirectAttributes rttr) throws IOException {
			String path = session.getServletContext().getRealPath("/resources/upload/member");
			File Folder = new File(path);
			if (!Folder.exists()) {
				try {
					Folder.mkdir();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
	
			int size = 10 * 1024 * 1024;
			String file = "";
			String oriFile = "";
			String memID = "";
	
			try {
				MultipartRequest multi = new MultipartRequest(request, path, size, "UTF-8", new DefaultFileRenamePolicy());
				Enumeration<?> files = multi.getFileNames();
				String str = (String) files.nextElement();
				file = multi.getFilesystemName(str);
				oriFile = multi.getOriginalFileName(str);
				memID = multi.getParameter("memID");
			} catch (Exception e) {
				e.printStackTrace();
			}
	
			String memProfile = "/resources/upload/member/" + file;
			Member mem = new Member();
			mem.setMemID(memID);
			mem.setMemProfile(memProfile);
	
			return CompletableFuture.supplyAsync(() -> {
				try {
					int cnt = memberMapper.updateProfile(mem);
					if (cnt == 1) {
						Member memResult = (Member) session.getAttribute("memResult");
						memResult.setMemProfile(memProfile);
						session.setAttribute("memResult", memResult);
						rttr.addFlashAttribute("msgType", "성공 메세지");
						rttr.addFlashAttribute("msg", "프로필 사진이 성공적으로 변경되었습니다.");
					} else {
						rttr.addFlashAttribute("msgType", "실패 메세지");
						rttr.addFlashAttribute("msg", "프로필 사진 변경에 실패하셨습니다. 다시 시도해주세요.");
					}
				} catch (Exception e) {
					e.printStackTrace();
					rttr.addFlashAttribute("msgType", "실패 메세지");
					rttr.addFlashAttribute("msg", "프로필 사진 변경에 실패하셨습니다. 다시 시도해주세요.");
				}
				return "redirect:/updateForm.do";
			});
		}
		
		// 회원가입 페이지 이동 : 요청 URL - /leaveForm.do
				@RequestMapping("/leaveForm.do")
				public String leaveForm() {
					return "member/leaveForm"; // do 뺄 것.
				}
			
		
	//	public String imageUpload(HttpServletRequest request, RedirectAttributes rttr, HttpSession session) {
	//
	//		// 파일 업로드 DB에 파일을 넣는 것은 업로드가 아니라 Mybatis로 넣는 것이지 서버의 특정 폴더에 넣는 것이 업로드
	//		// COS 의 multipartRequest 라는 객체를 생성하여 그 객체를 통해서 업로드.
	//		MultipartRequest multi = null;
	//		int fileMaxSize = 100 * 1024 * 1024; // 파일 최대 크기 제한 -> 100 MB == 100 * 1024 * 1024
	//
	//		// 파일 저장될 위치 경로
	//		String savePath = request.getRealPath("resources/profile"); // resource/profile 에 저장하려는 저장경로 지정
	//		// webapp 이 contextPath 이므로 해당부터 들어가도록 처리.
	//
	//		// 인코딩 타입
	//		String encType = "UTF-8"; // encoding
	//
	//		// 중복제거 객체 -> 동일한 이름의 image 이름 처리.
	//		DefaultFileRenamePolicy dfrp = new DefaultFileRenamePolicy();
	//
	//		// multipart 객체 - 매개변수 : 요청데이터, 저장경로, 최대크기, 인코딩 박식, 파일명중복제거 객체
	//		try {
	//			multi = new MultipartRequest(request, savePath, fileMaxSize, encType, dfrp);
	//		} catch (IOException e) {
	//			// 확장자 구분
	//			e.printStackTrace();
	//		}
	//		// 파일 자체가 request로 넘겨지므로 request 그대로
	//
	//		String newProfile = "";
	//		// 사용자가 업도르한 파일 가져오기
	//		File file = multi.getFile("memProfile");
	//		if (file != null) {
	//			// 사용자가 파일을 올렸을 때.
	//			String ext = file.getName();
	//			ext = ext.substring(ext.lastIndexOf(".") + 1);
	//			ext = ext.toUpperCase(); // 전부 대문자 처리
	//			// System.out.println(ext);
	//			boolean isCheck = ext.equals("PNG") || ext.contains("JPG") || ext.contains("JPEG") || ext.equals("GIF");
	//			if (!isCheck) { // 이미지 파일이 아닐 경우,
	//				if (file.exists()) {
	//					// 현재 파일이 경로에 존재하는지 알려주는 메서드
	//					file.delete();
	//				}
	//				rttr.addFlashAttribute("msgType", "실패 메세지");
	//				rttr.addFlashAttribute("msg", "이미지 업로드에 실패하셨습니다. 확장자가 png, jpg, jpeg, gif 인 이미지 파일만 업로드가 가능합니다.");
	//				return "redirect:/imageForm.do";
	//			} else {// 이미지 파일인 경우,
	//				newProfile = file.getName();
	//				String memID = multi.getParameter("memID");
	//
	//				// 저장 전 기존의 이미지 프로필 삭제하기.
	//				// 업로드 준비가 된 후, 프로필 이미지가 이전에 존재한다면 존재하던 걸 먼저 삭제하기.
	//				String oldImg = memberMapper.getMember(memID).getMemProfile();
	//				File oldFile = new File(savePath+"/"+oldImg);
	//				if (oldFile.exists()) {
	//					// 기존 파일이 있다면
	//					oldFile.delete();
	//				} // 없다면 새로 업로드 하면 될 일.
	//				
	//				// 객체로서 DB에 보내기
	//				Member mem = new Member();
	//				mem.setMemProfile(newProfile);
	//				mem.setMemID(memID);
	//
	//				memberMapper.imageUpload(mem);
	//				// 방법 1. session에 memResult를 통해서 profile에 저장한 이미지 다시 넣어서 다시 set하기
	//				// 방법 2. memID에 동일한 정보를 다시 가져와서 다시 set하기 -> 재활용 가능
	//				// 수정된 회원 정보 다시 가져오기
	//				Member m = memberMapper.getMember(memID);
	//				session.setAttribute("memResult", m); // memResult라는 이름으로 session에 넣었으니 엎어치기
	//
	//				rttr.addFlashAttribute("msgType", "성공 메세지");
	//				rttr.addFlashAttribute("msg", "이미지 업로드에 성공하셨습니다. 프로필 이미지가 업데이트 됩니다.");
	//
	//				return "redirect:/";
	//			}
	//
	//		} else { // 파일 안 올렸을때
	//			rttr.addFlashAttribute("msgType", "실패 메세지");
	//			rttr.addFlashAttribute("msg", "이미지가 업로드 되지 않았습니다. 확장자(png, jpg, jpeg, gif)가 적절한 이미지를 올려주시길 바랍니다.");
	//			return "redirect:/imageForm.do";
	//		}
	//
	//	}
	
	}
