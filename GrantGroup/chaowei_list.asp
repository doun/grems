<%
'Response.Write Request.Form("userid")
'Response.End 
%>
<%Response.Expires=0%>
<html>
<style>
TABLE
{
    FONT-SIZE: 12px;
    WIDTH: 100%;
    BORDER-COLLAPSE: collapse
}
</style>
<head>
<!--#include file="check.asp"-->


	<meta http-equiv="Content-Type" content="text/html; charset=gb2312">

<!--#include file=function/function_pub.asp-->
<!--#include file=function/function_db.asp-->
<!--#include file=function/function_jsp.asp-->
<title>用户</title>
<script language=javascript>
var oOpener
function openWin(link){
	//alert(link);
	openStr=link;
	var sStyle="left=150,top=50,height=440,width=300,center=1,scroll=0,status=0,directories=0,channelmode=0"
	oOpener=FocusWin(oOpener,openStr,sStyle);
	return false;
}
</script>
</script>
<%
mdate=trim(Request.Form("date_y"))
if mdate<>"" then
	mdate=mdate&"-01-01"
else
	mdate=date()
end if
mindate=year(mdate)&"-01-01"
mindate=dateadd("d",-1,mindate)
maxdate=year(mdate)&"-12-31"
ymdate=year(mdate)
'Response.Write mindate
sql="select tide_id,tide_pic_path,tide_date from "&Application("DBOwner")&".GREMS_TIDE  where tide_date > to_date('"&mindate&"','yyyy-mm-dd') and tide_date < to_date('"&maxdate&"','yyyy-mm-dd') order by tide_date asc"
set conn=server.createobject("adodb.connection")
conn.open Application("GREMS_ConnectionString")
set rs=server.CreateObject("adodb.recordset")
rs.Open sql,conn,1,1
if not rs.EOF then
	chaoweiArray=rs.GetRows
	chaoweiRows=ubound(chaoweiArray,2)
else
	chaoweiRows=-1
end if
'Response.Write chaoweiRows
%>

</head>
<script language=javascript>
function selectType(sMod){
	document.userForm.action="userAdd.asp";
	document.userForm.selectMod.value=sMod;   
	document.userForm.submit();  
}

function submitform(sMod){
	 if(sMod=="Dell"){
	var dellinfo=document.userForm.del_info.value;
		if(dellinfo==""){
			alert("请选择要删除的潮位表!");
			return false;
		}
		else{
			var re=/check/g;
			dellinfo=dellinfo.replace(re,"")   
			dellinfo=dellinfo.substring(0,dellinfo.length-1)
			var th=confirm("是否要删除用户\n"+dellinfo+"")
			if(th){
				document.userForm.action="User_function.asp";
				document.userForm.selectMod.value=sMod;
				document.userForm.submit();
				}
			else{
				return false;
				}
		}
	}
	else
	{
		document.userForm.action="User_function.asp";
		document.userForm.selectMod.value=sMod;
		document.userForm.submit();
	}     
}

function user_info(obj){
	var info=document.userForm.del_info.value;
	obj=obj+","
	if(info.indexOf(obj)==-1){
		info=info+obj;
	}
	else{
		var nameL=obj.length+1
		var sL=info.indexOf(obj);
		var L=info.length;
		var Ninfo=info.substring(0,sL)+info.substring(sL+nameL-1,L);
		//alert(Ninfo);
		info=Ninfo;
	}
	document.userForm.del_info.value=info;  
}


function openWin(sUrl)
	{
		var sHeight=window.screen.availHeight-100
		var sWidth=window.screen.availWidth-100
		window.open(sUrl,"chaowei","height="+sHeight+",width="+sWidth+",left=50,top=50,location=0,scrollbars=1")
	}
	
function submitpage(){
	if(document.userForm.date_y.value!="0"){
		document.userForm.submit();   
	}
}


function CheckAll(form)  {
  for (var i=0;i<form.elements.length;i++)    {
    var e = form.elements[i];
    if (e.name != 'chkall')       e.checked = form.chkall.checked; 
   }
  }
  
function delall(){

	if(confirm('确定删除选定的纪录吗?')){
		document.userForm.action="chaowei_del.asp" 
		document.userForm.submit();  
		return true;
		}
	else{
	return false;}
}

</script>

