<!--#include file="../include/ModeRule.asp"-->
<!--#include file="../include/ModeCheckVB.asp"-->
<html>

<head>

<title>定义用户组</title>
</head>
<SCRIPT LANGUAGE=javascript>
<!--
window.name="main"
function window.onload()
{
	var sID=parent.parent.document.all['__USER_ROLE'].value
	//alert(sID)
	form1.innerHTML="<input type=hidden name='userid' value='"+sID+"'>"
	form1.submit()
	form1.target="bottom"
	form1.action="AuthGroupBtm.asp"; 
	form1.submit()
}
//-->
</SCRIPT>

<frameset rows="55%,*">
  <frame name="top" src="" marginwidth="0" marginheight="0" scrolling="auto" style="BORDER-RIGHT: 0px ;BORDER-LEFT: 0px;WIDTH: 100%;BORDER-BOTTOM: 0px;POSITION: relative;HEIGHT: 100%">
  <frame name="bottom" src="" marginwidth="0" marginheight="0" scrolling="auto">
  <noframes>
  <body >

  <p>此网页使用了框架，但您的浏览器不支持框架。</p>

  </body>
  </noframes>
</frameset>
<form action="AuthGroupTop.asp" method=post name=form1 target=top style='display:none'>
</form>
</html>
