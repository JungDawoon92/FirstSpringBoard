<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		
		String toID = "admin";
%>

<!DOCTYPE html>
<html>
<head>
  <title>Lady bug</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="/ex/resources/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
  <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css" integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">
 
  <link rel="stylesheet" href="/ex/resources/chatcss/styles.css" />
</head>
 <body>
<div id ="change">
<div id="togglechat" style="background-color : #f4f5f7;  box-shadow: 0 30px 60px rgba(50, 50, 93, 0.25); width: 304px;height: 504px; overflow-y: auto;">

    <div class="header-wrapper" style="position: absolute;">
      <header class="header" style="margin-bottom: 0px;">
        <div class="header__header-column">
          <div class="header__back-btn" onclick="buttonback_click()">
            <i class="fas fa-arrow-left"></i>
          </div>
        </div>
        <div class="header__header-column">
        	<h1 class="header__title">Lady bug</h1>
     	 </div>
      <div class="header__header-column">
        <span class="header__icon">
          <i class="fas fa-cog"></i>
        </span>
      </div>
      </header>
    </div>
    <main class="chat-screen">
      <ul id="chatList" class="chat__messages" style="padding-left: 5px;">
      <li class="chat__timestamp">&nbsp;</li>
        <span class="chat__timestamp">Monday, December 30, 2019</span>
      </ul>
    </main>
	    <div class="chat__write--container chat_input" style="position: absolute;">
	      <input
	      	id="chatContent"
	        type="text"
	        class="chat__write"
	        placeholder="Send message"
	        class="chat__write-input"
	        style="margin-bottom: 90px; position: fixed; width: 310px; top: 570px;"
	        onkeydown="return enter()"
	      />
	    </div>
	     </div>
	     
	     
	     <script type="text/javascript">
		var messageTextArea = document.getElementById("messageTextArea");

		webSocket.onerror = function(message) {
			
			messageTextArea.value += "error...\n";

			
			$('#chatList').append('<li class="incoming-message message">' + 
	  				'<div class="message__content">' +
	  				'<span class="message__bubble">' +
	  				'error...' +
	  				'</span>' +
	  				'</div>' +
	  				'<div class="media-body">' +
	  				' </li>');
		};
		webSocket.onmessage = function(message) {
			
			$(".checkone").replaceWith(); // 채팅방을 누르는것만으로도 메세지가 가게끔한다.
			
			
			messageTextArea.value += "(operator) => " + message.data + "\n";
			
			$('#chatList').append('<li class="incoming-message message">' + 
					'<img src="/ex/resources/chatcss/hello.png" class="m-avatar message__avatar" />'+
	  				'<div class="message__content">' +
	  				'<span class="message__bubble" style="word-break:break-all;">' +
	  				message.data +
	  				'</span>' +
	  				'<span class="message__author">lady</span>'+
	  				'</div>' +
	  				'<div class="media-body">' +
	  				' </li>');
			$('#togglechat').scrollTop($('#togglechat')[0].scrollHeight);
			
		};
		
		// 서버로 메시지를 발송하는 함수
		// Send 버튼을 누르거나 텍스트 박스에서 엔터를 치면 실행
		function sendMessage() {
			// 텍스트 박스의 객체를 가져옴
			let message = document.getElementById("chatContent");
			// 콘솔에 메세지를 남긴다.
			messageTextArea.value += "(me) => " + message.value + "\n";
			
			$('#chatList').append('<li class="sent-message message">' +
					'<span id="checkdb" class="spinner-border text-muted spinner-border-sm" style="margin-top: 20px;"></span>'+
	  				'<div class="message__content">' +
	  				'<span class="message__bubble" style="word-break:break-all;">' +
	  				message.value +
	  				'</span>' +
	  				'</div>' +
	  				'<div class="media-body">' +
	  				' </li>');
			$('#togglechat').scrollTop($('#togglechat')[0].scrollHeight);
			
			var fromID = '<%= userID %>';
	  		var toID = '<%= toID %>';
	  		var chatContent = message.value;
	  		var changetext = '<span class="text-warning checkone" style="margin-top: 20px;">1</span>';
	  		$.ajax({
	  				type: "POST",
	  				url: "chatSubmit",
	  				data: {
	  					fromID: encodeURIComponent(fromID),
	  					toID: encodeURIComponent(toID),
	  					chatContent: encodeURIComponent(chatContent)
	  				}
		    }).done(function() {
		    	setTimeout(function() {
		    		$("#checkdb").replaceWith(changetext);
			  		
					webSocket.send(message.value);
					
					message.value = ""; // 텍스트 박스 추기화
					 
		    		}, 500);
		    }); // 실패 전송실패 버튼 만들기.
		}
		
		
		
		// 텍스트 박스에서 엔터를 누르면
		function enter() {
			// keyCode 13은 엔터이다.
			if (event.keyCode === 13) {
				// 서버로 메시지 전송
				sendMessage();
				// form에 의해 자동 submit을 막는다.
				return false;
			}
			return true;
		}
	</script>
	     
 </div>
  </body>
</html>