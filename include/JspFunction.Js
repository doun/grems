<!--

//=======================================================
//== 常用的Javascript 函数
//== 作者：[PSEIHSH]何善红  
//== 最后修改时间：2002年11月2日8
//=======================================================

// “”：，。！；

// 定义常量 ------------------------------------------------------------------------
var HshTxtReadOnlyBgColor = "#EEEEEE"  // 当输入框是Readonly属性时的背景色

// ==================================================================================
//										第一部分 数值函数
// ==================================================================================

//-----------------------------------------------------------------------------------
//1.1 本函数用于检查指定Text输入框的值是否是数值型数据
// txtName : 文本输入框对象
// sLabel :  文本输入框的标签名称;如:年龄,数量等
//-----------------------------------------------------------------------------------
function JHshIsNumber(txtName,sLabel)
{
	var strTemp = "";
	
	if (isNaN(txtName.value) || (txtName.value.length == 0))
	{
		strTemp = "“" + sLabel + "”必须是数值型数据。";
		window.alert(strTemp) ;
	//	txtName.value = "0";
	//	txtName.select() ;
		txtName.focus() ;
		return false ;
	}	
	else       	
	{	
		return true ; 
	}
}

//------------------------------------------------------------------------------
//1.2 本函数用于检查sNumber字符串是否是数值型数据
//------------------------------------------------------------------------------
function JStrIsNumber(sNumber)
{
	if (isNaN(sNumber) || (sNumber.length == 0))
	{	return false ;	}	
	else	
	{	return true ; 	}
}

// -----------------------------------------------------------------------------
//1.3 本函数用于将数值rNumber保留iDec位小数点进行格式化输出
// -----------------------------------------------------------------------------
function  JHshFormatNumber(rNumber,iDec) 
{
	var sResult,sTemp,i ;
	var iInt ;  // 整数部分
	var iDig ;  // 小数部分
	
	if (iDec <= 0)  //保留的小数点位数小于或等于0
	{
		sResult = Math.round(rNumber) ;	
	}
	else
	{
		iInt = Math.floor(rNumber) ;
		iDig = rNumber - iInt ;
		iDig = Math.round(iDig * Math.pow(10,iDec)) ;
		if (iDig >= Math.pow(10,iDec))   // 当小数点部分四舍五入后向整数位进位时
		{
			iInt = iInt + 1 ;
			iDig = 0 ;
		}
		if (iDig == 0)							// 当小数点部分为0是补0
		{
			sTemp = "" ;
			for (i = 1;i <= iDec ; i++) { sTemp = sTemp + '0'; } 
			sResult = iInt + "." + sTemp ; 
		}
		else
		{ 
			if (iDig < Math.pow(10,iDec - 1)) 
			{
				sTemp = "" ;
				for (i = 1 ; i <= iDec - 1 ; i ++)
				{
					if (iDig < Math.pow(10,i))	{ sTemp = sTemp + "0" ; }	
				}
				sResult = iInt + "." + sTemp + iDig ;
			}
			else
			{
				sResult = iInt + "." + iDig ;
			}	
		}
	}	
	return sResult ;
}
//-----------------------------------------------------------------------------------
//1.4 本函数用于检查指定Text输入框的值是否是数值型数据,但可以为空.
// txtName : 文本输入框对象
// sLabel :  文本输入框的标签名称;如:年龄,数量等
//-----------------------------------------------------------------------------------
function JHshIsNumbers(txtName,sLabel)
{
	var strTemp = "";
	
	if (isNaN(txtName.value))
	{
		strTemp = "“" + sLabel + "”必须是数值型数据。";
		window.alert(strTemp) ;
		txtName.value = "0";
	//	txtName.select() ;
		txtName.focus() ;
		return false ;
	}	
	else       	
	{	
		return true ; 
	}
}

// ==================================================================================
//										第二部分 日期相关函数
// ==================================================================================

