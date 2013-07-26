function checkDroit(ModsID,UserID,Work_Group,User_Group){
	var Work_Group="<%=Application("Work_Group")%>";
	var User_Group="<%=Application("User_Group")%>";
	var MNum,UNum,i,j,result

	var re1=eval("/(GP\\d{3})(?=\\:[^;]*"+ModsID+")/g")
	if(MN=Work_Group.match(re1)){
		MNum=MN.length
		//if(MN.length==1){
		//	str1=MN;
		//}else{
		//str1=""+MN.join("|")+""
		//str1=MN
		//}
	}
	else{
		MNum=0	
	}
	
	
	var re2=eval("/(GP\\d{3})(?=\\:[^;]*"+UserID+")/g")
	if(UN=User_Group.match(re2)){
		UNum=UN.length
	}
	else{
		UNum=0
	}
	
	
	
	if(MNum==0 || UNum==0){
		result=0;
	}
	else{
		result=0;
		for(i=0;i<=MNum-1;i++){
			for(j=0;j<=UNum-1;j++){
				if(MN[i]==UN[j]){
					result=1;
					break;
				}
			}
		}
	}
	//result:0没有权限；1有权限
	alert(result);
}


function tt(){
	alert("111");
}