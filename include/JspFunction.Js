<!--

//=======================================================
//== ���õ�Javascript ����
//== ���ߣ�[PSEIHSH]���ƺ�  
//== ����޸�ʱ�䣺2002��11��2��8
//=======================================================

// ��������������

// ���峣�� ------------------------------------------------------------------------
var HshTxtReadOnlyBgColor = "#EEEEEE"  // ���������Readonly����ʱ�ı���ɫ

// ==================================================================================
//										��һ���� ��ֵ����
// ==================================================================================

//-----------------------------------------------------------------------------------
//1.1 ���������ڼ��ָ��Text������ֵ�Ƿ�����ֵ������
// txtName : �ı���������
// sLabel :  �ı������ı�ǩ����;��:����,������
//-----------------------------------------------------------------------------------
function JHshIsNumber(txtName,sLabel)
{
	var strTemp = "";
	
	if (isNaN(txtName.value) || (txtName.value.length == 0))
	{
		strTemp = "��" + sLabel + "����������ֵ�����ݡ�";
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
//1.2 ���������ڼ��sNumber�ַ����Ƿ�����ֵ������
//------------------------------------------------------------------------------
function JStrIsNumber(sNumber)
{
	if (isNaN(sNumber) || (sNumber.length == 0))
	{	return false ;	}	
	else	
	{	return true ; 	}
}

// -----------------------------------------------------------------------------
//1.3 ���������ڽ���ֵrNumber����iDecλС������и�ʽ�����
// -----------------------------------------------------------------------------
function  JHshFormatNumber(rNumber,iDec) 
{
	var sResult,sTemp,i ;
	var iInt ;  // ��������
	var iDig ;  // С������
	
	if (iDec <= 0)  //������С����λ��С�ڻ����0
	{
		sResult = Math.round(rNumber) ;	
	}
	else
	{
		iInt = Math.floor(rNumber) ;
		iDig = rNumber - iInt ;
		iDig = Math.round(iDig * Math.pow(10,iDec)) ;
		if (iDig >= Math.pow(10,iDec))   // ��С���㲿�����������������λ��λʱ
		{
			iInt = iInt + 1 ;
			iDig = 0 ;
		}
		if (iDig == 0)							// ��С���㲿��Ϊ0�ǲ�0
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
//1.4 ���������ڼ��ָ��Text������ֵ�Ƿ�����ֵ������,������Ϊ��.
// txtName : �ı���������
// sLabel :  �ı������ı�ǩ����;��:����,������
//-----------------------------------------------------------------------------------
function JHshIsNumbers(txtName,sLabel)
{
	var strTemp = "";
	
	if (isNaN(txtName.value))
	{
		strTemp = "��" + sLabel + "����������ֵ�����ݡ�";
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
//										�ڶ����� ������غ���
// ==================================================================================

// ----------------------------------------------------------------------------------
//2.1 �����������������iYear��iMonth�·ݵ�����
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
//2.2 ���������ڼ��sDate�ַ����Ƿ�������������
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
			if (JStrIsNumber(sTemp))				//�ж����Ƿ�������������
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
//2.2 ���������ڼ��sTime�ַ����Ƿ���ʱ��������
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
			if (JStrIsNumber(sTemp))				//�ж����Ƿ�������������
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
			if (JStrIsNumber(sTemp))				//�ж����Ƿ�������������
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
//2.3 ���������ڽ������ʹ�sDateת���ɱ�׼��ʽ"YYYY-MM-DD"�������ʹ�;
// ���в���sSplit�Ƿָ��ַ���;               
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
//2.4 ���������ڼ���ı���txtName�ڵ������Ƿ�������������
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
		strTemp = "��" + sLabel + "����ֵ<" + txtName.value + ">���ǺϷ������������ݡ�" + unescape("\n\n") ;
		strTemp = strTemp + "�Ϸ������������ݸ�ʽ�ǣ�<YYYY-MM-DD>��<YYYY-M-D>��" + unescape("\n\n") ;
		strTemp = strTemp + "�磺<2000��4��23��>��д��<2000-04-23>��<2000-4-23>��"
		window.alert(strTemp) ;
		txtName.select() ;
		txtName.focus() ;
		return false ;
	}
}

//------------------------------------------------------------------------------
//2.4 ���������ڼ���ı���txtName�ڵ������Ƿ���ʱ��������
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
		strTemp = "��" + sLabel + "����ֵ<" + txtName.value + ">���ǺϷ���ʱ�������ݡ�" + unescape("\n\n") ;
		strTemp = strTemp + "�Ϸ���ʱ�������ݸ�ʽ�ǣ�<HH:MM:SS>��<HH-M-S>��" + unescape("\n\n") ;
		strTemp = strTemp + "�磺<20ʱ8��2��>��д��<20:08:02>��<20:8:2>��"
		window.alert(strTemp) ;
		txtName.select() ;
		txtName.focus() ;
		return false ;
	}
}





// ----------------------------------------------------------------------------------
//2.5 ���������ڻ�ȡϵͳ�ĵ�ǰ����(���ڸ�ʽ��"YYYY-MM-DD")
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
//2.6 ���������ڻ�ȡϵͳ�ĵ�ǰ����(���ڸ�ʽ��"YYYY��MM��DD��")
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
		sDate = sDate + "��0" + String(iMonth) ;
	}	
	else
	{
		sDate = sDate + "��" + String(iMonth) ;
	}
	if (iDate < 10) 
	{
		sDate = sDate + "��0" + String(iDate) ;
	}	
	else
	{
		sDate = sDate + "��" + String(iDate) ;
	}
	sDate = sDate + "��" ;
	return sDate ;
}
// ----------------------------------------------------------------------------------
//2.5 ���������ڻ�ȡϵͳ�ĵ�ǰʱ��(ʱ���ʽ��"HH:MM:SS")
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
//2.7 ���������ڳ�ʼ�������Select,
//			���в��� iBefore��ʾ�ӵ�ǰ�꿪ʼ��ǰ���������;
//						iAfter ��ʾ�ӵ�ǰ�꿪ʼ������������;
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
//2.8 ���������ڳ�ʼ��iYear��iMonth�µ����ڵ�Select�е�Option,
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
//										�������� ����Ϸ��Լ�麯��
// ==================================================================================