// ----------------------------------------------------------------------------------
//2.1 本函数用于用于求解iYear年iMonth月份的天数
// ----------------------------------------------------------------------------------
function JHshGetDays(iYear,iMonth)
{
	var StartDate,EndDate,iStart,iEnd,iDays ;
	switch (iMonth)
	{
		case 1:  return 31 ; 
		case 3:  return 31 ;
		case 5:  return 31 ;
		case 7:  return 31 ; 
		case 8:  return 31 ; 
		case 10: return 31 ;
		case 12: return 31 ;
		case 4:  return 30;
		case 6:  return 30;
		case 9:  return 30;
		case 11: return 30;
		case 2: 
				StartDate = new Date(iYear,1 ,1) ;
				iStart = StartDate.getTime() ;
				EndDate = new Date(iYear,2,1) ;
				iEnd = EndDate.getTime() ;
				iDays = iEnd - iStart ;
				iDays = iDays / 1000 / 60 / 60 / 24 ;
				return Math.round(iDays) ;
				break ;
	}
}

//------------------------------------------------------------------------------
//2.2 本函数用于检查sDate字符串是否是日期型数据
//------------------------------------------------------------------------------
function JHshStrIsDate(sDate)
{
	var sArray,sTemp ;
	var i,i1 = 0,i2 = 0 ;
	var iYear,iMonth,iDay ;
	
	sArray = sDate.split("") ;
	if (sDate == "") 
	{
		return false ;
	}
	else
	{
		for (i = 0; i <= sArray.length - 1 ; i ++)
		{
			if ((i1 == 0) && (sArray[i] == "-")) { i1 = i ; continue ;} 
			if (i1 > 0 && i2 == 0 && sArray[i] == "-" ) { i2 = i; break ; } 
		} 
		
		if (i1 > 0 && i2 > 0)
		{
			sTemp = JHshStrCopy(sDate,0,i1) ;
			if (JStrIsNumber(sTemp))				//判断年是否是数字型数据
			{ iYear = parseInt(sTemp,10) ;	} 
			else
			{ return false ;}
			
			sTemp = JHshStrCopy(sDate,i1 + 1, i2 - i1 - 1) ;
			if (JStrIsNumber(sTemp)) 
			{ 
				iMonth = parseInt(sTemp,10) ;	
				if (iMonth <= 0 || iMonth >= 13)
				{ return false ;}
			} 
			else
			{ return false ;}
			
			sTemp = JHshStrCopy(sDate,i2 + 1,sDate.length - i2 + 1) ;
			if (JStrIsNumber(sTemp)) 
			{ 
				iDay = parseInt(sTemp,10) ;	
				if (iDay <= 0 || iDay > JHshGetDays(iYear,iMonth))
				{ return false ;}
			} 
			else
			{ return false ;}
			
		}
		else
		{
			return false ;
		}
	}
	return true ;
}

//------------------------------------------------------------------------------
//2.2 本函数用于检查sTime字符串是否是时间型数据
//------------------------------------------------------------------------------
function JHshStrIsTime(sTime)
{
	var sArray,sTemp ;
	var i,i1 = 0,i2 = 0 ;
	var iHour,iMin,iSecond ;
	
	sArray = sTime.split("") ;
	if (sTime == "") 
	{
		return false ;
	}
	else
	{
		for (i = 0; i <= sArray.length - 1 ; i ++)
		{
			if ((i1 == 0) && (sArray[i] == ":")) { i1 = i ; continue ;} 
			if (i1 > 0 && i2 == 0 && sArray[i] == ":" ) { i2 = i; break ; } 
		} 

		if (i1 > 0)
		{
			sTemp = JHshStrCopy(sTime,0,i1) ;
			if (JStrIsNumber(sTemp))				//判断年是否是数字型数据
			{ 
				iHour = parseInt(sTemp,10) ;	
				if (iHour < 0 || iHour >= 24) { return false ;}
			} 
			else
			{ return false ;}
			
			if (i2 > 0)
			{
				sTemp = JHshStrCopy(sTime,i1 + 1, i2 - i1 - 1) ;
				if (JStrIsNumber(sTemp)) 
				{ 
					iMin = parseInt(sTemp,10) ;	
					if (iMin < 0 || iMin >= 60) { return false ;}
				} 
				else
				{ return false ;}
			
				sTemp = JHshStrCopy(sTime,i2 + 1,sTime.length - i2 + 1) ;
				if (sTemp != "")
				{
					if (JStrIsNumber(sTemp)) 
					{ 
						iSecond = parseInt(sTemp,10) ;	
						if (iSecond < 0 || iSecond >= 60) { return false ;}
					} 
					else
					{ return false ;}
				}	
			}	
		}
		else
		{
			sTemp = sTime ;
			if (JStrIsNumber(sTemp))				//判断年是否是数字型数据
			{ 
				iHour = parseInt(sTemp,10) ;	
				if (iHour < 0 || iHour >= 24) { return false ;}
			} 
			else
			{ return false ;}
		}
	}
	return true ;
}


