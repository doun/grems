
<%
' border="1" width="100%" bordercolorlight="#AABBDD" bordercolordark="#CCDDFF" cellspacing="1" cellpadding="0" 
' <tr bgcolor="#CCDDFF">
dim strMousemove '���ڸ��������ƶ�
strMousemove="onmouseout=""this.bgColor='';"" onmouseover=""this.bgColor='#FFDDFF';"""

function hToday(mydate)
'��ͨ�ø�ʽ��ʾ����
	hToday=year(mydate)&"-"&month(mydate)&"-"&day(mydate)
end function

function mydate(getdate)
'-------------------------------------------------------------
'-------------������ת����2000-12-30���ַ�����ʽ--------------
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
'---------------�������˳������ڿͻ���ִ�к���-------------
'----------------------------------------------------------
sub RunAtClient(RunStr)
	Response.Write "<SCRIPT LANGUAGE=javascript>"&vbcrlf
	Response.Write RunStr &vbcrlf
	Response.Write "</SCRIPT>"&vbcrlf
end sub


'-------------------��ʽ����-------------------------------
'---------------Fill_Str����lengthλ����ո�---------------
'----------------------------------------------------------
function fill_to_string(Fill_Str,length)
	tempStr=""
	if length>len(Fill_Str) then
		tempStr=string(length-len(Fill_Str)," ") 
	end if
	fill_to_string=Fill_Str&tempStr
end function

'----------------------------------------------------------------------
'--------------   ����IE�汾�Ƿ���IE3�汾   ---------------------------
'----------------------------------------------------------------------
function checkIE()
	If InStr(Request.ServerVariables("HTTP_User_Agent"),"MSIE 3") <> 0 then
		checkIE="����IE�汾̫�ͣ��밲װIE4����߰汾��"
	    exit function
	end if
	checkIE=0
end function

'--------------------------------------------------------------------------------
'Strlen() ���Ļ��ִ�����
'--------------------------------------------------------------------------------
Public Function StrLen(tStr) 
    StrLen = LenB(StrConv(tStr, vbFromUnicode))
End Function

'---------------------------------------------------------------------------------
'StrSub () ȡһ���ִ� ��������ֱ�����
'---------------------------------------------------------------------------------
Public Function StrSub(tStr,Start,Leng) 
    If IsMissing(Leng) Then
       StrSub = StrConv(MidB(StrConv(tStr, vbFromUnicode), Start), vbUnicode)
    Else
       StrSub = StrConv(MidB(StrConv(tStr, vbFromUnicode), Start, Leng), vbUnicode)
    End If
End Function

'---------------------------------------------------------------------------------
'��ʾVBScript�е�MsgBox�Ի���
'strMess : ��ʾ��������ʾ��Ϣ����
'iButtons: ��ʾ��ʾ�İ�ť��������ť����,�����������:
'	0	:	vbOkOnly			:	ֻ��ʾ"OK"��ť��
'	1	:	vbOkCancel			:	��ʾ"OK"��"Cancel"��ť��
'	2	:	VbAbortRetryIgnore	:	��ʾ"����","����"��"����"��ť��
'	3	:	VbYesNoCancel		:	��ʾYes��No ��Cancel ��ť��
'	4	:	vbYesNo				:	��ʾYes��No��ť��
'	5	:	VbRetryCancel		:	��ʾ"Retry"��"Cancel"��ť��
'	16	:	VbCritical			:	��ʾCritical Message ͼ�ꡣ
'	32	:	VbQuestion			:	��ʾWarning Query  ͼ�ꡣ
'	48	:	VbExclamation		:	��ʾWarning Message ͼ�ꡣ
'	64	:	VbInformation		:	��ʾInformation Message ͼ�ꡣ
'strTitle : ��ʾ��ʾ�ڶԻ����ϵı���;
'����ֵ��������:
'	1	:	VbOk
'	2	:	VbCancel
'	3	:	VbAbort
'	4	:	VbRetry
'	5	:	VbIgnore
'	6	:	VbYes
'	7	:	VbNo

SUB message(Title,Content,ICO)
'---------------------------------------------------------------------------------
'--��;���ӷ���������ʾ�ͻ�����Ϣ����MESSAGE
'--ע�⣺Title ��ʾ��ʾ����ͷ��Content ��ʾ��ʾ������,Ico��ʾ��ʾ��ͼ��
'--���أ�
'---------------------------------------------------------------------------------
 Title=replace(Title,"""","��")
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
'---��;��ת����һ����ҳ 
'---������URL ��ʾ��ʾ����ͷ��Content ��ʾ��ʾ������,Ico��ʾ��ʾ��ͼ��------------
'--���أ�
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

'------------��ӡ��ǰ���ݿ������ж��Cell��������һ����---------------	
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


