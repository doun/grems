<SCRIPT LANGUAGE="VBScript" RUNAT="Server">

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' NAME: libErrorSystem.asp -- routines for tracking error codes and descriptions

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'	Constants
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Const cDefaultErrLogFile = "rraErrors.Log"
Const cErrHdr = "系统发生错误，ID: "
Const cErrNum = "错误号: "
Const cErrNoErrorFunc = "无"
Const cErrNoErrorDesc = "没有错误发生。"

Const g_Error_strErrLogFile = "g_Error_strErrLogFile"
Const g_Error_strFuncName   = "g_Error_strFuncName" 
Const g_Error_lNum          = "g_Error_lNum"
Const g_Error_strDesc       = "g_Error_strDesc"


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
'	PUBLIC ROUTINES
'
'	NOTE: InitErrorSystem() should be called before calling any other
'	routine in this module.
'
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Sub InitErrorSystem(ByVal strErrLogFile)
	If strErrLogFile = "" Then
		Session(g_Error_strErrLogFile) = cDefaultErrLogFile 
	Else
		Session(g_Error_strErrLogFile) = strErrLogFile
	End If
	Session(g_Error_strFuncName) = ""
	Session(g_Error_lNum) = 0
	Session(g_Error_strDesc) = ""
End Sub


Sub SetErrorLogFile(ByVal strErrLogFile)
	Session(g_Error_strErrLogFile) = strErrLogFile
End Sub


Function GetErrorLogFile()
	GetErrorLogFile = Session(g_Error_strErrLogFile)
End Function


Sub SetErrorFuncName(ByVal strFuncName)
	Session(g_Error_strFuncName) = strFuncName
End Sub


Function GetErrorFuncName() 
	GetErrorFuncName = Session(g_Error_strFuncName)
End Function


Sub SetErrorNum(ByVal lNum)
	Session(g_Error_lNum) = lNum
End Sub


Function GetErrorNum()
	GetErrorNum = Session(g_Error_lNum)
End Function


Sub SetErrorDesc(ByVal strDesc)
	Session(g_Error_strDesc) = strDesc
End Sub


Function GetErrorDesc()
	GetErrorDesc = Session(g_Error_strDesc)
End Function


Sub SetError(ByVal strFuncName, ByVal lNum, ByVal strDesc)
	On Error Resume Next 
	SetErrorFuncName strFuncName
	SetErrorNum lNum
	SetErrorDesc strDesc
	'回滚事务,如果存在的话
	Session("cnn").RollbackTrans
End Sub


Function HaveError()
	If Session(g_Error_strFuncName) <> "" Or Session(g_Error_lNum) <> 0 Or Session(g_Error_strDesc) <> "" Then
		HaveError = True
	Else
		HaveError = False
	End If
End Function


Sub ClearError()
	SetError "", 0, ""
End Sub


Sub WriteErrorToLogFile()
	Dim bRc
	Dim strErrMsg

	If HaveError() Then
		strErrMsg = cErrHdr & Session.SessionID & ", " & cErrNum & CStr(Session(g_Error_lNum)) &_
		            ", " & Session(g_Error_strFuncName) & " - " & Session(g_Error_strDesc)
	Else
		strErrMsg = cErrNoErrorDesc
	End If
	bRc = WriteToFile(Session(g_Error_strErrLogFile), strErrMsg)
	'ClearError
End Sub


'-------------------------------------------------------------------------
'	Write a message to the passed file.
'	Note: The following code uses the FileSystemObject
'-------------------------------------------------------------------------
Function WriteToFile(ByVal strFileName, ByVal strMsg)
	Dim strFullPath 
	Dim objFS 
	Dim objFile

	On Error Resume Next 
	strFullPath = Server.MapPath("\") + "\" + strFileName
	Set objFS = Server.CreateObject("Scripting.FileSystemObject")
	Set objFile = objFS.OpenTextFile(strFullPath, 8, True) 

	objFile.WriteLine(CStr(Date()) + " " + CStr(Time()) + " " + strMsg)	
	objFile.Close

	WriteToFile = True
	If Err Then 
		WriteToFile = False
		If Not HaveError() Then
			SetError "WriteToFile", Err.number, Err.Description
		End If
	End If 
End Function
</SCRIPT> 