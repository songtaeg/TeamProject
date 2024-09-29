<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<jsp:include page="/layout/sharedHeader.jsp"></jsp:include>
	<title>첫번째 페이지</title>
</head>
<style>
		body {
			margin: 0;
			padding: 0;
			font-family: 'Noto Sans KR', Arial, sans-serif;
			background-color: #f7f7f7;
			color: #333;
		}

		.study-group-list-content {
			width: 80%;
			margin: 40px auto;
			background: #ffffff;
			border-radius: 15px;
			padding: 30px;
			box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.1);
		}

		.study-group-list-search-bar {
			display: flex;
			justify-content: space-between;
			align-items: center;
			margin-bottom: 30px;
			gap: 15px;
		}

		.study-group-list-search-bar input[type="text"] {
			flex: 1;
			padding: 12px 16px;
			border: 1px solid #ddd;
			border-radius: 10px;
			font-size: 16px;
			transition: border 0.3s;
		}

		.study-group-list-search-bar input[type="text"]:focus {
			border-color: #007bff;
			outline: none;
		}

		.study-group-list-search-bar button {
			padding: 12px 18px;
			border: none;
			border-radius: 10px;
			background-color: #007bff;
			color: white;
			font-size: 16px;
			cursor: pointer;
			transition: background 0.3s ease;
		}

		.study-group-list-search-bar button:hover {
			background-color: #0056b3;
		}

		.study-group-list-grid {
			display: grid;
			grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
			gap: 30px;
		}

		.study-group-list-item {
			background: #f9f9f9;
			border-radius: 12px;
			box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.1);
			transition: transform 0.3s ease, box-shadow 0.3s ease;
		}

		.study-group-list-item:hover {
			transform: translateY(-10px);
			box-shadow: 0px 12px 24px rgba(0, 0, 0, 0.2);
		}

		.study-group-list-image {
			width: 100%;
			height: 200px;
			object-fit: cover;
			border-top-left-radius: 12px;
			border-top-right-radius: 12px;
		}

		.study-group-list-title {
			font-size: 20px;
			font-weight: bold;
			margin: 20px 0;
			padding: 0 20px;
			text-align: center;
			color: #333;
		}

		.study-group-list-details {
			font-size: 16px;
			color: #555;
			padding: 0 20px 20px;
			text-align: center;
			line-height: 1.6;
		}

		.study-group-list-details a {
			color: red;
			font-weight: bold;
		}

		.stu-comm-myboard-pagination {
			display: flex;
			justify-content: center;
			gap: 15px;
			margin-top: 30px;
		}

		.stu-comm-myboard-pagination button {
			background: #ddd;
			border: none;
			padding: 12px 16px;
			border-radius: 50px;
			font-size: 16px;
			cursor: pointer;
			transition: background 0.3s ease;
		}

		.stu-comm-myboard-pagination button:hover {
			background: #bbb;
		}

		.stu-comm-myboard-pagination button.active {
			background: #007bff;
			color: #fff;
			font-weight: bold;
		}

		.stu-comm-myboard-pagination button:disabled {
			background: #aaa;
			cursor: not-allowed;
		}

		@media (max-width: 768px) {
			.study-group-list-search-bar {
				flex-direction: column;
				align-items: flex-start;
			}

			.study-group-list-search-bar input[type="text"] {
				width: 100%;
				margin-bottom: 10px;
			}

			.study-group-list-grid {
				grid-template-columns: 1fr;
			}

			.study-group-list-item {
				margin: 0 20px;
			}
		}
	</style>
<body>
    <main class="main-container">
        <aside class="sidebar">
            <jsp:include page="/layout/study-group-sidebar.jsp"></jsp:include>
        </aside>
        
		<div id="app" class="study-group-list-content">
			<div class="study-group-list-search-bar">
				<input type="text" placeholder="검색어를 입력하세요" v-model="search" @keyup.enter="fnGetList()">
				<button @click="fnGetList()">검색</button>
				<button @click="fnFullView()">전체보기</button>
				<button @click="fnStudyCreate()">스터디 등록</button>
			</div>
			<div class="study-group-list-container">
				<div class="study-group-list-grid">
					<div class="study-group-list-item" v-for="item in groupList">
						<template v-if="item">
							<template v-if="item.filePath">
								<img :src="item.filePath" alt="Product Image" class="study-group-list-image" @click="fnDetail(item.studyGroupId)">
							</template>
							<template v-else>
								<img src="../src/profile.png" alt="Product Image" class="study-group-list-image" @click="fnDetail(item.studyGroupId)">
							</template>
							<div class="study-group-list-title" @click="fnDetail(item.studyGroupId)">
								[{{item.name}}]{{item.studyName}}
							</div>
							<template v-if="item.applyY != item.maxparticipants">
								<div class="study-group-list-details" @click="fnDetail(item.studyGroupId)">
									{{item.genderGroup}} | {{item.onOffMode}} | {{item.age}} | 인원 {{item.applyY}} / {{item.maxparticipants}}
								</div>
							</template>
							<template v-if="item.applyY == item.maxparticipants">
								<div class="study-group-list-details" @click="fnDetail(item.studyGroupId)">
									{{item.genderGroup}} | {{item.onOffMode}} | {{item.age}} | <a>참여 인원 마감</a>
								</div>
							</template>
							<div class="study-group-list-details" @click="fnDetail(item.studyGroupId)">
								시작일 {{item.stgStartDate}} ~ | 시간 {{item.stgStudyTime}}
							</div>
						</template>
						<template v-if="!item">
							<div>검색된 결과가 없습니다.</div>
						</template>
					</div>
				</div>
				<div class="stu-comm-myboard-pagination">
					<button @click="fnGetList(currentPage - 1)" :disabled="currentPage <= 1">이전</button>
					<button v-for="page in totalPages" :key="page" :class="{active: page == currentPage}" @click="fnGetList(page)">
						{{ page }}
					</button>
					<button @click="fnGetList(currentPage + 1)" :disabled="currentPage >= totalPages">다음</button>
				</div>
			</div>
		</div>
    </main>
    <jsp:include page="/layout/footer.jsp"></jsp:include>