// ----------------------------------------------------------------------------------
//2.3 本函数用于将日期型串sDate转换成标准格式"YYYY-MM-DD"的日期型串;
// 其中参数sSplit是分割字符串;               
// ----------------------------------------------------------------------------------
function JFormatDate(sDate,sSplit)
{
	var sArray ;
	var i,i1 = 0,i2 = 0 ;
	var iYear,iMonth,iDay ;
	
	sArray = sDate.split("") ;
	
	for (i = 0; i <= sArray.length - 1 ; i ++)
	{
		if ((i1 == 0) && (sArray[i] == "-")) { i1 = i ; continue ;} 
		if (i1 > 0 && i2 == 0 && sArray[i] == "-" ) { i2 = i; break ; } 
	} 
		
	if (i1 > 0 && i2 > 0)
	{
		iYear = parseInt(JHshStrCopy(sDate,0,i1),10)
		iMonth = parseInt(JHshStrCopy(sDate,i1 + 1, i2 - i1 - 1),10)
		iDay = parseInt(JHshStrCopy(sDate,i2 + 1,sDate.length - i2 + 1),10)
	}
			
	sTemp = iYear + sSplit ;
	if (iMonth < 10) { sTemp = sTemp + "0" + iMonth + sSplit ;}
	            else { sTemp = sTemp + iMonth + sSplit ;}
	if (iDay < 10) { sTemp = sTemp + "0" + iDay ;}
	          else { sTemp = sTemp + iDay ;}
	return sTemp ;
}

function JFormatDates(sDate,sSplit)
{
	var sArray ;
	var i,i1 = 0,i2 = 0 ;
	var iYear,iMonth,iDay ;
	
	sArray = sDate.split("") ;
	
	for (i = 0; i <= sArray.length - 1 ; i ++)
	{
		if ((i1 == 0) && (sArray[i] == "-")) { i1 = i ; continue ;} 
		if (i1 > 0 && i2 == 0 && sArray[i] == "-" ) { i2 = i; break ; } 
	} 
		
	if (i1 > 0 && i2 > 0)
	{
		iYear = parseInt(JHshStrCopy(sDate,0,i1),10)
		iMonth = parseInt(JHshStrCopy(sDate,i1 + 1, i2 - i1 - 1),10)
		iDay = parseInt(JHshStrCopy(sDate,i2 + 1,sDate.length - i2 + 1),10)
	}
			
	sTemp = iYear + sSplit ;
	sTemp = sTemp + iMonth + sSplit ;
	sTemp = sTemp + iDay ;
	return sTemp ;
}

//------------------------------------------------------------------------------
//2.4 本函数用于检查文本框txtName内的数据是否是日期型数据
//------------------------------------------------------------------------------
function JHshCheckTxtIsDate(txtName,sLabel)
{
	var sValue ;

	sValue = JHshLTrim(JHshRTrim(txtName.value)) ;
	if (JHshStrIsDate(sValue))
	{
		txtName.value = JFormatDate(sValue,"-") ;
		return true ;
	}
	else
	{
		strTemp = "“" + sLabel + "”的值<" + txtName.value + ">不是合法的日期型数据。" + unescape("\n\n") ;
		strTemp = strTemp + "合法的日期型数据格式是：<YYYY-MM-DD>或<YYYY-M-D>。" + unescape("\n\n") ;
		strTemp = strTemp + "如：<2000年4月23日>可写成<2000-04-23>或<2000-4-23>。"
		window.alert(strTemp) ;
		txtName.select() ;
		txtName.focus() ;
		return false ;
	}
}

//------------------------------------------------------------------------------
//2.4 本函数用于检查文本框txtName内的数据是否是时间型数据
//------------------------------------------------------------------------------
function JHshCheckTxtIsTime(txtName,sLabel)
{
	var sValue ;

	sValue = JHshLTrim(JHshRTrim(txtName.value)) ;
	if (JHshStrIsTime(sValue))
	{
		//txtName.value = JFormatTime(sValue,":") ;
		return true ;
	}
	else
	{
		strTemp = "“" + sLabel + "”的值<" + txtName.value + ">不是合法的时间型数据。" + unescape("\n\n") ;
		strTemp = strTemp + "合法的时间型数据格式是：<HH:MM:SS>或<HH-M-S>。" + unescape("\n\n") ;
		strTemp = strTemp + "如：<20时8分2秒>可写成<20:08:02>或<20:8:2>。"
		window.alert(strTemp) ;
		txtName.select() ;
		txtName.focus() ;
		return false ;
	}
}