<body>
<form name=userForm method=post>
<input type=hidden name=selectMod>
<table border="0" width="100%" >
  <tr><td align=right>
  <input type=checkbox name=chkall value=on onclick="CheckAll(this.form)">全选
  <input type=button value="删除 >>"  name="Delleach" onclick='javascript:return delall()' style='CURSOR: hand;' LANGUAGE="javascript" style="border:2px solid #393;background-color:white;color:#393;font-size:13px;height:20px;font-weight:bold">
  </td></tr>
   <tr >
          <td bgcolor="#339933" 　colspan=6>
          <table border=0>
          <tr><td height=20 width=150>
          &nbsp;
          <font color=yellow><%=ymdate%>年度&nbsp;潮位表</font>
          </td>
          <td>
          <select name=date_y onchange="return submitpage()">
          <option value=0>请选择年度</option>
          <%for i=2003 to year(date())+1%>
          <option value=<%=i%>><%=i%>年</option>
          <%next%>
          </select>
          </td></tr>
          </table>
          </td>
        </tr>
  <tr>
    <td width="33%" colspan="2">
    <fieldset id="fs_sysgroup" name="fs_sysgroup">
	<legend><img SRC="../images/collection.gif" WIDTH="16"> 潮位表</legend>
      <table name="TB_for_Write" ID="TB_for_Write" border="0" width="100%" bordercolorlight="#444444" bordercolordark="#339933">
     
      <tr><td height=10></td></tr>
      <%if chaoweiRows<>-1 then
         for i=0 to chaoweiRows
           if i mod 3 =0 then%>
          </tr><tr>
           <%end if%>
      <td align=center>
      <table border=0><tr><td align=center>
      <a href="javascript:openWin('../Statistic/chaowei_info.asp?id=<%=chaoweiArray(0,i)%>');"><img src='../Statistic/Tide_Pic/<%=chaoweiArray(1,i)%>' width=80  height=80   style="BORDER:1px solid #3c3;color:black;"></a>
      </td></tr>
      <tr><td align=center>
      <%=year(chaoweiArray(2,i))%>年<%=month(chaoweiArray(2,i))%>月
      </td></tr>
      <tr><td align=center><input type=checkbox name=checkbox style="BORDER:0px solid #3c3;color:black;" value="<%=chaoweiArray(0,i)%>"></td></tr>
      <tr><td height=10></td></tr>
      </table>
      </td>
      <% next
      else%>
      <tr><td height=10></td></tr>
      <tr><td height=30 align=center>没有任何&nbsp;<font color=red><%=ymdate%></font>年度&nbsp;潮位表信息,如要查询&nbsp;<%=ymdate%>年度&nbsp;潮位表，请与管理员联系．</td></tr>
      <tr><td height=30></td></tr>
      <%
        end if%>
      </table>
     
      
    </td>
  </tr>
  
</table>
</form>
<script language=javascript>
function tidesubmit(){

	if(document.tideform.date_y.value==0){
		alert("请选择潮位表年份")
		document.tideform.date_y.focus();
		return false;   
	}
	if(document.tideform.date_m.value==0){
		alert("请选择潮位表月份")
		document.tideform.date_m.focus();
		return false;   
	}
	
	var filename=document.tideform.filetide.value;
	if(filename==""){
		alert("请选择潮位表图片")
		document.tideform.filetide.focus();
		return false;
		}
	else{
		filename=filename.toLowerCase();
		if(filename.indexOf("'")==-1){
	   		var lenfile=filename.length-3;
			var lastfile=filename.substr(lenfile,3);
			//alert(lastfile)
			if(lastfile!="jpg" && lastfile!="gif"){
				alert("请选择正确的潮位表图片格式");
				document.tideform.filetide.focus();
				return false;   
				}
			}
		else{
			alert("潮位表名称中不能含有单引号");
			document.tideform.filetide.focus();
			return false;   
			}
		}
	document.tideform.method="post";
	document.tideform.action="chaowei_up.asp"
}
</script>
<STYLE>
	select{BORDER:1px solid #3c3;color:white;background-color:#393}
	INPUT {BORDER:1px solid #3c3;color:black;}
</STYLE>
 <fieldset id="fs_sysgroup1" name="fs_sysgroup1">
      <form name=tideform id=tideform  enctype="multipart/form-data" onsubmit="return tidesubmit()">
      <table  border="0" width="100%" bordercolorlight="#444444" bordercolordark="#339933">
        <tr >
          <td bgcolor="#339933" height=20　>&nbsp;<font color=yellow>增加潮位表</font>&nbsp;&nbsp;&nbsp;&nbsp;<font color=white>图片格式：*.gif&nbsp;*.jpg</td>
        </td>
        <tr >
          <td  height=20>
          <table border=0>
          <td width=50>
          &nbsp;
          时间：</td>
          <td width=180>
          <select name=date_y>
          <option value=0>请选择</option>
          <%for i=year(date()) to year(date())+1%>
          <option value=<%=i%>><%=i%>年</option>
          <%next%>
          </select>
          <select name=date_m>
          <option value=0>请选择</option>
          <%for i=1 to 12%>
          <option value=<%=i%>><%=i%>月</option>
          <%next%>
          </select>
          </td>
          <td width=75>
           潮位表图片：</td>
          <td width=260>
          <input type=file name="filetide">
          </td>
          <td>
          <input type=submit name=submittide value="上传潮位表">
          </td>
          </tr>
          </table>
        </td></form>
        </tr>
       </table>
</body>

</html>
