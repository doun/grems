<!--#include file="../include/pm.asp"-->
<!--#include file="../include/ModeRule.asp"-->
<%setGrant(Request.Form("__USER_ROLE"),getMode())%>
<html xmlns:v="urn:schemas-microsoft-com:vml"
	  xmlns:o="urn:schemas-microsoft-com:office:office"
	  xmlns:Tools
	  xmlns:FormItem
>
<SCRIPT LANGUAGE=javascript>
<!--
function LoadList()
{
}
//-->
</SCRIPT>
<link type="text/css" rel="stylesheet" href="..\Library\Default.css">
<style>			
 	input {border:1px inset #4a4;height:17px;width:100%}
 	DIV { 	
		SCROLLBAR-FACE-COLOR: #4a4;
		SCROLLBAR-HIGHLIGHT-COLOR: white;            
		SCROLLBAR-SHADOW-COLOR: white;
		SCROLLBAR-3DLIGHT-COLOR: #4a4;
		SCROLLBAR-ARROW-COLOR: white;
		SCROLLBAR-TRACK-COLOR: #eef;    
		SCROLLBAR-DARKSHADOW-COLOR: #4a4;    
 	}
</style>
<script src="..\Library\default.js"></script>
<script src="..\Library\Shapes.js"></script>
<script language="javascript" src="..\Library\http.js"></script>
<script language="javascript" src="..\Library/FormInspector.js"></script>
<script>	
	LoadEvent("DoLoad()")	
	function DoLoad()
	{
		formatRegion()
		new WebLoader("wLoader")	
		new FormInputHandler("oForm")				
		document.body.action="submitParam.asp"
		oForm.formatForm(document.body)
	}
	function updateme(o)
	{
		o.blur()
		var o1=o.parentNode.parentNode.cells(2)		
		o1.action="submitParam.asp"
		var bReturn=oForm.PostForm(o1,checkData,funResult)
	}	
	function checkData(a,b,c)
	{
		return true
	}
	function funResult()
	{
		alert("数据已经被更新！")
	}
</script>
<body style="padding:5 10 10 5">	

	<Tools:region title="系统参数设定" style='width:100%;height:expression(document.body.clientHeight-15)' onaction="LoadList()">
	<DIV style='width:100%;height:100%;padding:10;overflow-y:auto'>
	<TABLE style='height:100%;background-color:white;'>
	<tr><td style='height:1'>
	<TABLE style='height:1;color:black' border borderColor="gold" id="paramData" CELLPADDING=0>
	<col width=1>
	<col width=50%>
	<col width=25%>
	<TR style='color:gold;background-color:#4a4'><TH><nobr>序号</nobr><TH>参数名称<TH>参数值<TH>单位<TH>&nbsp;</TH></TR>
	<%
		var str=""
		var cn=new Connection()
		var rs=cn.execRs("SELECT * FROM "+sDBOwner+".GREMS_PARAM ORDER BY IS_NUM,PARAM_NAME")
		var k=1
		while(!rs.EOF)
		{
			var _s=""+rs(0)
			var _s1=""+rs(3)
			var _s3=(""+rs(1)).split("≥")[0]
			var _s2="<input type='text' name='"+_s+"' name1='"+_s3+"' min=0 max=15E18 datatype='f' text='"+_s3+"' value='"+rs(2)+"' />"
			
			if(""+rs(4)=="0") {			
				_s1="&nbsp;"
				_s2=_s2.replace("'f'","'s'").replace("=0","=2")
			}	
			str+="<TR><TD align=center>"+k+"</TD><TD>"+rs(1)+"</TD><TD>"+_s2+"</TD><TD>&nbsp;&nbsp;"+_s1+"</TD><TD><INPUT style='border:1px solid gold;color:white;background-color:#4a4' value='更新' type='button' onclick='updateme(this)'></TD></TR>\n"
			++k
			rs.MoveNext()
		}
		Response.Write(str)
		Erase(cn)
		delete cn
		delete rs
	%>
	</TABLE>
	</td>
	</td></tr>
	<tr><td>&nbsp;</td></tr>
	</div>
	</Tools:region>
</body>