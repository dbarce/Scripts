run("Close All");
setBatchMode(true);
dir = "/Volumes/HDD3_PRO/PHD/Imperial/Data/Microscopy/2015/Differentials/E20160221/E20160221/";
dirdir="/Volumes/HDD3_PRO/PHD/Imperial/Data/Microscopy/2015/Differentials/E20160221/"
list = getFileList(dir);
times=24;
scenes=11;
zs=3;
mosaics=16;
channs=2;



print(list.length);
count =0;
for(ch=0;ch<=1;ch=ch+1){
		
		if(ch==0){
			channel="GFP";
			start=0;
			}
		if(ch==1){
			channel="TOM";
			start=mosaics;
		//waitForUser;	
			}
			scene=1;
	for(s=start;s<scenes*times*zs*mosaics*channs-start;s=s+times*zs*mosaics*channs){
		if (scene < 10){
					x = "0";
				}
				else{
					x = "";
					}
		finame="Scene_"+x+scene;
		dirname=dirdir+"zBestFocus"+"/";
		File.makeDirectory(dirname);				
		mosaic=1;	
		
			for(m=0;m<mosaics;m++){					
			
				if (mosaic < 10){
					zz = "0";
				}else{
					zz = "";
					}
				time=1;
				for(t=0;t<times*zs*mosaics*channs;t=t+zs*mosaics*channs){			
					if (time < 10){
					y = "0";
					}else{
					y = "";
					}
					
					for(z=0;z<=channs*mosaics*zs-1;z=z+mosaics*channs){
					
					print("z="+z);
					print("m="+m);
					print("t="+t);
					print("s="+s);
					print("ch="+ch);
					print("all="+(z+m+t+s));
					print(list[z+m+t+s]);	
					open(list[(z+m)+t+s]);	
					count = count + 1;
					}
				print("count="+count);	
				stackname="Stack_"+m;
				run("Images to Stack", "name=[&stackname] title=E2016 use");
				//run("Z Project...", "projection=[Average Intensity]");
				run("Find focused slices", "select=99.99 variance=0.0 edge");
				//waitForUser;
				selectWindow(stackname);
				close();

				
				

					filname=dirname+finame+"_s"+x+scene+"t"+y+time+"m"+zz+mosaic+"_"+channel+".tif";
				//filname=dirname+finame+"_s"+scene+"t"+time+"m"+mosaic+"_"+channel+".tif";
		   		print("filname="+filname);
				run("Save", "save=[&filname]");
				close();
				time=time+1;
				}
					
			//timestack="Stack_"+time;
		 	//print("time="+time);
			//run("Images to Stack","method=[Copy (center)] name=[&timestack] title=MED use");	
			//filname=finame+"m"+mosaic+"_"+channel+"_";
		   // print("filname="+filname);
		    
		   	//run("Image Sequence... ", "format=TIFF name=[&filname] start=1 digits=4 save=[&dirname]");		
			//selectWindow(timestack);
			//close();
			mosaic=mosaic+1;
			}
		
	  
scene=scene+1;
	}

}
print(count);
print("Done! Hurray!");
