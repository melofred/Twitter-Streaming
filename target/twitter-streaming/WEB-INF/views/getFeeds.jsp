<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page session="false" %>
 
   <html>
   		<head>
         <title>Loading twitter content using Spring Insight</title>
        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
        <style type="text/css">
   
 
            body{
                font-family:Arial;
                font-size:.93em;
            }
            #content-box{
                background-color:#FAFAFA;
                border:2px solid #888;
                height:200px;
                overflow:scroll;
                padding:4px;
                width:800px;
            }
            #content-box p{
                border:1px solid #EEE;
                background-color:#F0F0F0;
                padding:3px;
            }
            #content-box p span{
                color:#00F;
                display:block;
                font:bold 21px Arial;
                float:left;
                margin-right:10px;
            }
		</style>
        <script type="text/javascript">
        $(document).ready(function(){
        	
            $contentLoadTriggered = false;
            
            var getTweets = function() { 
            	$.get("searchTwitter", function(data){
	                $("#content-wrapper").prepend(data);
      	            $contentLoadTriggered = false;
	            });       	
            	
            };          
            
            $(document).bind("ajaxComplete", function(){
            	setTimeout(getTweets, 1000);
            });
            
            $( document ).ready(function(){
                  $.get("searchTwitter", function(data){
 	                $("#content-wrapper").prepend(data);
       	            $contentLoadTriggered = false;
                  });
      
            });
            $( "#tweetBtn" ).click(function() {
                $.get("tweet", { tweet: $("#tweetMsg").val() }, function(data){
                	$( "#span" ).text( "Tweet sent!" ).show().fadeOut( 3000 );
                	$("#tweetMsg").val="";
                });
            	
            });
            
  /*          
            $("#content-box").scroll(function(){
                if($("#content-box").scrollTop() >= ($("#content-wrapper").height() - $("#content-box").height()) && $contentLoadTriggered == false)
                {
                    $contentLoadTriggered = true;
                    $.get("searchTwitter", function(data){
                        $("#content-wrapper").prepend(data);
                        $contentLoadTriggered = false;
                    });
                }

            });
  */
        });
    
        /*
         $("#content-wrapper").ready(function(){
            $contentLoadTriggered = true;
        	$.get("searchTwitter", function(data){
                $("#content-wrapper").append(data);
                $contentLoadTriggered = false;
            });       	
        });
            $(document).ready(function(){
                $contentLoadTriggered = false;
                $("#content-box").scroll(function(){
                    if($("#content-box").scrollTop() >= ($("#content-wrapper").height() - $("#content-box").height()) && $contentLoadTriggered == false)
                    {
                        $contentLoadTriggered = true;
                        $.getJSON("/searchTwitter", function(data){
                            $("#content-wrapper").append(data);
                            $contentLoadTriggered = false;
                        });
                    }

                });
            });
*/
            </script>
          </head>
<body>
        Demo page: Showing #CloudFoundry tweet feeds (or whatever you put into the RabbitMQ queue)

		<br><br>
        <small>Instance hosted at server &nbsp;<%=request.getLocalAddr() %>:<%=request.getLocalPort() %></small>
        <br>
        <small><b>Using service RabbitMQ at the URI:</b>&nbsp;<c:out value="${rabbitURI}"/> </small>
		<br>
		<!-- 
		<c:choose>
			<c:when test="${dbURL}">
				<small><b>Tweets being persisted at the DB using URL:</b>&nbsp;<c:out value="${dbURL}"/> </small>				
			</c:when>
			<c:otherwise>
				<small><b>No database service bound</b> </small>	
			</c:otherwise>
		</c:choose>
		<br>
		 -->
  		<p><span>Tweets showing up on the content box below</span></p>
        <div id="content-box">
            <div id="content-wrapper">
            	<p> --------------------------------</p>
            	<p> Tweets will appear here </p>
            	<p> --------------------------------</p>
            </div>
        </div>        
        <br><br>
     	<h3>Publish a #CloudFoundry message</h3>
		<form id="tweetForm">
		  Message to submit
		  <input type="text" id="tweetMsg" maxlength="144">
		  <div id="tweetBtn"><input type="button" value="Tweet!"></div>
		</form>
		<span id="warning"><small>Remember: Twitter doesn't allow the same tweet to be sent more than once</small></span>
		<span id="span"></span>
		<br>
	</body>

   </html>