function check_length(id,desc,length,lm)
{
	var obj=document.all[id]
	if(obj==null)
	{
		alert("�޷��ҵ�"+desc+"!")
		return 0
	}
	var value=obj.value
	String.prototype.Trim=function(){return this.replace(/(^\s*)|(\s*$)/g,"");}
	value=value.Trim()
	//������
	if(value.length==0&&length==null)
	{
		alert("����ѡ��"+desc+"��")
		return 0
	}
	if(typeof(length)=="number")
	{
		var len=value.replace(/[^\x00-\xff]/g,"**").length
		if(len>length)
		{
			alert(desc+"�ĳ��Ȳ��ܴ���"+length+"���ֽ�(һ������Ϊ2�ֽ�)��")
			return 0
		}
		if(typeof(lm)=="number")
		{
			if(len==0)
			{
				alert("������д"+desc+"��")
				return 0
			}
			if(len<lm)
			{
				alert(desc+"�ĳ��Ȳ���С��"+lm+"���ֽ�(һ������Ϊ2�ֽ�)��")
				return 0
			}												
		}
	}
	return 1
}