// ----------------------------------------------------------------------------------
// 3.1 �����������ж�Text�ı�������ֵ�Ƿ��ںϷ��ַ���sCorrectStr��
// ----------------------------------------------------------------------------------
function JHshCorrectChar(txtName,sLabel,sCorrectStr)
{
	var i,CheckChar ;
	
	for(i = 0 ; i < txtName.value.length; i ++)
	{
		CheckChar = txtName.value.charAt(i) ;
		if (sCorrectStr.indexOf(CheckChar) == -1)
		{
			strTemp = "��" + sLabel + "���к��зǷ��ַ���" + unescape("\n\n") ;
			strTemp = strTemp + "�Ϸ����ַ����ǣ�<" + sCorrectStr + ">��" ;
			window.alert(strTemp) ;
			txtName.select() ;
			txtName.focus() ;
			return false ;
		}
	}
	return true ;	
}

// -----------------------------------------------------------------------------------
// 3.2 �����������ж�һ���ı������txtName��ֵ�Ƿ�Ϊ��;
// -----------------------------------------------------------------------------------
function JHshTextEmpty(txtName,sLabel)
{
	var strTemp = "" ; 
	
	strTemp = JHshRTrim(JHshLTrim(txtName.value)) ;
	if (strTemp =="")
	{
		strTemp = "��" + sLabel + "������Ϊ�գ���������ȷ�ġ�" + sLabel + "����";
		window.alert(strTemp) ;
		txtName.select() ;
		txtName.focus() ;
		return true ;
	}
	return false ;
}	

// -----------------------------------------------------------------------------------
// 3.x �����������ж�һ�������ı������txtName��ֵ�Ƿ�Ϊ��;
// -----------------------------------------------------------------------------------
function JHshHiddenTextEmpty(txtName,sLabel)
{
	var strTemp = "" ; 
	
	strTemp = JHshRTrim(JHshLTrim(txtName.value)) ;
	if (strTemp =="")
	{
		strTemp = "��" + sLabel + "������Ϊ�գ���������ȷ�ġ�" + sLabel + "����";
		window.alert(strTemp) ;
		return true ;
	}
	return false ;
}	

// -----------------------------------------------------------------------------------
// 3.x �����������ж�һ��Select �� txtName��ֵ�Ƿ�Ϊ��;
// -----------------------------------------------------------------------------------
function JHshSelectEmpty(txtName,sLabel)
{
	var strTemp = "" ; 
	
	strTemp = txtName.selectedIndex ;
	if (strTemp =="")
	{
		strTemp = "��" + sLabel + "������Ϊ�գ���������ȷ�ġ�" + sLabel + "����";
		window.alert(strTemp) ;
		txtName.focus() ;
		return true ;
	}
	return false ;
}	

// ==================================================================================
//										���Ĳ��� �ַ�����غ���
// ==================================================================================


// -----------------------------------------------------------------------------------
//4.1 ���������ڶ�sString�ַ�������ǰ�ո�س�
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
	if (iStart == -1) { return "" ;}    //��ʾsString�е������ַ����ǿո�,�򷵻ؿմ�
	else { return sString.substring(iStart) ;}
}