</body>
</html>
<script>
	 const app = Vue.createApp({
	        data() {
	            return {
					isLogin: false,
					sessionUserId: '',
					sessionUserNickName: '',
					groupList: [],
					age : '${age}',
					onOffMode : '${onOffMode}',
					subjectTypeId : '${subjectTypeId}',
					genderGroup : '${genderGroup}',
					startDate : '${startDate}' || new Date().toISOString().substring(0, 10), // 기본값 오늘 날짜로 설정
					startTime : '${startTime}',
					endTime : '${endTime}',
					participants :'${participants}',
					totalPages: 5,
	                currentPage: 1,      // 현재 페이지 
	                pageSize: 12,         // 한 페이지에 보여줄 개수 
					search:""
	            };
	        },
	        methods: {
				fnDetail(boardId) {
					$.pageChange("/study-group-detail", { boardNo: boardId });
				},
				fnFullView(){
					var self = this;
					self.age = '';
					self.onOffMode ='';
					self.subjectTypeId='';
					self.genderGroup='';
					self.startDate = new Date().toISOString().substring(0, 10);
					self.startTime = '';
					self.endTime='';
					self.participants='';
					self.fnGetList();
				},
				fnStudyCreate(){
					var self = this;
					if(!self.isLogin){
						alert("로그인 먼저 하세요.");
						document.getElementById('headerLoginModal').showModal();
						document.getElementById('inputId').focus();
						return;
					}else{
					location.href="/study-group-insert";						
					}
				},
				fnGetList(page = 1){
					var self = this;
					const startIndex = (page - 1) * self.pageSize;
	                const outputNumber = self.pageSize;
	                self.currentPage = page;
					var nparmap = { age : self.age, onOffMode : self.onOffMode, 
									genderGroup : self.genderGroup,subjectTypeId : self.subjectTypeId,
									startDate : self.startDate, startTime : self.startTime, endTime : self.endTime,
									participants : self.participants,startIndex: startIndex, 
									outputNumber: outputNumber , search : self.search
					};
					$.ajax({
						url:"/selectStuGroupListSidebar.dox",
						dataType:"json",	
						type : "POST", 
						data : nparmap,
						success : function(data) { 
							console.log(data);
							self.groupList = data.groupList;
							self.groupListCnt = data.groupListCnt;
							self.totalPages = Math.ceil(self.groupListCnt / self.pageSize);
						}
					});
		        },
				fnSession(){
					var self = this;
					var nparmap = {
					};
					$.ajax({
						url:"sharedHeader.dox",
						dataType:"json",	
						type : "POST", 
						data : nparmap,
						success : function(data) {
								console.log(data);
							self.isLogin = data.isLogin 
							if(data.isLogin){
								self.sessionUserId = data.userId;
								self.sessionUserNickName = data.userNickName;
								self.isAdmin = data.isAdmin;
								console.log('세션아이디:', self.sessionUserId);  // sessionUserId가 제대로 설정되었는지 확인
							} else {
								self.sessionUserId = '';
								self.sessionUserNickName = '';
							}
						
						}
					});
				},
	        },
	        mounted() {
	            var self = this;
				self.fnSession();
				self.fnGetList();
				window.addEventListener('loginStatusChanged', function(){
					if(window.sessionStorage.getItem("isLogin") === 'true'){
						self.isLogin = true;	
					} else{
						self.isLogin = false;
					};
					self.fnSession();
				});
				window.addEventListener('sideBarEventAge', function(){
					self.age = window.sessionStorage.getItem("age");
					self.fnGetList();
				});
				window.addEventListener('sideBarEventonOff', function(){
					self.onOffMode = window.sessionStorage.getItem("onOffMode");
					self.fnGetList();
				});
				window.addEventListener('sideBarEventboardTypeId', function(){
					self.subjectTypeId = window.sessionStorage.getItem("boardTypeId");
					self.fnGetList();
				});
				window.addEventListener('sideBarEventgenderGroup', function(){
					self.genderGroup = window.sessionStorage.getItem("genderGroup");
					self.fnGetList();
				});
				window.addEventListener('sideBarEventStartDate', function(){
					self.startDate = window.sessionStorage.getItem("startDate");
					self.fnGetList();
				});
				window.addEventListener('sideBarEventStartime', function(){
					self.startTime = window.sessionStorage.getItem("startTime");
					self.endTime = window.sessionStorage.getItem("endTime");
					self.fnGetList();
				});
				window.addEventListener('sideBarEventparticipants', function(){
					self.participants = window.sessionStorage.getItem("participants");
					self.fnGetList();
				});

	        }
	    });
	    app.mount('#app');
	</script>