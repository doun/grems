<%
'---�������ݿ�
sub conn_open(sql)
	set conn=server.createobject("adodb.connection")
    conn.open Application("GREMS_ConnectionString")
    if err.number<>0 then 
        err.clear
        conn.close
        set conn=nothing
	    response.write "�������ݿ����!"
        Response.End 
    end if
    conn.execute(sql)
	if err.number<>0 then
	conn.close
    set conn=nothing
		str="��ʾ�����ݿ���ִ��� "
		call gopage1(str,"right.asp")
	end if
	conn.close
    set conn=nothing
end sub




'------��ѯ��¼��ת��Ϊ��ά����
Sub dbQuery(sql,sqlcount,myArray,myRows) 

	
	set conn=server.createobject("adodb.connection")
    conn.open Application("GREMS_ConnectionString")
    if err.number<>0 then 
        err.clear
        conn.close
        set conn=nothing
	    response.write "�������ݿ����!"
        Response.End 
    end if
    
    set rs=server.CreateObject("adodb.recordset")
	rs.Open sql,conn,1,1
	if not rs.EOF then
		myArray	=rs.GetRows()
		set Rs1=server.CreateObject("adodb.recordset")
		Rs1.Open sqlcount,conn,1,1
		myRows	=cint(Rs1.Fields(0))-1
		Rs1.Close 
		set Rs1=nothing
	else
		myRows=-1
	end if
	if err.number<>0 then 
        err.clear
        conn.close
        set conn=nothing
	    response.write "��ѯ��¼������!"
        Response.End 
    end if
	rs.Close
	set rs=nothing
	
	 conn.close
     set conn=nothing
End Sub



'------��JAVASCRIPT��ʾ
sub gopage(str,page)
	Response.Write "<script language=javascript>"
	Response.Write "alert('"&str&"');"
	if page="0" then
		Response.Write "window.history.go(-1);"
	else
		Response.Write "top.window.location.href='"&page&"'"
	end if
	Response.Write "</script>"
	Response.End 	
end sub


sub gopage1(str,page)
	Response.Write "<script language=javascript>"
	Response.Write "alert('"&str&"');"
	if page="0" then
		Response.Write "window.close();"
	else
		Response.Write "window.location.href='"&page&"'"
	end if
	Response.Write "</script>"
	Response.End 	
end sub


sub checksession()
	if session("userinfo")="" or isnull(session("userinfo")) then
		str="��ʾ����û�е�¼��ϵͳ\n\n���������뿪ʱ��̫��,�������µ�¼	"
		call gopage(str,"index.asp")
	end if
end sub

sub checksession1()
	if session("userinfo")="" or isnull(session("userinfo")) then
		str="��ʾ����û�е�¼��ϵͳ\n\n���������뿪ʱ��̫��,�������µ�¼	"
		call gopage1(str,0)
	end if
end sub
%>

<script language=javascript>
function FocusWin(oOpener,openStr,sStyle){
//------------------------------------------------------------------
//---���ܣ����ڻ�ȡ�Ѿ��򿪴��ڵĽ���-------------------------------
//---������oOpener��ʾ�򿪴��ڵľ��,openStr:�򿪵��ַ���-----------
//---�÷���

	try{	
		if (oOpener != null){
			oOpener.focus();
	     }else{
		    oOpener=window.open(openStr,"s",sStyle);
	    	oOpener.focus();
	    }
	 }catch(exceptionl){
		oOpener=window.open(openStr,"s",sStyle);
	 }
	return oOpener
	 }
	 
var oOpener
function Btn_Add_onclick(href,h,w) {
    openStr=href
    var sStyle="left=100,top=50,height="+h+",width="+w+",scrollbars=yes";
	oOpener=FocusWin(oOpener,openStr,sStyle);
	return false;	
}
</script>
