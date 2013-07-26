<%@Language=Jscript%>
<%
	Response.Expires=-1
	function Grid()
	{
		this._TimeCounter=(new Date()).getTime()
		this._oColumnsDetail=[]
		this._qColumns=[]
		this.PageSize=-1		
		this.PageCount=1
		this.CurrentPage=1
		this.RecordCount=0
		this.noRecordMsg="没有任何纪录。"		
		this.record=null
		this._resetParam()
	}
	Grid.prototype._getRs=function()
	{		
		this.record=Server.CreateObject("ADODB.RecordSet")		
		this.record.CursorLocation=2 //服务器端光标
		this.record.CursorType=1  //adOpenKeyset
		this.record.ActiveConnection=Application("GREMS_ConnectionString")
	}
	String.prototype.Trim=function() {return this.replace(/(^\s+|\s+$)/g,"")}
	Grid.prototype._resetParam=function()
	{
		//<thead>...<td>cName</td>..</thead>
		this.cName=""
		//Target Database Table Column
		this.cValue=""
		//<tbody>...<td>cData</td>...</tbody>
		this.cData=""
		//<tbody>...<td cAttri>..</td>...</tbody>
		this.cAttri=""
		//<col cFormat>
		this.cFormat=""
	}
	Grid.prototype.onTerminate=function()
	{
		delete this.record
		delete this._appendixCol
		delete this._oColumnsDetail
		delete this._qColumns
	}
	Grid.prototype.append=function(p1,p2,p5,p4,p3)
	{
		p1==null?p1=this.cName:{};
		p2==null?p2=this._upper(this.cValue):{};
		p3==null?p3=this._upper(this.cData):{};
		p4==null?p4=this.cAttri:{};
		p5==null?p5=this.cFormat:{};
		var iLength=this._oColumnsDetail.length		
		if(p3=="") p3=p2
		if(p1=="") p1=p2
		if(p3=="") this._send("没有指定第"+(iLength+1)+"列的列值。")
		this._oColumnsDetail[iLength]=[p1,p2,p3,p4,p5]
		this._resetParam()
	}
	Grid.prototype.circle=function(sList)
	{
		this.CircleList=sList.Trim().split(",")
	}
	//list是一个Array(当包含多个列时)或者是一个字符串(只有一个列)
	Grid.prototype.appendCol=function(oList)
	{
		if(this._appendixCol==null) this._appendixCol=[]		
		this._appendixCol=this._appendixCol.concat(oList)
	}
	Grid.prototype._send=function(sMsg,oError)
	{		
		var __m1=""
		if(oError!=null) {__m1+="错误："+oError.description+"\n";oError=null}
		if(this._SQL!=null) __m1+="SQL:\n\t"+this._SQL.replace(/\n/g,"\n\t")+"\n"
		__m1+=sMsg.replace(/\n/g,"\n\t")
		Response.Write("<PRE>\n"+Server.HTMLEncode(__m1)+"\n<PRE>")
		this.onTerminate()
		Response.End()
	}
	Grid.prototype._quest=function(sParam)
	{
		var sResult=""+Request(sParam)
		if(sResult=="null"||sResult=="undefined") sResult=""
		return sResult.Trim()
	}
	Grid.prototype._upper=function(sTarget)
	{
		if(typeof(sTarget)=="function") return sTarget
		sTarget=""+sTarget
		if(!/['"]/.test(sTarget)) return sTarget.toUpperCase()
		return sTarget
	}
	Grid.prototype._BuildQuery=function()
	{
		if(this.tables==null) this._send("没有指定数据库表名！")
		var iColLength=this._oColumnsDetail.length
		if(iColLength==0) this._send("没有指定列！")		
		this.tables=this.tables.Trim()
		var sSort=this._quest("request_sort")
		var SortColumn
		if(sSort=="") sSort=this.sort
		if(sSort!=null) SortColumn=sSort.split(",")[0].Trim().split(" ")
		else SortColumn=""
		//生成THEAD和COLGROUP部分		
		var c1="\t"
		var c2="\t\t"
		var sColGroup=c2+"<COLGROUP>\n"
		var sThead=c1+"<TABLE id=GridTitle>\n"+c1+"\t<TR>\n"
		for(var i=0;i<iColLength;i++)
		{
			//参数是cValue
			var oColInfo=this._oColumnsDetail[i]
			var iIndex=this._BuildQueryColumns(oColInfo[1])
			sThead += c1+"\t\t<TH " +oColInfo[4]
			sColGroup += c2+"\t<COL "+oColInfo[4]+">\n"
			if(iIndex==-1) sThead += " DisabledSort='t'"
			else {
				//在排序的列上做标记
				if(SortColumn!=""&&(SortColumn[0]==iIndex+1||SortColumn[0]==oColInfo[2]))
				{
					var sDir=SortColumn.length>1?SortColumn[1]:"ASC"		
					sThead+=" SortDirection='"+sDir+"'"
				}
				if(oColInfo[1]==oColInfo[2]) oColInfo[2]=iIndex
			}
			sThead+="><NOBR><SPAN class='ttl'>"+oColInfo[0]+"</SPAN></NOBR></TH>\n"
		}
		sThead += c1+"\t</TR>\n"+c1+"</TABLE>"
		sColGroup += c2+"</COLGROUP>"
		this._sThead=sThead
		this._sColGroup=sColGroup
		if(this._appendixCol!=null) this._qColumns=this._qColumns.concat(this._appendixCol)
		var gSql="SELECT"		
		if(this.limit!=null) gSql += " " + this._upper(this.limit)
		gSql += "\n " + this._qColumns.join(",\n ")
		gSql += "\n FROM " + this._upper(this.tables)
		if(this.filter!=null) gSql += "\n WHERE " + this._upper(this.filter)
		this._cSQL= "SELECT COUNT(1) FROM (\n" + gSql + "\n)"
		if(this.group!=null) gSql += "\n GROUP BY " + this._upper(this.group)
		if(sSort!=null) {sSort=this._upper(sSort);gSql += "\n ORDER BY " + sSort;this.sort=sSort}
		else this.sort=""
		this._SQL=gSql
		return [gSql,this._cSQL]
	}
	//生成要查询的列集
	Grid.prototype._BuildQueryColumns=function(sList)
	{
		var iReturn=-1
		sList=sList.Trim()
		if(sList=="") return iReturn
		//以~分开不同的列
		sList=sList.split("~").join("||'$AND$'||")
		var sPre=sList.substring(0,1)
		if(sPre=="@"||sPre=="#"||sPre=="!") iReturn=-1
		else {
			iReturn=this._qColumns.length
			this._qColumns[iReturn]=sList
		}	
		return iReturn
	}
	Grid.prototype.Build=function()
	{
		this._getRs()
		var oSQL=this._BuildQuery()
		try {this.record.Open(oSQL[1])}
		catch(sError) {this._send("",sError)}	
		var _iCount=parseInt(this.record(0))
		this.RecordCount=_iCount
		this.record.Close()
		var _PageSize=this.PageSize
		//分页
		if(_PageSize!=-1)
		{
			var ____fc=function(___sReq,___og,___iDef)
			{				
				try {										
					___sReq=eval(___og._quest(___sReq))
				} catch(___sError) {___sReq=___iDef==null?0:___iDef}
				delete ___og
				return ___sReq
			}
			var _start_pos=____fc("start_position",this)
			var _end_pos=____fc("end_position",this)
			if(_iCount>0) 
			{				
				var _move_flag=____fc("move_position",this,-2)
				var _iPos
				switch(_move_flag) {
					case -1:_iPos=_start_pos-_PageSize-1;break
					case 1:_iPos=_end_pos;break
					case 3:_iPos=_start_pos-1;break
					case 2:_iPos=_iCount;break
					default:_iPos=0
				}
				if(_iPos<0) _iPos=0
				if(_iCount>_iPos) {
					_start_pos=_iPos+1
					_end_pos=_iPos+_PageSize
					if(_iCount<_end_pos) _end_pos=_iCount
				} else {
					_start_pos=_PageSize*parseInt(_iCount/_PageSize)+1
					_end_pos=_iCount
					if(_start_pos>_end_pos) _start_pos=_end_pos-_PageSize+1
					if(_start_pos<1) _start_pos=1
				}
				var _page=parseInt((_start_pos-1)/_PageSize)+1
				var _page_count=parseInt((_iCount-1)/_PageSize)+1
				if(_page<1) _page=1
				if(_page_count<1) _page_count=1
				this.CurrentPage=_page
				this.PageCount=_page_count
				_end_pos=_end_pos+1		
				var __SQL=oSQL[0]		
				var __SQL1="SELECT * FROM (\n"+__SQL+"\n)\n WHERE ROWNUM < "
				if(_start_pos==1) {
					if(_end_pos<=_iCount) __SQL=__SQL1+ + _end_pos
				} else {
					__SQL = __SQL1  + _end_pos +"\n MINUS\n " + __SQL1 + _start_pos
				}
				this._SQL=__SQL				
			}
		} else {
			_start_pos=1
			_end_pos=_iCount+1
		}
		this._start_pos=_start_pos
		this._end_pos=_end_pos-1		
		this.record.Open(this._SQL)
		this._BuildGrid()
	}	
	Grid.prototype._BuildGrid=function(oRecordset)
	{
		if(oRecordset!=null)
		{
			this.record=oRecordset
			this.RecordCount=oRecordset.RecordCount
			if(this.RecordCount==-1) this.RecordCount=0
			this.tables="NONE"
			this.append(null,"NONE","style='DISPLAY:none'")
			this._BuildQuery()		
			oRecordset=null
		}		
		var sGridInfo = "<TABLE style='WIDTH:100%;HEIGHT:100%;' cellPadding=0 cellSpacing=0>\n"+
			"\t<TR style='HEIGHT:1'><TD>\n"+
			this._sThead+"\n"+
			"\t</TD></TR>\n"+
			"\t<TR><TD>\n"+
			"\t<DIV id='divGridMain' style='WIDTH:100%;HEIGHT:100%;OVERFLOW-Y:scroll;OVERFLOW-X:auto;COLOR:black'>\n"+
			"\t<TABLE id='Grid' cellPadding=0 cellSpacing=0 style='WIDTH:100%;HEIGHT:1'>\n"+
			this._sColGroup+"\n"
		var c1="\t\t"	
		if(this.RecordCount>0) 
		{
			var __j=-1,__i2=-1
			var oC=this._oColumnsDetail
			var _i1=oC.length
			var oR=this.record
			var sRowAttri=this.rAttri
			var sCircle=this.CircleList
			var iCircleLength
			if(sCircle!=null) iCircleLength=sCircle.length
			sGridInfo+="\t\t<TBODY>\n"
			var __DoEval=function(__sTarget) 
			{
				var __sReturn
				switch(typeof(__sTarget)) 
				{
					case "number":__sReturn=oR(__sTarget);break
					case "function":__sReturn=__sTarget(oR,oC,__j,__i2);break
					case "string":	
						if(__sTarget=="") __sReturn=""
						else {		
							var __oMatch=__sTarget.match(/\$\d+/g)
							if(__oMatch!=null) {
								for(var __i=0;__i<__oMatch.length;__i++) 
								__sTarget=__sTarget.replace(__oMatch[__i],
									("'"+oR(__i2)).split("$AND$")[eval(__oMatch[__i].replace(/\$/,""))-1]+"'")
							}
							__oMatch=__sTarget.match(/\^[\w_]+\^/g)
							if(__oMatch!=null) {
								for(var __i=0;__i<__oMatch.length;__i++) {
									var __sRes=__sRes=/^\^(\d+)\^$/.exec(__oMatch[__i])
									if(__sRes!=null)
										__sTarget=__sTarget.replace(__oMatch[__i],"'"+oR(eval(__sRes[1])-1)+"'")
									else __sTarget=__sTarget.replace(__oMatch[__i],"'"+oR(__oMatch[__i].replace(/\^/g,""))+"'")
								}
							}	
							var __sSuf=__sTarget.substring(1)
							switch(__sTarget.substring(0,1))
							{
								case "#":__sReturn=eval(__sSuf);break
								case "@":__sReturn=__sSuf;break
								case "\\":
								case "!":__sReturn=eval(__sSuf.replace(/\\/g,"'"));break
								default:var __oAry=__sTarget.split(" ");__sReturn=oR(__oAry[__oAry.length-1])
							}
						}	
						break
					default:this._send("第"+__i2+"列的参数必须是函数、数字或者字符串！")
				}				
				return ""+__sReturn
			}								
			var ___f1=function() 
			{
				sGridInfo+=c1+"<TR "
				if(sRowAttri!=null) sGridInfo+=__DoEval(sRowAttri)				
				if(sCircle!=null) sGridInfo += " class='"+sCircle[__j%iCircleLength]+"'"
				sGridInfo += ">\n"
				for(__i2=0;__i2<_i1;__i2++)
				{
					var ___s1=__DoEval(oC[__i2][2])
					if(___s1==""||___s1=="null") ___s1="&nbsp;"
					sGridInfo+=c1+"\t<TD noWrap "+__DoEval(oC[__i2][3])+">"+___s1+"</TD>\n"
						
				}
				sGridInfo+=c1+"</TR>\n"
				oR.MoveNext()
			}
			while(!oR.EOF)
			{
				++__j	
				if(__j==0) {
					try {___f1() } catch(sError) {
						this._send("第"+(__i2+1)+"列：\n"+
							"cName："+oC[__i2][0]+"\n"+
							"cValue："+oC[__i2][1]+"\n"+
							"cData："+oC[__i2][2]+"\n"+
							"cAttri："+oC[__i2][3]+"\n"+
							"rAttri："+sRowAttri+"\n",
							sError
						)
					}		
				} else 
				___f1()			
			}
			sGridInfo+="\t\t</TBODY>\n\t</TABLE>\n"	
			delete oR
		} else {
			sGridInfo+="\t</TABLE>\n"+
				"\n\t<TABLE style='WIDTH:100%;HEIGHT:100%'><TR><TD>"+this.noRecordMsg+"</TD></TR></TABLE>\n"+
				"\t<STYLE type='text/css'>BODY {OVERFLOW:hidden}</STYLE>\n"
		}
		sGridInfo+="\t</DIV>\n\t</TD></TR>\n"+
			"\t<TR><TD style='HEIGHT:1;TEXT-ALIGN:center'>\n"+
			"\t\t<SPAN id='grid_record_msg' style='WIDTH:100%;HEIGHT:100%;TEXT-ALIGN:center'>共有 "+this.RecordCount+" 条记录"
		if(this.PageSize!=-1) sGridInfo+="，分为 "+this.PageCount+" 页，这是第 "+this.CurrentPage+" 页"
		sGridInfo+="。</SPAN>\n\t</TD></TR>\n"+
			"\t<TR style='HEIGHT:1;DISPLAY:none'><TD>\n"+
			"\t<FORM method='POST' id='data_list' page_count='"+this.PageCount+"'>\n"+
			"\t\t<INPUT type='hidden' name='start_position' value='"+this._start_pos+"'>\n" +
			"\t\t<INPUT type='hidden' name='end_position' value='"+this._end_pos+"'>\n" +
			"\t\t<INPUT type='hidden' id='record_sort' name='record_sort' value=\""+this.sort.replace(/"/g,'\\\"')+"\">\n" +
			"\t\t<INPUT type='submit' id='move_first' name='move_position' value='-2'>\n" +
			"\t\t<INPUT type='submit' id='move_previous' name='move_position' value='-1'>\n" +
			"\t\t<INPUT type='submit' id='move_current' name='move_position' value='3'>\n" +
			"\t\t<INPUT type='submit' id='move_next' name='move_position' value='1'>\n" +
			"\t\t<INPUT type='submit' id='move_last' name='move_position' value='2'>\n"+
			"\t</FORM>\n\t</TD></TR>\n"			
		sGridInfo+="</TABLE>"
		Response.Write(sGridInfo)
		this.onTerminate()
		this._TimeCounter=(new Date()).getTime()-this._TimeCounter
		//Response.Write(this._TimeCounter)
	}	
%>
<link type="text/css" rel="stylesheet" href="..\Library\Grid_Style.css">
<script src="..\Library\Grid_Script.js"></script>

