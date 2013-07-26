function check_length(id,desc,length,lm)
{
	var obj=document.all[id]
	if(obj==null)
	{
		alert("无法找到"+desc+"!")
		return 0
	}
	var value=obj.value
	String.prototype.Trim=function(){return this.replace(/(^\s*)|(\s*$)/g,"");}
	value=value.Trim()
	//下拉框
	if(value.length==0&&length==null)
	{
		alert("请您选择"+desc+"！")
		return 0
	}
	if(typeof(length)=="number")
	{
		var len=value.replace(/[^\x00-\xff]/g,"**").length
		if(len>length)
		{
			alert(desc+"的长度不能大于"+length+"个字节(一个汉字为2字节)！")
			return 0
		}
		if(typeof(lm)=="number")
		{
			if(len==0)
			{
				alert("请您填写"+desc+"！")
				return 0
			}
			if(len<lm)
			{
				alert(desc+"的长度不能小于"+lm+"个字节(一个汉字为2字节)！")
				return 0
			}												
		}
	}
	return 1
}