// ----------------------------------------------------------------------------------
//2.5 本函数用于获取系统的当前日期(日期格式是"YYYY-MM-DD")
// ----------------------------------------------------------------------------------
function JHshGetCurrentDate()
{
	var iYear,iMonth,iDate,Today,sDate ;
	
	Today = new Date() ;
	iYear = Today.getYear() ;
	iMonth = Today.getMonth() + 1 ;
	iDate = Today.getDate() ;
	
	sDate = String(iYear) ;
	if (iMonth < 10) 
	{
		sDate = sDate + "-0" + String(iMonth) ;
	}	
	else
	{
		sDate = sDate + "-" + String(iMonth) ;
	}
	if (iDate < 10) 
	{
		sDate = sDate + "-0" + String(iDate) ;
	}	
	else
	{
		sDate = sDate + "-" + String(iDate) ;
	}
	return sDate ;
}

// ----------------------------------------------------------------------------------
//2.6 本函数用于获取系统的当前日期(日期格式是"YYYY年MM月DD日")
// ----------------------------------------------------------------------------------
function JHshGetCurrentCnDate()
{
	var iYear,iMonth,iDate,Today,sDate ;
	
	Today = new Date() ;
	iYear = Today.getYear() ;
	iMonth = Today.getMonth() + 1 ;
	iDate = Today.getDate() ;
	
	sDate = String(iYear) ;
	if (iMonth < 10) 
	{
		sDate = sDate + "年0" + String(iMonth) ;
	}	
	else
	{
		sDate = sDate + "年" + String(iMonth) ;
	}
	if (iDate < 10) 
	{
		sDate = sDate + "月0" + String(iDate) ;
	}	
	else
	{
		sDate = sDate + "月" + String(iDate) ;
	}
	sDate = sDate + "日" ;
	return sDate ;
}
// ----------------------------------------------------------------------------------
//2.5 本函数用于获取系统的当前时间(时间格式是"HH:MM:SS")
// ----------------------------------------------------------------------------------
function JHshGetCurrentTime()
{
	var iHour,iMin,iSecond,Today,sTime ;
	
	Today = new Date() ;
	iHour = Today.getHours() ;
	iMin = Today.getMinutes() ;
	iSecond = Today.getSeconds() ;
	
	sTime = "" ;
	
	if (iHour < 10)
	{ sTime = "0" + String(iHour) ;	}
	else
	{ sTime = String(iHour) ;	}
	
	if (iMin < 10) 
	{	sTime = sTime + ":0" + String(iMin) ;	}	
	else
	{	sTime = sTime + ":" + String(iMin) ;	}
	
	if (iSecond < 10) 
	{	sTime = sTime + ":0" + String(iSecond) ;	}	
	else
	{	sTime = sTime + ":" + String(iSecond) ;	}
	return sTime ;
}


// ----------------------------------------------------------------------------
//2.7 本函数用于初始化相关年Select,
//			其中参数 iBefore表示从当前年开始往前的年份数量;
//						iAfter 表示从当前年开始往后的年份数量;
//-----------------------------------------------------------------------------
function JHshInitYearSelect(iBefore,iAfter,selName) 
{
	var iYear,i,optItem ;
	var dDate = new Date()

	for (i = selName.length ; i >= 0 ; i --)
	{
		selName.options[i] = null;
	}
	
	iYear = dDate.getYear() ;
	for (i = iYear - iBefore; i <= iYear + iAfter; i ++) 
	{  
		optItem = document.createElement("OPTION") ;  
		optItem.text = i ;  
		optItem.value = i ;  
		if (i == iYear) { optItem.selected = true ;}
		selName.add(optItem);  
	}  
}

