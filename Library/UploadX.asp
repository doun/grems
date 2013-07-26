<%
Dim FormData, FormSize, Divider, bCrLf
Dim StartPos,strlen,SearchStr,i,ValStart,ValLen,ValContent,Path,fs,FileStart,FileLen,FileContent
Dim hFileName,rFileName,FileNameName
FormSize = Request.TotalBytes
FormData = Request.BinaryRead(FormSize)
bCrLf = ChrB(13) & ChrB(10)
Divider = LeftB(FormData, InStrB(FormData, bCrLf) - 1)

function makePassword(byVal maxLen)
Dim strNewPass
Dim whatsNext, upper, lower, intCounter
Randomize
For intCounter = 1 To maxLen
    whatsNext = int((1-0+1)*Rnd)
        upper = 57   
        lower = 48
        strNewPass = strNewPass & Chr(Int((upper - lower + 1) * Rnd + lower))
Next
        makePassword = strNewPass
end function

Function SaveFile(FormFileField, Path, MaxSize, SavType)
'���ϴ����ļ����浽path��ָ����Ŀ¼���档
'FormFileField  �ϴ�����"file"����
'Path       Ҫ�����ļ��ķ���������·������ʽΪ��"d:\path\subpath"��"d:\path\subpath\"
'MaxSize    �����ϴ��ļ�����󳤶ȣ���KByteΪ��λ
'SavType    �����������ļ��ķ�ʽ��
'           0   Ψһ�ļ�����ʽ�������ͬ�����Զ�������
'           1   ����ʽ�������ͬ�������
'           2   ���Ƿ�ʽ�������ͬ���򸲸�ԭ�����ļ�
	Dim StreamObj,StreamObj1
    Set StreamObj = Server.CreateObject("ADODB.Stream")
    Set StreamObj1 = Server.CreateObject("ADODB.Stream")
    StreamObj.Mode = 3
    StreamObj1.Mode = 3
    StreamObj.Type = 1
    StreamObj1.Type = 1
    SaveFile = ""
    StartPos = LenB(Divider) + 2
    FormFileField = Chr(34) & FormFileField & Chr(34)
    If Right(trim(Path),1) <> "\" Then
       Path = Path & "\"
    End If

    Do While StartPos > 0
        strlen = InStrB(StartPos, FormData, bCrLf) - StartPos
        SearchStr = MidB(FormData, StartPos, strlen)
        If InStr(bin2str(SearchStr), FormFileField) > 0 Then
            FileNameName = bin2str(GetFileName(SearchStr,path,SavType))
            If FileNameName <> "" Then
                FileStart = InStrB(StartPos, FormData, bCrLf & bCrLf) + 4
                FileLen = InStrB(StartPos, FormData, Divider) - 2 - FileStart
                If FileLen <= MaxSize*2048 Then
                       FileContent = MidB(FormData, FileStart, FileLen)
                    StreamObj.Open
                    StreamObj1.Open
                    StreamObj.Write FormData
                    StreamObj.Position=FileStart-1
                    StreamObj.CopyTo StreamObj1,FileLen
                    If SavType =0 Then
                        SavType = 1
                    End If
					SavType=1

					Dim objScript
					Set objScript=Server.CreateObject("Scripting.FileSystemObject")
					if objScript.FileExists (Path & FileNameName) then
						FileNameName= makePassword(10) & FileNameName
					end if
					Set objScript = Nothing
					
					'Response.Write Path & FileNameName
					'Response.End
				
                    StreamObj1.SaveToFile Path & FileNameName, SavType
                    StreamObj.Close
                    StreamObj1.Close
                    If SaveFile <> "" Then
                        SaveFile = SaveFile & ","  & FileNameName
                    Else
                        SaveFile = FileNameName
                    End If
                Else
                    If SaveFile <> "" Then
                        SaveFile = SaveFile & ",*TooBig*"
                    Else
                        SaveFile = "*TooBig*"
                    End If
                End If
            End If
        End If
        If InStrB(StartPos, FormData, Divider) < 1 Then
            Exit Do
        End If
        StartPos = InStrB(StartPos, FormData, Divider) + LenB(Divider) + 2
    Loop

End Function

Function GetFormVal(FormName)
    GetFormVal = ""
    StartPos = LenB(Divider) + 2
    FormName = Chr(34) & FormName & Chr(34)
    Do While StartPos > 0
        strlen = InStrB(StartPos, FormData, bCrLf) - StartPos
        SearchStr = MidB(FormData, StartPos, strlen)
        If InStr(bin2str(SearchStr), FormName) > 0 Then
               ValStart = InStrB(StartPos, FormData, bCrLf & bCrLf) + 4
               ValLen = InStrB(StartPos, FormData, Divider) - 2 - ValStart
                  ValContent = MidB(FormData, ValStart, ValLen)
               If GetFormVal <> "" Then
                GetFormVal = GetFormVal & "," & bin2str(ValContent)
            Else
                GetFormVal = bin2str(ValContent)
            End If
        End If
        If InStrB(StartPos, FormData, Divider) < 1 Then
            Exit Do
        End If
        StartPos = InStrB(StartPos, FormData, Divider) + LenB(Divider) + 2
    Loop
End Function

Function bin2str(binstr)
   Dim varlen, clow, ccc, skipflag
   skipflag = 0
   ccc = ""
   varlen = LenB(binstr)
   For i = 1 To varlen
       If skipflag = 0 Then
          clow = MidB(binstr, i, 1)
          If AscB(clow) > 127 Then
             ccc = ccc & Chr(AscW(MidB(binstr, i + 1, 1) & clow))
             skipflag = 1
          Else
             ccc = ccc & Chr(AscB(clow))
          End If
       Else
          skipflag = 0
       End If
   Next
   bin2str = ccc
End Function

Function str2bin(str)
    For i = 1 To Len(str)
        str2bin = str2bin & ChrB(Asc(Mid(str, i, 1)))
    Next
End Function

Function GetFileName(str,path,savtype)
    Set fs = Server.CreateObject("Scripting.FileSystemObject")
    str = RightB(str,LenB(str)-InstrB(str,str2bin("FileNameName="))-9)
    GetFileName = ""
    FileNameName = ""
    For i = LenB(str) To 1 Step -1
        If MidB(str, i, 1) = ChrB(Asc("\")) Then
            FileNameName = MidB(str, i + 1, LenB(str) - i - 1)
            Exit For
        End If
    Next
    If savtype = 0 and fs.FileExists(path & bin2str(FileNameName)) = True Then
        hFileName = FileNameName
        rFileName = ""
        For i = LenB(FileNameName) To 1 Step -1
            If MidB(FileNameName, i, 1) = ChrB(Asc(".")) Then
                hFileName = LeftB(FileNameName, i-1)
                rFileName = RightB(FileNameName, LenB(FileNameName)-i+1)
                Exit For
            End If
        Next
           For i = 0 to 9999 
               'hFileName = hFileName & str2bin(i)
               If fs.FileExists(path & bin2str(hFileName) & i & bin2str(rFileName)) = False Then
                   FileNameName = hFileName & str2bin(i) & rFileName
                   Exit For
              End If
           Next
       End If
       Set fs = Nothing
       GetFileName = FileNameName
End Function
%>