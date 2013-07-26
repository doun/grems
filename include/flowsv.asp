<!--#include file="../include/pm.asp"-->
<!--#include file="../include/ConstParser.asp"-->
<!--#include file="../include/ModeRule.asp"-->
<%
	setReferer("Public/HandlePage.asp||Apply/DoApply.asp")
	var owner=" "+sDBOwner+".GREMS_"
	var cn=new Connection,rp=new requestParser()
	var sID=rp.parse("[排放单号:s]")
	var sUID=rp.parse("[__USER_ROLE:x]")
	eval(""+Application("PARAM_INFO"))
	//检查权限
	testGrant(sUID,1)
	var sType=rp.parse("[排放类型:x]")
	var sCurrentStatus=rp.parse("[状态:x]")
	var sFolder=/([^\/]*\/)[^\/]*$/.exec(Request.ServerVariables("SCRIPT_NAME"))[1]
	rSpecial1=rp.parse("[SPECIAL_REASON:x]")
	var rSpecial=",SPECIAL_REASON='"+rSpecial1+"'"
	var iSpecial=rp.parse("[IS_SPECIAL:x]")
	sFolder=sFolder.substring(0,3).toUpperCase()
	var sSelectColumn="ISSPECIAL_"
	switch(sFolder)
	{
		case "APP":sSelectColumn+="APP";break
		case "SAM":sSelectColumn+="SAM";break
		case "ANA":sSelectColumn+="SCL";break
		case "CON":sSelectColumn+="CFM";break
		default:sSelectColumn=null
		
	}
	function setUser(sCol)
	{		
		cn.Execute("UPDATE"+owner+"EXECUTER SET "+sCol+"="+rp.parse("[__USER_ID:s]")+" WHERE ID="+sID)
	}
	function rStatus(sStatus,sSpec)
	{
		sSpec=sSpec==null?-1:parseInt(sSpec)
		var sql="UPDATE "+owner+"STATUS SET CURRENT_STATUS='"+sStatus+"'"
		if(!isNaN(sSpec)&&sSpec>=0&&sSelectColumn!=null) 
			sql+=","+sSelectColumn+"="+sSpec
		sql+=" WHERE CURRENT_STATUS='"+sCurrentStatus+"' AND ID="+sID	
		cn.Execute(sql)
	}
	function over(str)
	{
		Erase(cn)
		Erase(rp)
		delete cn
		delete rp
		delete oCP
		delete rs
		message(str==null?"OK!":str)
	}
%>