// ----------------------------------------------------------------------------
//2.8 本函数用于初始化iYear年iMonth月的日期的Select中的Option,
//-----------------------------------------------------------------------------
function JHshInitDateSelect(iYear,iMonth,selName) 
{
	var iDays,i,optItem,sTemp ;

	for (i = selName.length ; i >= 0 ; i --)
	{
		selName.options[i] = null;
	}
	
	iDays = JHshGetDays(parseInt(iYear),parseInt(iMonth)) ;
	for (i = 1; i <= iDays ; i ++) 
	{  
		optItem = document.createElement("OPTION") ;  
		if (i >= 10)
		{
			optItem.text = i ;  
			optItem.value = i ;  
		}
		else
		{
			optItem.text = "0" + i.toString() ;
			optItem.value = "0" + i.toString() ;
		}
		if (i == iYear + 1) { optItem.selected = true ;}
		selName.add(optItem);  
	}  
}



// ==================================================================================
//										第三部分 输入合法性检查函数
// ==================================================================================

// ----------------------------------------------------------------------------------
// 3.1 本函数用于判断Text文本输入框的值是否在合法字符串sCorrectStr中
// ----------------------------------------------------------------------------------
function JHshCorrectChar(txtName,sLabel,sCorrectStr)
{
	var i,CheckChar ;
	
	for(i = 0 ; i < txtName.value.length; i ++)
	{
		CheckChar = txtName.value.charAt(i) ;
		if (sCorrectStr.indexOf(CheckChar) == -1)
		{
			strTemp = "“" + sLabel + "”中含有非法字符。" + unescape("\n\n") ;
			strTemp = strTemp + "合法的字符集是：<" + sCorrectStr + ">。" ;
			window.alert(strTemp) ;
			txtName.select() ;
			txtName.focus() ;
			return false ;
		}
	}
	return true ;	
}

// -----------------------------------------------------------------------------------
// 3.2 本函数用于判断一个文本输入框txtName的值是否为空;
// -----------------------------------------------------------------------------------
function JHshTextEmpty(txtName,sLabel)
{
	var strTemp = "" ; 
	
	strTemp = JHshRTrim(JHshLTrim(txtName.value)) ;
	if (strTemp =="")
	{
		strTemp = "“" + sLabel + "”不能为空，请输入正确的“" + sLabel + "”。";
		window.alert(strTemp) ;
		txtName.select() ;
		txtName.focus() ;
		return true ;
	}
	return false ;
}	

// -----------------------------------------------------------------------------------
// 3.x 本函数用于判断一个隐含文本输入框txtName的值是否为空;
// -----------------------------------------------------------------------------------
function JHshHiddenTextEmpty(txtName,sLabel)
{
	var strTemp = "" ; 
	
	strTemp = JHshRTrim(JHshLTrim(txtName.value)) ;
	if (strTemp =="")
	{
		strTemp = "“" + sLabel + "”不能为空，请输入正确的“" + sLabel + "”。";
		window.alert(strTemp) ;
		return true ;
	}
	return false ;
}	

// -----------------------------------------------------------------------------------
// 3.x 本函数用于判断一个Select 框 txtName的值是否为空;
// -----------------------------------------------------------------------------------
function JHshSelectEmpty(txtName,sLabel)
{
	var strTemp = "" ; 
	
	strTemp = txtName.selectedIndex ;
	if (strTemp =="")
	{
		strTemp = "“" + sLabel + "”不能为空，请输入正确的“" + sLabel + "”。";
		window.alert(strTemp) ;
		txtName.focus() ;
		return true ;
	}
	return false ;
}	

// ==================================================================================
//										第四部分 字符串相关函数
// ==================================================================================


// -----------------------------------------------------------------------------------
//4.1 本函数用于对sString字符串进行前空格截除
// -----------------------------------------------------------------------------------
function JHshLTrim(sString)
{	
	var sStr,i,iStart,sResult = "";
	
	sStr = sString.split("");
	iStart = -1 ;
	for (i = 0 ; i < sStr.length ; i++)
	{
		if (sStr[i] != " ") 
		{
			iStart = i;
			break;
		}
	}
	if (iStart == -1) { return "" ;}    //表示sString中的所有字符均是空格,则返回空串
	else { return sString.substring(iStart) ;}
}

