<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<jsp:include page="/layout/sharedHeader.jsp"></jsp:include>
	<title>내 문의</title>
</head>
<style>
	.main-container {
	     display: flex;
	     min-height: 100vh;
	     font-family: 'Arial', sans-serif;
	     background-color: #f4f6f9;
	 }
	 .content {
	      width:100%;
	      padding: 40px;
	      background-color: #ffffff;
	 }

	h1 {
	    text-align: center; /* 제목 중앙 정렬 */
	    color: #4a90e2; /* 제목 색상 */
	    margin-bottom: 20px; /* 제목과 버튼 간의 간격 */
	}

	button {
	    background-color: #5cb85c; /* 버튼 기본 색상 */
	    color: white; /* 버튼 텍스트 색상 */
	    padding: 10px 15px; /* 버튼 패딩 */
	    border: none; /* 테두리 없음 */
	    border-radius: 4px; /* 둥근 모서리 */
	    cursor: pointer; /* 포인터 커서 */
	    margin-bottom: 20px; /* 버튼과 테이블 간의 간격 */
	    display: block; /* 버튼을 블록 요소로 */
	    width: 100%; /* 전체 너비 사용 */
	    max-width: 200px; /* 최대 너비 설정 */
	    margin: 0 auto; /* 중앙 정렬 */
	}

	button:hover {
	    background-color: #4cae4c; /* 호버 시 어두운 색상 */
	}

	table {
			width: 100%;
			border-collapse: collapse;
			font-size: 16px;
			box-shadow: 0 2px 8px rgba(0,0,0,0.1);
			border-radius: 8px;
			overflow: hidden;
			margin-bottom: 30px;
		}

	th,td {
			padding: 15px 20px;
			text-align: center;
		}
		
	th{
			background-color: #343a40;
			color: #fff;
			font-weight: bold;
			font-size: 1.1em; /* 글자 크기 조정 */
	}


	tr:nth-child(even) {
		    background-color: #f2f2f2;
	}
	
	tr:hover {
	        background-color: #e9ecef;
	}
	
	td,a{
			color: black;
			text-decoration: none;
			transition: color 0.3s;
			font-size: 1em; /* 글자 크기 조정 */
	}
		
	td a:hover{
			color: #0056b3; /* 진한 파란색 */
			text-decoration: underline;
	}
		
	td:last-child {
	        text-align: center;
	}
</style>

<body>
	<main class="main-container">
		<div id="app" class="content">
			<h1>내 문의</h1>
			<button @click="fnCheckRemove">선택삭제</button>
			<table>
				<tr>
					<th></th>
					<th>제목</th>
					<th>내용</th>
					<th>작성일</th>
					<th>답변</th>
					<th>삭제</th>
				</tr>
				<tr v-for="item in list" :key="item.inquiryId">
					<td>
						<input type="checkbox" v-model="selectItem" :value="item.inquiryId">
					</td>
					<td>{{item.title}}</td>
					<td>
						<a href="#" @click="fnView(item.inquiryId)">
						{{item.message}}</a>(답변 완료시 내용 클릭)
					</td>
					<td>{{item.createdDateFormatted}}</td>
					<td>{{item.answer}}</td>
					<td>
						<button @click=fnDelete(item.inquiryId)>삭제</button>
					</td>
				</tr>	
			</table>
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
				list: [],
				sessionUserId: '',	
				selectItem: [],
            };
        },
        methods: {
            fnGetList() {
				var self = this;
				
				if (!this.sessionUserId) {
				      console.log("로그인 정보가 없습니다.");
				      return;
				  }
				var nparmap = {
					userId: self.sessionUserId,
				};
				
				$.ajax({
					url: "inquiry-list.dox",
					dataType: "json",	
					type: "POST", 
					data: nparmap,
					success: function(data) { 
						console.log(data);
						self.list = data.list;	
					}
				});
            },
			fnSession() {
			    $.ajax({
			        url: "sharedHeader.dox",
			        dataType: "json",	
			        type: "POST", 
			        success: (data) => {
			            this.isLogin = data.isLogin;
			            if (data.isLogin) {
			                this.sessionUserId = data.userId;  
			                console.log('세션아이디:', this.sessionUserId);
							this.fnGetList(); // 로그인 후 문의 내역 가져오기
			            } else {
			                this.sessionUserId = '';
			            }
			        }
			    });
			},
			fnCheckRemove() {
				var self = this;
				
				if (self.selectItem.length === 0) {
					alert("삭제할 항목을 선택하세요.");
					return;
				}
				
				var fList = JSON.stringify(self.selectItem);
				var nparmap = {selectItem : fList};
				$.ajax({
					url:"delete-inquiry.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						alert("삭제 완료");
						self.fnGetList(1);
					}
				});
        	},
			fnDelete(num){
				var self = this;
				
				var nparmap = {
					inquiryId : num
				};
				$.ajax({
					url:"inquiry-remove.dox",
					dataType:"json",	
					type : "POST", 
					data : nparmap,
					success : function(data) { 
						alert(data.message);
						self.fnGetList();
					}
				});
			},
			fnView(inquiryId){
				$.pageChange("answerdetail",{inquiryId: inquiryId});
			}
        },
        mounted() {
            var self = this;
			self.fnSession();	
        }
    });
    app.mount('#app');
</script>