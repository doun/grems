<%@language=JScript ENABLESESSIONSTATE = False CodePage=936%>
<script language=vbscript runat=server>
	function  ExecSql(byref cnx,byref sqlx)
		dim iAffected
		cnx.Execute sqlx,iAffected,129
		ExecSql=iAffected
	end function

</script>
<%	
	Response.Expires=-1
	Response.CharSet="GB2312"
	//数据操作
	function Connection(SourceName) 
	{
		if(SourceName==null) SourceName="GREMS"
		var sSource=Application(SourceName+"_ConnectionString")
		if(sSource==null) clear("没有找到指定的数据源！")		
		this._cn=Server.CreateObject("ADODB.Connection")
		this._cn.CursorLocation=2
		try {this._cn.Open(sSource)}
		catch(Exception) {}
		this._bTransFlag=false
		this.test()
	}
	Connection.prototype.getCn=function() 
	{
		return this._cn
	}	
	Connection.prototype.getRs=function() 
	{
		var rs=Server.CreateObject("ADODB.Recordset")
		rs.CursorLocation=2
		rs.LockType=1
		rs.CursorType=1
		rs.ActiveConnection=this._cn		
		return rs
	}
	
	Connection.prototype.Execute=function(sql,iFlag)
	{
		var iAffect=1	
		if(iFlag==null) iFlag=1
		this._tmpSql=sql
		try {iAffect=parseInt(ExecSql(this._cn,sql))}
		catch(Exception) {this.test()}
		if(iFlag!=-1&&this._bTransFlag==true) {
			if(iAffect==0) {
				if(this._bTransFlag) this._cn.RollbackTrans()
				warn("该分析排放单已经被更新，您不能执行该操作！\n")				
			}	
			else if(iFlag!=-2&&iAffect!=iFlag)
			{
				if(this._bTransFlag) this._cn.RollbackTrans()
				warn("发现错误！\n原因：更新的记录数("+iAffect+")不匹配指定的数值("+iFlag+")！\n"
					+"\n请您联系网站管理员！"
				)
			}
		}
		return iAffect
	}
	
	Connection.prototype.execRs=function(sql)
	{
		this._tmpSql=sql
		var rs = this.getRs()		
		try {rs.Open(sql)}
		catch(Exception) {this.test()}
		return rs
	}
	Connection.prototype.begin=function()
	{
		this._bTransFlag=true
		this._cn.BeginTrans()		
	}
	Connection.prototype.test=function()
	{
		if(this._cn.Errors.Count!=0)
		{
			if(this._bTransFlag==true) {
				this._bTransFlag=false
				this._cn.RollbackTrans()
			}	
			var str="\n"
			for(var i=0;i<this._cn.Errors.Count;i++)
			{
				var oE=this._cn.Errors.item(i)
				str+="\nError:"+oE.Description
					+"\nSQL:"+this._tmpSql
					+"\nSource:"+oE.Source
					+"\nSQLState:"+oE.SQLState
					+"\nNativeError:"+oE.NativeError+"\n\n"					
			}
			warn(str)
		}		
	}
	Connection.prototype.end=function()
	{
		this._bTransFlag=false
		this._cn.CommitTrans()		
	}
	Connection.prototype.onTerminate=function()
	{
		delete this._cn
		this._cn=null
	}
	var sDBOwner=""+Application("DBOwner")
	var SvVars=Request.ServerVariables
	//设置工程所在的web路径(eg:http://lwserver0/grems/)
	if(Application("GlobalPath")==null )
	{	
		var GlobalPath = ("http://" + SvVars("SERVER_NAME") + SvVars("SCRIPT_NAME")).replace(/\w*\/\w*\.\w*$/,"").toLowerCase()
		Application("GlobalPath")=GlobalPath
	}
	var referer=(""+SvVars("HTTP_REFERER")).toLowerCase()
	SvVars=null
	var rootPath=Application("GlobalPath")	
	//检查数据请求页是否来自本站
	if(referer.indexOf(rootPath)!=0) clear("对不起，您没有执行本页的权限。",true)	
	//指定合法的数据请求页
	function setReferer(path)
	{
		var aPath=path.split("||")
		var bAllow=false
		for(var i=0;i<aPath.length;i++)
		{
			var defPath=rootPath+aPath[i].toLowerCase()	
			if(referer.indexOf(defPath)==0) bAllow=true
		}	
		if(!bAllow) clear("对不起，您没有执行本页的权限。",true)
	}	
	//
	function setGrant(sRoleGroup,sMode,iFlag)
	{
		if(!checkGrant(sRoleGroup,sMode))
		{
			if(iFlag!=null) clear("对不起，您没有执行本操作的权限！",true)
			else showErr("对不起，您没有执行本操作的权限")			
		}
	}
	function checkGrant(sRoleGroup,sMode)
	{
		//clear(Application("USER_GRANT"))
		if(sRoleGroup==null||sRoleGroup=="") return false
		if(sMode==null||sMode=="") return true
		var sPre="[^;]*[\\:,]"+sMode
		sRoleGroup="/("+(""+sRoleGroup).replace(/(^[\s,]+|[\s,]+$)/g,"").split(",").join("|")+")"+sPre+"/"
		return eval(sRoleGroup).test(Application("USER_GRANT"))
	}
	//返回一个错误
	function clear(sInfo,bFlag)
	{
		Response.Clear()
		if(sInfo!=null)
		{
			var str="<ERROR"
			if(bFlag==true) str+=" redirect='t'"
			str+=">"
			str+=sInfo+"</ERROR>"
			Response.Write(str)
		}	
		Response.End()
	}
	//数据提交成功
	function message(s)
	{
		Response.Clear()
		Response.Write("<MESSAGE>"+s+"</MESSAGE>")
		Response.End()
	}
	function warn(s)
	{
		Response.Clear()
		Response.Write("<WARN>"+s+"</WARN>")
		Response.End()
	}
	//返回一个xmldom
	function getDom()
	{
		var doc=Server.CreateObject("MSXML2.DOMDocument")
		doc.async=false
		return doc
	}
	//检查xmldom是否出现错误
	function CheckDom(oDoc)
	{
		var myErr=oDoc.parseError
		if(myErr.errorCode!=0)
		{
			var str=myErr.reason
			myErr=null
			clear(str)
		}
		myErr=null
	}
	//释放对象
	function Erase(o,bFlag)
	{
		if(typeof(o.onTerminate)=="function") o.onTerminate()
		if(bFlag!=false)
		{
			for(var i in o)
			{
				if(typeof(o[i])=="object") delete o[i]
			}
		}
		delete o
	}
	//格式化日期
	Date.prototype.getString=function()
	{
		return  ""+this.getFullYear()+"-"+(this.getMonth()+1)+"-"+this.getDate()
				+" "+this.getHours()+":"+this.getMinutes()+":"+this.getSeconds()
	}
	//数据转换对象
	function requestParser(bFlag)
	{		
		this.defaultGate="DATA"
		this.oDoc=getDom()
		if(bFlag==true)
		{
			var oRoot=this.oDoc.createElement("DATA")
			var oForm=Request.Form
			var iCount=oForm.Count
			for(var i=1;i<=iCount;i++)
			{
				var e=this.oDoc.createElement(oForm.Key(i))
				e.text=oForm.Item(i)
				oRoot.appendChild(e)			
			}
			var oForm=Request.QueryString
			var iCount=oForm.Count
			for(var i=1;i<=iCount;i++)
			{
				var e=this.oDoc.createElement(oForm.Key(i))
				e.text=oForm.Item(i)
				oRoot.appendChild(e)			
			}
			this.oDoc.appendChild(oRoot)
		}		
		else this.oDoc.load(Request)
		CheckDom(this.oDoc)
	}
	//根据参数转换字符串。
	requestParser.prototype.parse=function(s)
	{
		var gate=this.defaultGate		
		var res=s.match(/\[[^\]]*\]/g)		
		for(var i=0;i<res.length;i++)
		{
			var tmp=res[i].replace(/[\[\]]/g,"").replace(/^([^\/]{2,2})/,"//$1").replace(/^([^\:]*)$/,"$1:s")
			var ary=tmp.split(":")
			var oNode=this.oDoc.selectSingleNode(ary[0].toUpperCase())
			var sData
			var sType=ary[1].substring(0,1).toLowerCase()
			if(oNode==null) {
				if(sType=='s'||sType=='x') {			
					sData="N/A"				
				} else {
					sData="null"
				}	
			}	
			else sData=oNode.text
			if(ary[0]=="B") clear("xixi")
			oNode=null
			var sValue=""
			switch(sType)
			{
				case "i":
				case "x":
					sValue=sData;break;
				case "s":sValue="'"+Server.HTMLEncode(sData).replace(/'/g,"\'\'")+"'";break
				case "d":
					var oDate=new Date(sData.replace(/\-/g,"/"))
					if(isNaN(oDate)) sValue="null"
					else sValue="TO_DATE('"+oDate.getString()+"','YYYY-MM-DD HH24:MI:SS')";
					delete oDate
					break
				default:clear(ary[0]+"上错误的数据转换类型["+ary[1]+"]！")
			}
			s=s.replace(res[i],sValue)			
		}
		return s
	}
	//释放对象	
	requestParser.prototype.test=function(s)
	{
		clear(this.parse(s))
	}
	requestParser.prototype.show=function()
	{
		warn(this.oDoc.xml)
	}
	requestParser.prototype.onTerminate=function()
	{
		delete this.oDoc
		this.oDoc=null
	}	
	function showErr(msg)
	{
		Response.Clear()
		Response.Redirect("../Public/message.asp?s="+escape(msg))
	}
%>