// -----------------------------------------------------------------------------------
//4.2 本函数用于对sString字符串进行后空格截除
// -----------------------------------------------------------------------------------
function JHshRTrim(sString)
{	
	var sStr,i,sResult = "",sTemp = "" ;
	
//	if (sString.length == 0) { return "" ;}	 // 参数sString是空串
		 
	sStr = sString.split("");
	for (i = sStr.length - 1 ; i >= 0 ; i --)  // 将字符串进行倒序
	{	
		sResult = sResult + sStr[i];	
	}
	sTemp = JHshLTrim(sResult) ;					// 进行字符串前空格截除
	
	if (sTemp == "") {	return "" ;	}
	
	sStr = sTemp.split("");
	sResult = "" ;
	for (i = sStr.length - 1 ; i >= 0 ; i--)	// 将经处理后的字符串再进行倒序
	{
		sResult = sResult + sStr[i];
	}
	return sResult ;
}

function JHshTrim(sString)
{
	var strTmp ;
	
	strTmp = JHshRTrim(JHshLTrim(sString)) ;
	
	return strTmp ;
}
// -----------------------------------------------------------------------------
//4.3 本函数用于测试字符串sString的长度;
// 注:对本函数来说,1个汉字代表2单位长度;
// -----------------------------------------------------------------------------
function JHshStrLen(sString)
{
	var sStr,iCount,i,strTemp ;
	
	iCount = 0 ;
	sStr = sString.split("");
	for (i = 0 ; i < sStr.length ; i ++)
	{
		strTemp = escape(sStr[i]);	
		if (strTemp.indexOf("%u",0) == -1)		// 表示是汉字
		{ 
			iCount = iCount + 1 ;
		}	
		else 
		{
			iCount = iCount + 2 ;
		}
	}
	return iCount ;
}

//-----------------------------------------------------------------------------
//4.4 本函数用于复制字符串sString从iStart开始iCount个长度
// 注 : 在使用本函数时,iStart,iCount长度单位均为英文字符长度;
//      即1个英文字母表示1个单位长度,而1个汉字表示2个单位长度.
//		  当复制的最后一个字符只有半个汉字,则被丢弃;
//      当iStart的位置是后半个汉字时,则iStart将会从下一个有效字符开始;iStart从0开始
//-----------------------------------------------------------------------------
function JHshStrCopy(sString,iStart,iCount)  
{
	var sStr,i,j,strTemp = "",sResult = "";
	var iResultLen = 0 ;
	
	if (iStart < 0) { iStart = 0 ;}
	if (iCount < 0) { iCount = 0 ;}
	
	sStr = sString.split("");
	
	j = 0 ;
	for (i = 0 ; i < sStr.length ; i ++)
	{
		strTemp = escape(sStr[i]) ;	
		if (j >= iStart)										// 进行复制字符串
		{
			sResult = sResult + sStr[i] ;
			if (strTemp.indexOf("%u",0) == -1)			// 复制的是非汉字
			{ 
				iResultLen = iResultLen + 1 ; 
				j = j + 1 ;
			}	
			else 	
			{	
				iResultLen = iResultLen + 2 ;	
				j = j + 2 ;
			}
			
			if (iResultLen < iCount) {	continue ;}		// 复制的字串不够长,则继续
			if (iResultLen > iCount)						// 最后一个字符只有半个汉字,则被丢弃;
			{
				sResult = sResult.substring(0,sResult.length - 1) ;
				break ;
			}	
			if (iResultLen = iCount) {	break ; } 
		}
		else
		{
			if (strTemp.indexOf("%u",0) == -1)		  // 非汉字
			{ j = j + 1 ; }	
			else 	
			{	j = j + 2 ;	}
		}
	}
	return sResult ;
}
//-----------------------------------------------------------------------------
//4.4.1 本函数用于复制字符串sString从iStart开始iCount个长度
// 注 : 在使用本函数时,iStart,iCount长度单位均为英文字符长度;
//      即1个英文字母表示1个单位长度,而1个汉字表示2个单位长度.
//		  当复制的最后一个字符只有半个汉字,则被丢弃;
//      当iStart的位置是后半个汉字时,则iStart将会从下一个有效字符开始;iStart从0开始
//-----------------------------------------------------------------------------
function JSunStrCopy(sString,iStart,iCount)  
{
	var sStr,i,j,strTemp = "",sResult = "";
	var iResultLen = 0 ;
	
	if (iStart < 0) { iStart = 0 ;}
	if (iCount < 0) { iCount = 0 ;}
	
	sStr = sString.split("");
	
	j = 0 ;
	for (i = 0 ; i < sStr.length ; i ++)
	{
		strTemp = escape(sStr[i]) ;	
		if (j >= iStart)										// 进行复制字符串
		{
			sResult = sResult + sStr[i] ;
			if (strTemp.indexOf("%u",0) == -1)			// 复制的是非汉字
			{ 
				iResultLen = iResultLen + 1 ; 
				j = j + 1 ;
			}	
			else 	
			{	
				iResultLen = iResultLen + 2 ;	
				j = j + 2 ;
			}
			
			if (iResultLen < iCount) {	continue ;}		// 复制的字串不够长,则继续
			if (iResultLen > iCount)						// 最后一个字符只有半个汉字,则被丢弃;
			{
				sResult = sResult.substring(0,sResult.length - 1) ;
				break ;
			}	
			if (iResultLen = iCount) {	break ; } 
		}
		else
		{
			if (strTemp.indexOf("%u",0) == -1)		  // 非汉字
			{ j = j + 1 ; }	
			else 	
			{	j = j + 2 ;	}
		}
	}
	return sResult ;
}
//------------------------------------------------------------------
//---功能：用于获取已经打开窗口的焦点-------------------------------
//---参数：oOpener表示打开窗口的句柄,openStr:打开的字符串-----------
//---用法：
//var oOpener1
//sStyle="left=120,top=150,height=230,width=400,center=1,scroll=0,status=0,directories=0,channelmode=0"
//oOpener1=FocusWin(oOpener1,URL,sStyle)
//---------------------------------------------------------------
function HshOpenWin(oOpener,openStr,sStyle)
{
	try
	{	
		if (oOpener != null)
		{ 
			oOpener.focus(); 
		}
		else
		{
		   oOpener=window.open(openStr,"s",sStyle);
	    	oOpener.focus();
	    }
	}
	catch(exceptionl)
	{
		oOpener=window.open(openStr,"s",sStyle);
   }
	return oOpener
 }

