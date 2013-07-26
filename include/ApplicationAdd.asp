<script language=vbscript runat=server>
	sub CombineString(byref A,byval B)
		A = A & B
	end sub
	sub CreateApplicationGrant(sFlag)
		dim Conn,oRs
		set Conn=server.CreateObject("Adodb.connection") 
		Conn.Open Application("GREMS_ConnectionString")
		set oRs=server.CreateObject("Adodb.recordset") 
		sFlag=ucase(sFlag)
		'==============1、生成用户权限字符串，并储存在Application中=============='
		if sFlag="ALL" or sFlag="GRANT" then
			dim StrSql,i,gText
			StrSql="SELECT wg_id,wg_right from "+Application("DBOwner")+".grems_work_group " & _
				"order by wg_id"
			oRs.Open StrSql,Conn,1,1
			ary=oRs.GetString(2,,":",";","")
			Application("USER_GRANT")=ary				
		end if	
		if sFlag="ALL" then ReBuildParam()
		'==================END==============='
		set Conn=nothing
		set oRs=nothing
	end sub	
	sub ReBuildParam()
		dim str
		set Conn=server.CreateObject("Adodb.connection") 
		Conn.Open Application("GREMS_ConnectionString")
		set oRs=server.CreateObject("Adodb.recordset") 
		oRs.open "select PARAM_ID,PARAM_VALUE FROM "+Application("DBOwner")+".grems_param",Conn,1,1
		str="var oParamList={"
		Do while not oRs.EOF
			if str<> "var oParamList={" then str=str&","
			str=str & "'" & oRs(0) & "':'" & oRs(1) & "'"
			oRs.movenext
		loop
		str = str & "}"		
		Application("PARAM_INFO")=str
		set Conn=nothing
		set oRs=nothing
	end sub	
	if Application("USER_GRANT")=""  then CreateApplicationGrant("ALL")	
	if Application("PARAM_INFO")="" then ReBuildParam
</script>