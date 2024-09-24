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
        font-family: Arial, sans-serif;
        background-color: #f9f9f9;
    }

    .study-group-list-container {
        max-width: 100%;
        padding: 20px;
        display: flex;
        justify-content: center;
    }

    .study-group-list-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 20px;
    }

    .study-group-list-item {
        background-color: #fff;
        padding: 15px;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .study-group-list-item:hover {
        transform: translateY(-5px);
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
    }

    .study-group-list-title {
        font-size: 18px;
        margin: 10px 0;
        font-weight: bold;
    }

    .study-group-list-details {
        font-size: 14px;
        color: #555;
        margin-bottom: 10px;
    }

    .study-group-list-image {
        width: 100%;
        height: 180px;
        object-fit: cover;
        border-radius: 4px;
    }

    .study-group-list-search-bar {
        width: 100%;
        padding: 20px;
        box-sizing: border-box;
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 5px;
    }

    .study-group-list-search-bar input[type="text"] {
        width: 70%;
        padding: 12px;
        border: 1px solid #ccc;
        border-radius: 5px;
        font-size: 16px;
    }

    .study-group-list-search-bar button {
        width: 15%;
        background-color: #333;
        border: none;
        padding: 12px;
        border-radius: 5px;
        color: white;
        cursor: pointer;
        font-size: 16px;
        transition: background-color 0.3s ease;
    }

    .study-group-list-search-bar button:hover {
        background-color: #0056b3;
    }

    @media (max-width: 768px) {
        .study-group-list-grid {
            grid-template-columns: 1fr;
        }

        .study-group-list-search-bar input[type="text"],
        .study-group-list-search-bar button {
            width: 100%;
            margin-bottom: 10px;
        }
    }
</style>
<body>
    <main class="main-container">
        <aside class="sidebar">
            <jsp:include page="/layout/study-group-sidebar.jsp"></jsp:include>
        </aside>
        
        <div id="app" class="study-group-list-content">
			{{age}} {{onOffMode}} {{subjectTypeId}} {{genderGroup}} {{startDate}} {{startTime}} {{endTime}} {{participants}}
            <div class="study-group-list-search-bar">
                <input type="text" placeholder="검색어를 입력하세요">
                <button>검색</button>
                <button>스터디 등록</button>
            </div>
            <div class="study-group-list-container">
                <div class="study-group-list-grid">
                    <div class="study-group-list-item" v-for="item in groupList">
						<template v-if="item">
		                    <img  src="../src/profile.png" alt="Product Image" class="study-group-list-image">
		                    <div class="study-group-list-title">[{{item.name}}]{{item.description}}</div>
							<template v-if="!item.participants">
		                   		 <div class="study-group-list-details">{{item.genderGroup}} | {{item.onOffMode}} | {{item.age}} |인원 0 / {{item.maxparticipants}}</div>
							</template>
							<template v-else>
		                   		 <div class="study-group-list-details">{{item.genderGroup}} | {{item.onOffMode}} | 인원 {{participants}} / {{item.maxparticipants}}</div>
							</template>
		                    <div class="study-group-list-details">시작일  {{item.stgStartDate}} ~ | 시간 {{item.stgStudyTime}}</div>
						</template>
						<template v-if="!item">
						<div>검색된 결과가 없습니다.</div>
						</template>
                    </div>
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
					participants :'${participants}'
	            };
	        },
	        methods: {
				fnGetList(){
					var self = this;
					var nparmap = { age : self.age, onOffMode : self.onOffMode, 
									genderGroup : self.genderGroup,subjectTypeId : self.subjectTypeId,
									startDate : self.startDate, startTime : self.startTime, endTime : self.endTime,
									participants : self.participants
					};
					$.ajax({
						url:"/selectStuGroupListSidebar.dox",
						dataType:"json",	
						type : "POST", 
						data : nparmap,
						success : function(data) { 
							console.log(data);
							self.groupList = data.groupList;
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