// ================================================================
// 本函数用于自动将输入文本框中的内容转换成大写字符
// ================================================================
function JHshToUpperCase() 
{
	if ((window.event.keyCode >= 97) && (window.event.keyCode <= 122)) 
	{
		window.event.keyCode = window.event.keyCode - 32 ;
	}
}

// ================================================================
// 本函数用于自动将输入文本框中的内容转换成小写字符
// ================================================================
function JHshToLowerCase() 
{
	if ((window.event.keyCode >= 65) && (window.event.keyCode <= 90)) 
	{
		window.event.keyCode = window.event.keyCode + 32 ;
	}
}

// ================================================================
// 本函数用于限制文本输入框中只能输入数字"0"到"9",".","-"
// ================================================================
function JHshNumberText()
{
	if ( !(((window.event.keyCode >= 48) && (window.event.keyCode <= 57)) 
		|| (window.event.keyCode == 13) || (window.event.keyCode == 46) 
		|| (window.event.keyCode == 45)))
	{
		window.event.keyCode = 0 ;
	}
}
//大写转成小写	
	function UppToLow()
	{
		if((window.event.keyCode<91)&&(window.event.keyCode>64))
			window.event.keyCode=window.event.keyCode+32;			
	}
	

//删除字符串中的空格
function del_space(str)
{
  var s=str,sp;
  
  for(;s.indexOf(" ")!=-1;)  
  {
	sp=s.indexOf(" ");
	s=s.substring(0,sp)+s.substring(sp+1,s.length);	
  }  
 return(s); 
}	

function OpenWindow(sURL,sFeatures){
	return window.open(sURL,"",sFeatures);
}

