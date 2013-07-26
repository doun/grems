<SCRIPT LANGUAGE=JAVASCRIPT RUNAT=SERVER>
var userid;
userid=Request.form("userid")
//response.write(userid)
var Mode=getMode()
/*
function checkGrant(sID,sMode)
	{
		if(sID==null||sID==""||(""+sID).substring(0,1)!="P") return false
		return (""+Application("USER_GRANT")).match(eval("/[:,]"+sMode+",[^:]*"+sID+"/"))!=null
	}*/
function checkGrant(sRoleGroup,sMode)
	{
		//clear(Application("USER_GRANT"))
		if(sRoleGroup==null||sRoleGroup=="") return false
		if(sMode==null||sMode=="") return true
		var sPre="[^;]*[\\:,]"+sMode
		sRoleGroup="/("+(""+sRoleGroup).replace(/(^[\s,]+|[\s,]+$)/g,"").split(",").join("|")+")"+sPre+"/"
		return eval(sRoleGroup).test(Application("USER_GRANT"))
	}	
//response.write(getMode())
//Response.Write(checkGrant(userid,Mode))

if(checkGrant(userid,Mode)==false){
	Response.Redirect("../public/message.asp")
}
</SCRIPT>
