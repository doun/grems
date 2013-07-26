<SCRIPT LANGUAGE=VBSCRIPT RUNAT=SERVER>
	class DBPool
		private oSession,oConnection,TransFlag
		private sub class_Initialize
			TransFlag=false
		end sub
		
		private sub Class_terminate
			call Over()
			set oSession=nothing
			set oConnection=nothing
		end sub		
		
		public sub Connect(DBSource)
			dim Sv,Usr
			On Error Resume Next
			set oSession=server.CreateObject("OracleInProcServer.XOraSession")
			Sv=Application(DBSource&"_ServerName")
			If isEmpty(Sv) Then Sv=Application("Default_ServerName")
			Usr=Application(DBSource&"_RuntimeUserName")&"/"&Application(DBSource&"_RuntimePassword")			
			if len(Sv)=0 or len(Usr)=1 then
				Response.Write "错误的数据源("&DBSource&")!"
				Response.End				
			end if
			set oConnection=oSession.DBOpenDatabase(Sv,Usr,clng(0))			
		end sub
		
		public function Open_Record(SQL,DBSource)
			if not (isObject(oSession) and isObject(oConnection)) then Connect DBSource
			set Open_Record=oConnection.DBCreateDynaset(SQL,clng(8))
		end function
		
		public sub BeginTrans
			oSession.BeginTrans
			TransFlag=true
		end sub
		
		public sub CommitTrans
			oSession.CommitTrans
			TransFlag=false
		end sub
		
		public sub RollbackTrans
			oSession.Rollback
			TransFlag=false
		end sub
		
		public sub Start
			oSession.BeginTrans
			TransFlag=true
		end sub
		
		public sub Over
			dim flag
			if not IsObject(oConnection) then exit sub
			flag=false
			if oConnection.LastServerErr <> 0 then
				flag=true
				Response.Write oConnection.LastServerErrText
			elseif err.Number <> 0 then
				flag=true
				Response.Write err.Description
			end if
			if 	TransFlag=false then exit sub			
			if flag=true then
				oSession.CommitTrans
			else
				oSession.RollbackTrans
				Response.End
			end if
			on error goto 0
		end sub
		
		public function Execute(SQL)
			Execute=oConnection.DbExecuteSQL(SQL)
		end function
	end class
</SCRIPT>