function OpenModelDialog(sURL,sFeatures){
	return window.showModalDialog(sURL, "", sFeatures);
}

 
	//日期日历
 	function listCalendar() {
	   var today=new Date();                               
	   var day,date,date1;   
	   var c = ":",s="";
				   
		if(today.getDay()==0)  day="星期日";
 
		if(today.getDay()==1)  day="星期一";
 
		if(today.getDay()==2)  day="星期二";
 
		if(today.getDay()==3)  day="星期三";
 
		if(today.getDay()==4)  day="星期四";
 
		if(today.getDay()==5)  day="星期五";
 
		if(today.getDay()==6)  day="星期六"; 

  				    
		date=(today.getYear())+"年"+(today.getMonth()+1)+"月";                                
		date1=today.getDate();      
		document.write(""+"<div align=center><span style='font-family: 宋体;font-size: 9pt;color:#666600;'>"+date+"</font></span><br>");                              
		document.write("<B>"+"<span style='font-family: 宋体;font-size:16pt;color:cc0000;'>"+date1+"</font></span></B><br>");
		document.write(""+"<span style='font-family: 宋体;font-size: 9pt;color:#666600;'>"+day+"</font></span><br>");
		document.write("<span style='color:#666600;font-size:12px' id=spanTime></span></div>");					
		clock();
	}
	
	//时间				
	function clock(){   
		var timeStr,Timer; 	 
		now=new Date(); 	 
		hours=now.getHours(); 
		minutes=now.getMinutes(); 
		seconds=now.getSeconds(); 	 
					 
		timeStr=" "+hours; 
		timeStr+=((minutes<10)?":0":":")+minutes; 
		timeStr+=((seconds<10)?":0":":")+seconds; 	 
		spanTime.innerText=timeStr; 	 	 
		Timer=setTimeout("clock()",1000);  
	}	
	
	function vbAlert(s){
		alert(s);
		return true;
	}
	
	function vbConfirm(s){
		confirm(s);
		return true;
	}	

	function listCalendarNoTime() {
	   var today=new Date();                               
	   var day,date,date1;   
	   var c = ":",s="";		
		if(today.getDay()==0)  day="星期日";
 
		if(today.getDay()==1)  day="星期一";
 
		if(today.getDay()==2)  day="星期二";
 
		if(today.getDay()==3)  day="星期三";
 
		if(today.getDay()==4)  day="星期四";
 
		if(today.getDay()==5)  day="星期五";
 
		if(today.getDay()==6)  day="星期六";
  				    
		date=(today.getYear())+"年"+(today.getMonth()+1)+"月";                                
		date1=today.getDate();      
		document.write(""+"<div align=center><span style='font-family: 宋体;font-size: 9pt;color:#FF6600;'>"+date+"</font></span><br>");                              
		document.write("<B>"+"<span style='font-family: 宋体;font-size:16pt;color:#009933;'>"+date1+"</font></span></B><br>");
		document.write(""+"<span style='font-family: 宋体;font-size: 9pt;color:#FF6600;'>"+day+"</font></span></div>");			
	}
		
		
 //、检测一个文体对象的长度是否正
 function checkLen(obj,iLen,desc){
	if(getStrLen(obj.value)>iLen){
		alert( "「"+desc + "」长度不能超〖" + iLen +"〗个字节,每个汉字为两个字节！");
		obj.select();
		return false;
	}
	return true;
}


//定焦点到指这窗口
function fucusWin(winName){
	try{
		if(winName!=null){			
			winName.focus();
		}
	}
	catch(e){	
	}	
}

function closeWin(winName){
	try{
		if(winName!=null){			
			winName.close();
		}
	}
	catch(e){	
	}	
}

//<script language="JavaScript">listCalendar();</script>
//日期日历
 	function listCalendar() {
		var today=new Date();var day=new Array("星期日","星期一","星期二","星期三","星期四","星期五","星期六"); 
		document.write(""+(today.getYear())+"年"+(today.getMonth()+1)+"月"+"");
		document.write( ""+ today.getDate() +"日 "+""+day[today.getDay()]+""+"");
		document.write("<span id=spanTime></span>");					
		clock();
	}	 
	
//时间				
	function clock(){   
		var timeStr,Timer; 	 
		now=new Date(); 	 
		hours=now.getHours(); 
		minutes=now.getMinutes(); 
		seconds=now.getSeconds();					 
		timeStr=" "+hours; 
		timeStr+=((minutes<10)?":0":":")+minutes; 
		timeStr+=((seconds<10)?":0":":")+seconds; 	 
		spanTime.innerText=timeStr; 	 	 
		Timer=setTimeout("clock()",1000);  
	}
//小写转大写
	function LowToUpp()
	{
		if((window.event.keyCode<123)&&(window.event.keyCode>96))
			window.event.keyCode=window.event.keyCode-32;			
	}

//大写转成小写	
	function UppToLow()
	{
		if((window.event.keyCode<91)&&(window.event.keyCode>64))
			window.event.keyCode=window.event.keyCode+32;			
	}
	

//删除字符串中的空格
function del_space(str)
{
  var s=str,sp;
  
  for(;s.indexOf(" ")!=-1;)  
  {
	sp=s.indexOf(" ");
	s=s.substring(0,sp)+s.substring(sp+1,s.length);	
  }  
 return(s); 
}	
//-->
