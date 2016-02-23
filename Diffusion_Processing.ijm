run("Close All");
setBatchMode(true);
dir = "/Volumes/HDD3_PRO/PHD/Imperial/Data/Microscopy/2015/Diffusion/2D/E20160217/E20160217/";
dirdir="/Volumes/HDD3_PRO/PHD/Imperial/Data/Microscopy/2015/Diffusion/2D/E20160217/";
list = getFileList(dir);
times=49;
zs=5;
mosaics=10;
scenes=21;
channs=2;

	
print(list.length);
count=0;
x="0";
y="0";
zz="0";
for(ch=0;ch<=1;ch=ch+1){
scene=1;		
		if(ch==0){
			channel="GFP";
			start=0;
			}
		if(ch==1){
			channel="TOM";
			start=mosaics;
		//waitForUser;	
			}


	
	for(s=start;s<scenes*times*zs*mosaics*channs-start;s=s+times*zs*mosaics*channs){
	
	if (scene < 10){
				x = "0";
				}
				else{
					x = "";
				}
		time=1;
		finame="Scene_"+x+scene;
		dirname=dirdir+"zBestFocus"+"/";
		File.makeDirectory(dirname);
		
		for(t=0;t<times*zs*mosaics*channs;t=t+zs*mosaics*channs){
		if (time < 10){
					y = "0";
				}else{
					y = "";
					}
		mosaic=1;
			for(m=0;m<mosaics;m++){					
					
				for(z=0;z<=channs*mosaics*zs-1;z=z+mosaics*channs){
				if (mosaic < 10){
						zz = "0";
								}else{
						zz = "";
						}	
			//	open(list[(z+m)+t+s]);
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
			run("Gaussian Blur...", "sigma=10 stack");
			//waitForUser;
			//run("Z Project...", "projection=[Median]");
			makeRectangle(190, 190, 157, 157);
			run("Find focused slices", "select=99.999 variance=0.0 edge");
			selectWindow(stackname);
			close();
			//waitForUser;
				mosaic=mosaic+1;	
				
			}	
		timestack="Stack_"+time;
	 	print("time="+time);
		run("Images to Stack","method=[Copy (center)] name=[&timestack] title=Fo");	
		filname=finame+"_"+"time_"+y+time+"_";
	    run("Image Sequence... ", "format=TIFF name=[&filname] start=1 digits=4 save=[&dirname]");		
		selectWindow(timestack);
		close();				
		gridname=filname+"00{ii}.tif";
		run("Grid/Collection stitching", "type=[Grid: row-by-row] order=[Right & Down                ] grid_size_x=1 grid_size_y=[&mosaics] tile_overlap=7 first_file_index_i=1 directory=[&dirname] file_names=[&gridname] output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 display_fusion computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");			
		finalname=dirname+filname+channel+".tif";
		run("Save", "save=[&finalname]");
		close();
		time=time+1;
		
		//waitForUser;
		}
	scene=scene+1;
	
	}
}	
print(count);
print("helo");
