<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<link rel="icon" href="/favicon.ico" type="image/x-icon">
	<meta charset="UTF-8">
	<jsp:include page="/layout/sharedHeader.jsp"></jsp:include>
	<title>첫번째 페이지</title>
	<style>
		.content {
			display:flex;
			flex-direction:column;
			align-items:center;
			justify-content:center;
			padding-bottom:90px;
		}
		button {
			background-color:#FF8C00;
			border-radius:4px;
			border:none;
			height:30px;
			width:80px;
			margin-top:10px;
			color:white;
		}
		button:hover {
			background-color:#FFA726;
			color:black;
		}
		.input-color {
			background-color:black;
			border-radius:4px;
			text-align:center;
			margin-top:10px;
			border:black;
			height:30px;
			color:white;
		}
		.text-section {
			margin-bottom:3px;
		}
	</style>
</head>
<body>
		<main class="main-container">
			
	        <aside class="sidebar">
				<jsp:include page="/layout/header_sidebar.jsp"></jsp:include>
	        </aside>

	        <div class="content">
				<div id="app">
					
					
					
					
				</div>
			</div>
	    </main>

	<jsp:include page="/layout/footer.jsp"></jsp:include>

</body>
</html>
<script>
	//localStorage.setItem('data', JSON.stringify(data));
	// JSON.parse(localStorage.getItem('data')).result
    const app = Vue.createApp({
        data() {
            return {
				
			};
        },
        methods: {
			fnConfrimPw() {
				var self=this;
				if(!self.password) {
					return;
				}
				var nparam={
					userId:self.userId,
					password:self.password
				};
				$.ajax({
					url:"/recheckPassword.dox",
					dataType:"json",	
					type : "POST", 
					data : nparam,
					success : function(data) {
						console.log("AJAX 응답 데이터4:", data); 
						if(data.result == 'success'){
							alert("정말로 탈퇴하시겠습니까?");
							self.fnDeleteUp();
	                        alert(data.message);
						}	
					 }
				});
			}
   	 },			
			
        mounted() {
            var self = this;
			self.fnConfrimPw();
        }
    });
    app.mount('#app');
</script>