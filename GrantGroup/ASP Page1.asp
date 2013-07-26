<!-- #include file="../Library/uploadx.asp" -->
<%
sub checkValues(obj)
	if obj="" or isnull(obj) then
		Response.Write "<script language=javascript>"
		Response.Write "alert('请按要求填写数据');"
		Response.Write "window.history.go(-1);"
		Response.Write "</script>"
		Response.End 
	end if
end sub


sub go_back(str)
		Response.Write "<script language=javascript>"
		Response.Write "alert('"+str+"');"
		Response.Write "window.history.go(-1);"
		Response.Write "</script>"
		Response.End 
end sub

function HTMLFormat(sInput)
dim sAns
sAns = replace(sInput,"'","")
HTMLFormat = sAns
end function

date_y=HTMLFormat(trim(GetFormVal("date_y")))
date_m=HTMLFormat(trim(GetFormVal("date_m")))
Update=date_y&"-"&right("00"&date_m,2)&"-01"

sql="select * from "&Application("DBOwner")&".GREMS_TIDE where "&Application("DBOwner")&".GREMS_TIDE.TIDE_DATE = to_date('"&Update&"','yyyy-mm-dd')"
set rs=server.CreateObject("adodb.recordset")
set conn=server.createobject("adodb.connection")
conn.open Application("GREMS_ConnectionString")
rs.Open sql,conn,1,3
if not rs.EOF then
	errorinfor="0"
else
	errorinfor="1"
end if
rs.Close
set rs=nothing
conn.close
set conn=nothing

if errorinfor="0" then
	call go_back(""&date_y&"年"&date_m&"月的潮位表已存在,请删除后再上传!")
end if
	
'Response.Write sql
'Response.End 

path = Server.MapPath("../Statistic/Tide_Pic")
filename = SaveFile("filetide",path,100,1)
If filename <> "*TooBig*" Then
	filepath=filename
Else
	call go_back("潮位表超出2k,请修改后在上传")
End IF

if filepath="" then
	call go_back("请选择潮位表图片")
end if

sql="select tide_id from  "&Application("DBOwner")&".GREMS_TIDE order by tide_id desc"
set conn1=server.createobject("adodb.connection")
conn1.open Application("GREMS_ConnectionString")
set rscount=conn1.Execute(sql) 
if rscount.eof then
	tide_id=0
else
	tide_id=cint(rscount(0))+1
end if
rscount.close
set rscount=nothing
sql="insert into "&Application("DBOwner")&".GREMS_TIDE (tide_id,tide_pic_path,tide_date) values ("&tide_id&",'"&filepath&"',to_date('"&Update&"','yyyy-mm-dd'))"
conn1.Execute(sql)
if conn1.Errors<>0 then
	conn1.close
	set conn1=nothing
	call go_back("数据库操作错误")
end if  
conn1.close
set conn1=nothing
Response.Redirect "chaowei_list.asp"
%>
