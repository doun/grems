
<%
' border="1" width="100%" bordercolorlight="#AABBDD" bordercolordark="#CCDDFF" cellspacing="1" cellpadding="0" 
' <tr bgcolor="#CCDDFF">
dim strMousemove '用于跟踪鼠标的移动
strMousemove="onmouseout=""this.bgColor='';"" onmouseover=""this.bgColor='#FFDDFF';"""

function hToday(mydate)
'用通用格式显示日期
	hToday=year(mydate)&"-"&month(mydate)&"-"&day(mydate)
end function

function mydate(getdate)
'-------------------------------------------------------------
'-------------将日期转换成2000-12-30的字符串形式--------------
'-------------------------------------------------------------
	tempStr=cstr(year(getdate))&"-"
	mymonth=cstr(month(getdate))
	if len(mymonth)=1 then mymonth="0"&mymonth
	tempStr=tempStr&mymonth&"-"
	myday=cstr(day(getdate))
	if len(myday)=1 then myday="0"&myday
	tempStr=tempStr&myday
	mydate=tempStr
end function

'----------------------------------------------------------
'---------------服务器端程序用于客户端执行函数-------------
'----------------------------------------------------------
sub RunAtClient(RunStr)
	Response.Write "<SCRIPT LANGUAGE=javascript>"&vbcrlf
	Response.Write RunStr &vbcrlf
	Response.Write "</SCRIPT>"&vbcrlf
end sub


'-------------------格式调整-------------------------------
'---------------Fill_Str不满length位补充空格---------------
'----------------------------------------------------------
function fill_to_string(Fill_Str,length)
	tempStr=""
	if length>len(Fill_Str) then
		tempStr=string(length-len(Fill_Str)," ") 
	end if
	fill_to_string=Fill_Str&tempStr
end function

'----------------------------------------------------------------------
'--------------   测试IE版本是否是IE3版本   ---------------------------
'----------------------------------------------------------------------
function checkIE()
	If InStr(Request.ServerVariables("HTTP_User_Agent"),"MSIE 3") <> 0 then
		checkIE="您的IE版本太低，请安装IE4或更高版本！"
	    exit function
	end if
	checkIE=0
end function

'--------------------------------------------------------------------------------
'Strlen() 中文化字串长度
'--------------------------------------------------------------------------------
Public Function StrLen(tStr) 
    StrLen = LenB(StrConv(tStr, vbFromUnicode))
End Function

'---------------------------------------------------------------------------------
'StrSub () 取一段字串 半个中文字被忽略
'---------------------------------------------------------------------------------
Public Function StrSub(tStr,Start,Leng) 
    If IsMissing(Leng) Then
       StrSub = StrConv(MidB(StrConv(tStr, vbFromUnicode), Start), vbUnicode)
    Else
       StrSub = StrConv(MidB(StrConv(tStr, vbFromUnicode), Start, Leng), vbUnicode)
    End If
End Function

'---------------------------------------------------------------------------------
'显示VBScript中的MsgBox对话框
'strMess : 表示给出的提示信息内容
'iButtons: 表示显示的按钮数量及按钮类型,具体参数如下:
'	0	:	vbOkOnly			:	只显示"OK"按钮。
'	1	:	vbOkCancel			:	显示"OK"及"Cancel"按钮。
'	2	:	VbAbortRetryIgnore	:	显示"放弃","重试"及"忽略"按钮。
'	3	:	VbYesNoCancel		:	显示Yes、No 及Cancel 按钮。
'	4	:	vbYesNo				:	显示Yes、No按钮。
'	5	:	VbRetryCancel		:	显示"Retry"及"Cancel"按钮。
'	16	:	VbCritical			:	显示Critical Message 图标。
'	32	:	VbQuestion			:	显示Warning Query  图标。
'	48	:	VbExclamation		:	显示Warning Message 图标。
'	64	:	VbInformation		:	显示Information Message 图标。
'strTitle : 表示显示在对话框上的标提;
'返回值具体如下:
'	1	:	VbOk
'	2	:	VbCancel
'	3	:	VbAbort
'	4	:	VbRetry
'	5	:	VbIgnore
'	6	:	VbYes
'	7	:	VbNo

SUB message(Title,Content,ICO)
'---------------------------------------------------------------------------------
'--用途：从服务器端显示客户端信息函数MESSAGE
'--注意：Title 表示显示的题头，Content 表示显示的内容,Ico表示显示的图标
'--返回：
'---------------------------------------------------------------------------------
 Title=replace(Title,"""","”")
 Response.Write "<SCRIPT LANGUAGE=vbscript>"  
 IF ICO=0 then
  Response.Write " MsgBox "& chr(34) & content & chr(34) &", 64,"&chr(34) & title & chr(34) 
 else 
  Response.Write " MsgBox "& chr(34) & content & chr(34) &", 65,"&chr(34) & title & chr(34) 
 end if
 Response.Write " </SCRIPT>"
end Sub

sub GotoPage(URL)
'---------------------------------------------------------------------------------
'---用途：转到另一个网页 
'---参数：URL 表示显示的题头，Content 表示显示的内容,Ico表示显示的图标------------
'--返回：
'---------------------------------------------------------------------------------
Response.Write "<SCRIPT LANGUAGE=vbscript>"
if IsNumeric(URL) then
   Response.Write "history.go " & URL 
   
else
   IF Ucase(URL)="HOMEPAGE" THEN 
   Response.Write "parent.location.replace " &chr(34)& "ams.ASP"& chr(34) 
   else
   Response.Write "location.replace " &chr(34)& cstr(URL)& chr(34) 
   END IF
end if

Response.Write "</SCRIPT>"
end sub	

'------------打印当前数据库表项（含有多个Cell）到表格的一行中---------------	
	sub Print_DB_to_table(TBName)
	    Response.Write "<SCRIPT LANGUAGE=javascript>"
        for CountI=0 to Session("OraAMSRs").RecordCount-1
			Response.Write "var NewRow,iRowLen;"&vbcrlf
			Response.Write "iRowLen="&TBName&".rows.length;"&vbcrlf
			Response.Write "NewRow="&TBName&".insertRow(); "&vbcrlf
			for CountField=0 to Session("OraAMSRs").Fields.Count-1
			   	Response.Write "NewRow.insertCell();"&vbcrlf
		   	    Response.Write TBName&".rows(iRowLen).cells(0).innerHTML ="&chr(34)&Session("OraAMSRs").fields("CountField")&chr(34)&";"&vbcrlf
			next
			session("OraAMSRs").moveNext	
	    Next
	    Response.Write "</SCRIPT>"
	  
	end sub 

%>


