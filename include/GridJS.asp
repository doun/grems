<script language=JScript RunAt=Server>	
	function GetGrid() {return new Grid()}
	function Grid()
	{
		//以"_"开头的属性和方法，表示私有(Private)
		this._TimeCounter=(new Date()).getTime()
		_Grid_prototype_Init()
		this._oColumnsDetail=[]
		this._qColumns=[]
		this.PageSize=-1		
		this.PageCount=1
		this.CurrentPage=1
		this.RecordCount=0
		this.GNPS_Count=0
		this.noRecordMsg="没有任何纪录。"		
		this.record=null
		this._resetParam()
		try {Response.Expires=-1} catch(sError) {}
	}
	//初始化对象的方法和公共属性
	function _Grid_prototype_Init() 
	{
		if(Grid.prototype.___bInit___==true) return
		//定义方法
		String.prototype.Trim=function() {return this.replace(/(^\s+|\s+$)/g,"")}
		//Private
		Grid.prototype._getRs=__Grid_prototype__getRs;
		Grid.prototype._resetParam=__Grid_prototype__resetParam;		
		Grid.prototype._send=__Grid_prototype__send;
		Grid.prototype._quest=__Grid_prototype__quest;
		Grid.prototype._upper=__Grid_prototype__upper;
		Grid.prototype._BuildQuery=__Grid_prototype__BuildQuery;
		
		Grid.prototype._BuildQueryColumns=__Grid_prototype__BuildQueryColumns;
		Grid.prototype._BuildGrid=__Grid_prototype__BuildGrid;
		//Pubic
		Grid.prototype.close=__Grid_prototype_onTerminate;
		Grid.prototype.append=__Grid_prototype_append;
		Grid.prototype.circle=__Grid_prototype_circle;
		Grid.prototype.appendCol=__Grid_prototype_appendCol;
		Grid.prototype.Build=__Grid_prototype_Build;
		
		//属性
		Grid.prototype.tables=null      //FROM <this.tables>
		Grid.prototype.sort=null        //ORDER BY <this.sort>
		Grid.prototype.filter=null      //WHERE <this.filter>
		Grid.prototype.group=null       //GROUP BY <this.group>
		Grid.prototype.limit=null	    //[DISTINCT|UNIQUE|etc.]			
		
		Grid.prototype.rAttri=null	    //<TBODY><TR this.rAttri>....</TR></TBODY>			
		Grid.prototype.Connection=null  //Recordset对象的ActiveConnection属性
		
		Grid.prototype.___bInit___=true
	}
	function __Grid_prototype__getRs()
	{		
		this.record=Server.CreateObject("ADODB.RecordSet")		
		this.record.CursorLocation=2 //Server端
		this.record.CursorType=0     //向前 
		this.record.LockType=1       //只读
		//ActiveConnection根据需要自己定义
		var __oConnection=this.Connection
		if(__oConnection==null) __oConnection=Application("GREMS_ConnectionString")
		this.record.ActiveConnection=__oConnection
		delete __oConnection
	}
	function __Grid_prototype__resetParam()
	{
		this.cName=""   //<THEAD>...<TH>this.cName</TH>..</THEAD>		
		this.cValue=""  //Target Database Table Column		
		this.cData=""   //<TBODY>...<TD>this.cData</TD>...</TBODY>		
		this.cAttri=""  //<TBODY>...<TD this.cAttri>...</TD>...</TBODY>		
		this.cFormat="" //[<COLGROUP>...<COL this.cFormat>...</COLGROUP>] & [<THEAD>...<TH this.cFormat>...</TH>..</THEAD>]
	}
	function __Grid_prototype_onTerminate()
	{
		delete this.record
		delete this.Connection
		delete this._appendixCol
		delete this._oColumnsDetail
		delete this._qColumns
	}
	function __Grid_prototype_append(p1,p2,p5,p4,p3)
	{
		p1==null?p1=this.cName:{};
		p2==null?p2=this._upper(this.cValue):{};
		p3==null?p3=this._upper(this.cData):{};
		p4==null?p4=this.cAttri:{};
		p5==null?p5=this.cFormat:{};
		var iLength=this._oColumnsDetail.length		
		if(p3=="") p3=p2
		if(p1=="") p1=p2
		if(/^\d/.test(p5)) p5="style='WIDTH:"+p5+"'"
		if(p3=="") this._send("没有指定第"+(iLength+1)+"列的列值。")
		this._oColumnsDetail[iLength]=[p1,p2,p3,p4,p5]
		this._resetParam()
	}
	function __Grid_prototype_circle(sList)
	{
		this.CircleList=sList.Trim().split(",")
	}
	//list是一个Array(当包含多个列时)或者是一个字符串(只有一个列)
	function __Grid_prototype_appendCol(oList)
	{
		if(this._appendixCol==null) this._appendixCol=[]		
		this._appendixCol=this._appendixCol.concat(oList)
	}
	function __Grid_prototype__send(sMsg,oError)
	{		
		var __m1=""
		if(oError!=null) {__m1+="错误："+oError.description+"\n";oError=null}
		if(this._SQL!=null) __m1+="SQL:\n\t"+this._SQL.replace(/\n/g,"\n\t")+"\n"
		__m1+=sMsg.replace(/\n/g,"\n\t")
		Response.Write("<PRE>\n"+Server.HTMLEncode(__m1)+"\n<PRE>")
		this.close()
		Response.End()
	}
	function __Grid_prototype__quest(sParam)
	{
		var sResult=""+Request(sParam)
		if(sResult=="null"||sResult=="undefined") sResult=""
		return sResult.Trim()
	}
	function __Grid_prototype__upper(sTarget)
	{
		if(typeof(sTarget)=="function") return sTarget
		sTarget=""+sTarget
		if(!/['"]/.test(sTarget)) return sTarget.toUpperCase()
		return sTarget
	}
	function __Grid_prototype__BuildQuery()
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
		
		var lb_gSql="SELECT"		
		//if(this.limit!=null) gSql += " " + this._upper(this.limit)
		lb_gSql += "\n COUNT(" + this._qColumns[0] +") "
		lb_gSql += "\n FROM " + this._upper(this.tables)
		if(this.filter!=null) lb_gSql += "\n WHERE  substr("+this._qColumns[0]+",1,1)='D' and " + this._upper(this.filter)
		this._cSQLGNPS= "SELECT COUNT(1) FROM (\n" + gSql + "\n)"
		if(this.group!=null) lb_gSql += "\n GROUP BY " + this._upper(this.group)
		if(sSort!=null) {sSort=this._upper(sSort);lb_gSql += "\n ORDER BY " + sSort;this.sort=sSort}
		else this.sort=""
		this._SQLGNPS=lb_gSql
		
		return [gSql,this._cSQL]
	}

	//生成要查询的列集
	function __Grid_prototype__BuildQueryColumns(sList)
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
	function __Grid_prototype_Build()
	{
		this._getRs()
		var oSQL=this._BuildQuery()
		
		try {this.record.Open(this._SQLGNPS)}
		catch(sError) {this._send("",sError)}	
		var _iCount=parseInt(""+this.record(0))
		this.GNPS_Count=_iCount
		this.record.Close()

		

		try {this.record.Open(oSQL[1])}
		catch(sError) {this._send("",sError)}	
		var _iCount=parseInt(""+this.record(0))
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
					__SQL = __SQL1  + _end_pos +"\n MINUS \n" + __SQL1 + _start_pos
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
	function __Grid_prototype__BuildGrid(oRecordset)
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
			"\t\t<SPAN id='grid_record_msg' style='WIDTH:100%;HEIGHT:100%;TEXT-ALIGN:center'>在线人数："+Application("online")+"，共有 "+this.RecordCount+" 条记录，其中GNPS有"+this.GNPS_Count+"条记录，LNPS有"+(this.RecordCount-this.GNPS_Count)+"条记录"
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
		this.close()
		this._TimeCounter=(new Date()).getTime()-this._TimeCounter
		//Response.Write(this._TimeCounter)
	}	

</SCRIPT>
<link type="text/css" rel="stylesheet" href="..\Library\Grid_Style.css">
<script src="..\Library\Grid_Script.js"></script>