// -----------------------------------------------------------------------------------
//4.2 ���������ڶ�sString�ַ������к�ո�س�
// -----------------------------------------------------------------------------------
function JHshRTrim(sString)
{	
	var sStr,i,sResult = "",sTemp = "" ;
	
//	if (sString.length == 0) { return "" ;}	 // ����sString�ǿմ�
		 
	sStr = sString.split("");
	for (i = sStr.length - 1 ; i >= 0 ; i --)  // ���ַ������е���
	{	
		sResult = sResult + sStr[i];	
	}
	sTemp = JHshLTrim(sResult) ;					// �����ַ���ǰ�ո�س�
	
	if (sTemp == "") {	return "" ;	}
	
	sStr = sTemp.split("");
	sResult = "" ;
	for (i = sStr.length - 1 ; i >= 0 ; i--)	// ������������ַ����ٽ��е���
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
//4.3 ���������ڲ����ַ���sString�ĳ���;
// ע:�Ա�������˵,1�����ִ���2��λ����;
// -----------------------------------------------------------------------------
function JHshStrLen(sString)
{
	var sStr,iCount,i,strTemp ;
	
	iCount = 0 ;
	sStr = sString.split("");
	for (i = 0 ; i < sStr.length ; i ++)
	{
		strTemp = escape(sStr[i]);	
		if (strTemp.indexOf("%u",0) == -1)		// ��ʾ�Ǻ���
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
//4.4 ���������ڸ����ַ���sString��iStart��ʼiCount������
// ע : ��ʹ�ñ�����ʱ,iStart,iCount���ȵ�λ��ΪӢ���ַ�����;
//      ��1��Ӣ����ĸ��ʾ1����λ����,��1�����ֱ�ʾ2����λ����.
//		  �����Ƶ����һ���ַ�ֻ�а������,�򱻶���;
//      ��iStart��λ���Ǻ�������ʱ,��iStart�������һ����Ч�ַ���ʼ;iStart��0��ʼ
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
		if (j >= iStart)										// ���и����ַ���
		{
			sResult = sResult + sStr[i] ;
			if (strTemp.indexOf("%u",0) == -1)			// ���Ƶ��ǷǺ���
			{ 
				iResultLen = iResultLen + 1 ; 
				j = j + 1 ;
			}	
			else 	
			{	
				iResultLen = iResultLen + 2 ;	
				j = j + 2 ;
			}
			
			if (iResultLen < iCount) {	continue ;}		// ���Ƶ��ִ�������,�����
			if (iResultLen > iCount)						// ���һ���ַ�ֻ�а������,�򱻶���;
			{
				sResult = sResult.substring(0,sResult.length - 1) ;
				break ;
			}	
			if (iResultLen = iCount) {	break ; } 
		}
		else
		{
			if (strTemp.indexOf("%u",0) == -1)		  // �Ǻ���
			{ j = j + 1 ; }	
			else 	
			{	j = j + 2 ;	}
		}
	}
	return sResult ;
}
//-----------------------------------------------------------------------------
//4.4.1 ���������ڸ����ַ���sString��iStart��ʼiCount������
// ע : ��ʹ�ñ�����ʱ,iStart,iCount���ȵ�λ��ΪӢ���ַ�����;
//      ��1��Ӣ����ĸ��ʾ1����λ����,��1�����ֱ�ʾ2����λ����.
//		  �����Ƶ����һ���ַ�ֻ�а������,�򱻶���;
//      ��iStart��λ���Ǻ�������ʱ,��iStart�������һ����Ч�ַ���ʼ;iStart��0��ʼ
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
		if (j >= iStart)										// ���и����ַ���
		{
			sResult = sResult + sStr[i] ;
			if (strTemp.indexOf("%u",0) == -1)			// ���Ƶ��ǷǺ���
			{ 
				iResultLen = iResultLen + 1 ; 
				j = j + 1 ;
			}	
			else 	
			{	
				iResultLen = iResultLen + 2 ;	
				j = j + 2 ;
			}
			
			if (iResultLen < iCount) {	continue ;}		// ���Ƶ��ִ�������,�����
			if (iResultLen > iCount)						// ���һ���ַ�ֻ�а������,�򱻶���;
			{
				sResult = sResult.substring(0,sResult.length - 1) ;
				break ;
			}	
			if (iResultLen = iCount) {	break ; } 
		}
		else
		{
			if (strTemp.indexOf("%u",0) == -1)		  // �Ǻ���
			{ j = j + 1 ; }	
			else 	
			{	j = j + 2 ;	}
		}
	}
	return sResult ;
}
//------------------------------------------------------------------
//---���ܣ����ڻ�ȡ�Ѿ��򿪴��ڵĽ���-------------------------------
//---������oOpener��ʾ�򿪴��ڵľ��,openStr:�򿪵��ַ���-----------
//---�÷���
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
// �����������Զ��������ı����е�����ת���ɴ�д�ַ�
// ================================================================
function JHshToUpperCase() 
{
	if ((window.event.keyCode >= 97) && (window.event.keyCode <= 122)) 
	{
		window.event.keyCode = window.event.keyCode - 32 ;
	}
}

// ================================================================
// �����������Զ��������ı����е�����ת����Сд�ַ�
// ================================================================
function JHshToLowerCase() 
{
	if ((window.event.keyCode >= 65) && (window.event.keyCode <= 90)) 
	{
		window.event.keyCode = window.event.keyCode + 32 ;
	}
}

// ================================================================
// ���������������ı��������ֻ����������"0"��"9",".","-"
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
//��дת��Сд	
	function UppToLow()
	{
		if((window.event.keyCode<91)&&(window.event.keyCode>64))
			window.event.keyCode=window.event.keyCode+32;			
	}
	

//ɾ���ַ����еĿո�
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

 
	//��������
 	function listCalendar() {
	   var today=new Date();                               
	   var day,date,date1;   
	   var c = ":",s="";
				   
		if(today.getDay()==0)  day="������";
 
		if(today.getDay()==1)  day="����һ";
 
		if(today.getDay()==2)  day="���ڶ�";
 
		if(today.getDay()==3)  day="������";
 
		if(today.getDay()==4)  day="������";
 
		if(today.getDay()==5)  day="������";
 
		if(today.getDay()==6)  day="������"; 

  				    
		date=(today.getYear())+"��"+(today.getMonth()+1)+"��";                                
		date1=today.getDate();      
		document.write(""+"<div align=center><span style='font-family: ����;font-size: 9pt;color:#666600;'>"+date+"</font></span><br>");                              
		document.write("<B>"+"<span style='font-family: ����;font-size:16pt;color:cc0000;'>"+date1+"</font></span></B><br>");
		document.write(""+"<span style='font-family: ����;font-size: 9pt;color:#666600;'>"+day+"</font></span><br>");
		document.write("<span style='color:#666600;font-size:12px' id=spanTime></span></div>");					
		clock();
	}
	
	//ʱ��				
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
		if(today.getDay()==0)  day="������";
 
		if(today.getDay()==1)  day="����һ";
 
		if(today.getDay()==2)  day="���ڶ�";
 
		if(today.getDay()==3)  day="������";
 
		if(today.getDay()==4)  day="������";
 
		if(today.getDay()==5)  day="������";
 
		if(today.getDay()==6)  day="������";
  				    
		date=(today.getYear())+"��"+(today.getMonth()+1)+"��";                                
		date1=today.getDate();      
		document.write(""+"<div align=center><span style='font-family: ����;font-size: 9pt;color:#FF6600;'>"+date+"</font></span><br>");                              
		document.write("<B>"+"<span style='font-family: ����;font-size:16pt;color:#009933;'>"+date1+"</font></span></B><br>");
		document.write(""+"<span style='font-family: ����;font-size: 9pt;color:#FF6600;'>"+day+"</font></span></div>");			
	}
		
		
 //�����һ���������ĳ����Ƿ���
 function checkLen(obj,iLen,desc){
	if(getStrLen(obj.value)>iLen){
		alert( "��"+desc + "�����Ȳ��ܳ���" + iLen +"�����ֽ�,ÿ������Ϊ�����ֽڣ�");
		obj.select();
		return false;
	}
	return true;
}


//�����㵽ָ�ⴰ��
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
//��������
 	function listCalendar() {
		var today=new Date();var day=new Array("������","����һ","���ڶ�","������","������","������","������"); 
		document.write(""+(today.getYear())+"��"+(today.getMonth()+1)+"��"+"");
		document.write( ""+ today.getDate() +"�� "+""+day[today.getDay()]+""+"");
		document.write("<span id=spanTime></span>");					
		clock();
	}	 
	
//ʱ��				
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
//Сдת��д
	function LowToUpp()
	{
		if((window.event.keyCode<123)&&(window.event.keyCode>96))
			window.event.keyCode=window.event.keyCode-32;			
	}

//��дת��Сд	
	function UppToLow()
	{
		if((window.event.keyCode<91)&&(window.event.keyCode>64))
			window.event.keyCode=window.event.keyCode+32;			
	}
	

//ɾ���ַ����еĿո�
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