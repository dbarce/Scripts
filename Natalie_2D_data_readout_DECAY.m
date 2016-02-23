clear all
filist=dir('*_GFP.tif');
filist2=dir('*_TOM.tif');
times=length((dir('Scene_01*time*GFP.tif')));
scenes=length(dir('*time_01_GFP.tif'));
total=length(filist);

scenestart=1;
scenecount=scenestart;
scenestart=scenestart-1;

se=strel('square',10);
kref=0;

for k =1+times*scenestart:times:times*scenes
    
    timecount=1;
    imageref=imread(filist(k).name);
    imageref_t=imread(filist(k+kref).name);
%     pause
    GT=graythresh(imageref)
    
    if GT < 0.03
    GT=.0312   
    end
    
    BW=im2bw(imageref,GT);
    BW=imerode(BW,se);
    BW(:,all(~BW,1))=[];
    BW=imerode(BW,se);
    BW=wiener2(BW,[10 10]);
    [r1,c1]=find(BW==0,1);
    [r2,c2]=find(BW==1,1,'last');
    rs=[r1 r2];
    maxlenpaper=max(rs);
    
% % %     angle calc
    alpha = radtodeg(atan((r2-r1)/(c2-c1)))
    if abs(alpha) > 30
     sprintf(strcat('To much angle in this file=>',filist(k).name))
     alhpa=0;
    end
    ratio_alpha=cos(alpha);
%     alpha=0;
    startdis=maxlenpaper+10;    
    BWrot=imrotate(BW,alpha);
    
%     figure;imshow(BWrot);
%     hold on
%     line([0 1000],[startdis maxlenpaper])
%     hold off
%     title(strcat(filist(k).name,'  ','alpha ',int2str(alpha),'maxlenpaper ',int2str(maxlenpaper)));
%     pause
     
    res=regionprops(BWrot,'Area','PixelList');

    imagerefrot=imrotate(imageref_t,alpha);
         
    strfil2=filist(k).name;
    strfilsplt2=strsplit(strfil2,'_');
    filsplt01=char(strfilsplt2(1));
    filsplt02=char(strfilsplt2(2));
    filsplt03=char(strfilsplt2(3));
    filsplt04=char(strfilsplt2(4));
           
    
           if exist(strcat(filsplt01,'_',filsplt02,'_',filsplt03,'_',filsplt04,'_TOM.tif'),'file')
               imagetomref = imread(strcat(filsplt01,'_',filsplt02,'_',filsplt03,'_',filsplt04,'_TOM.tif'));
               imagetomrotref = imrotate(imagetomref,alpha);

           end
           
       
           for j = k:k+times-1
           image=imread(filist(j).name) ;
           imagerot=imrotate(image,alpha);
           imagerotsum=sum(imagerot~=0,2);
           [sizey sizex]=size(imagerot);
           imagefoldrot=double(imagerot)./double(imagerefrot);
          
           
           
           
           strfil=filist(j).name;
           strfilsplt=strsplit(strfil,'_');
           filsplt1=char(strfilsplt(1));
           filsplt2=char(strfilsplt(2));
           filsplt3=char(strfilsplt(3));
           filsplt4=char(strfilsplt(4));
           ymean=(zeros(length(startdis:sizey),1));
           yfoldmean=(zeros(length(startdis:sizey),1));
           
           parfor ii = startdis:sizey
               ymean(ii,:)=nansum(imagerot(ii,:))./imagerotsum(ii);
               yfoldmean(ii,:)=nansum(imagefoldrot(ii,:))./imagerotsum(ii);
           end
          
           ytfold(timecount,:)=yfoldmean;
           ytmean(timecount,:)=ymean;
           ytfold_0=ytfold(:,any(ytfold)); 
           ytmean_0=ytmean(:,any(ytmean));   
% ytnorm(timecount,:)=ytmean(timecount,:)./ytmean(1,:);
   
   
        if exist(strcat(filsplt1,'_',filsplt2,'_',filsplt3,'_',filsplt4,'_TOM.tif'),'file')
            imagetom = imread(strcat(filsplt1,'_',filsplt2,'_',filsplt3,'_',filsplt4,'_TOM.tif'));
            imagetomrot=imrotate(imagetom,alpha);
            imagetomrotsum=sum(imagetomrot~=0,2);
            ymean2=(zeros(length(startdis:sizey),1));
            yfoldmean2=(zeros(length(startdis:sizey),1));
            imagefoldtomrot=double(imagetomrot)./double(imagetomrotref);
            parfor i = startdis:sizey
                ymean2(i,:)=nansum(imagetomrot(i,:))./imagetomrotsum(i);
                yfoldmean2(i,:)=nansum(imagefoldtomrot(i,:))./imagetomrotsum(i);
            end
            ytfold2(timecount,:)=yfoldmean2;
            ytmean2(timecount,:)=ymean2;
            ytfold2_0=ytfold2(:,any(ytfold2));
            ytmean2_0=ytmean2(:,any(ytmean2));  
         
             end
           
       


    timecount=timecount+1;
     if mod(timecount,5)==0
         timecount
     end
        
  j      ;
           end

   filename2=strcat(filsplt1,'_mean_TOM_s',num2str(scenecount,'%02i'),'.csv');
   csvwrite(filename2, ytmean2_0);
   filename2_fold=strcat(filsplt1,'_fold_TOM_',num2str(scenecount,'%02i'),'.csv');
   csvwrite(filename2_fold, ytfold2_0);
   filename=strcat(filsplt1,'_mean_GFP_s',num2str(scenecount,'%02i'),'.csv');
   csvwrite(filename, ytmean_0);
   filename_fold=strcat(filsplt1,'_fold_GFP_s',num2str(scenecount,'%02i'),'.csv');
   csvwrite(filename_fold, ytfold_0); 

  
   % 
% %    Plotting
% %    
% %    figure;
% %    subplot(1,3,1);
% %    imagesc(ytmean);
% %    caxis([1000 5000]);
% %    colormap(parula);
% %    colorbar;
% %    freezeColors
% %    title(strcat('GFP Scene ',int2str(scenecount),' Absolute'));
% %    
% %    subplot(1,3,2);
% %    imagesc(ytfold);
% %    caxis([0 2])
% %    colormap(hsv)
% %    colorbar;
% %    title(strcat('GFP Scene ',int2str(scenecount),' Fold'));
% %    
% %    subplot(1,3,3);
% %    imagesc(log2(ytfold));
% %    caxis([-1 1])
% %    colormap(hsv)
% %    colorbar;
% %    title(strcat('GFP Scene ',int2str(scenecount),' log2Fold'));
% %  
% %    if exist('ytmean2')
% %        figure;
% %        subplot(1,3,1);
% %        imagesc(ytmean2);
% %        caxis([1000 5000]);
% %        colormap(parula);
% %        colorbar;
% %        freezeColors
% %        title(strcat('TOM Scene ',int2str(scenecount),' Absolute'));
% %        
% %        subplot(1,3,2);
% %        imagesc(ytfold2);
% %        caxis([0 2])
% %        colormap(hsv)
% %        colorbar;
% %        title(strcat('TOM Scene ',int2str(scenecount),' Fold'));
% %        
% %        subplot(1,3,3);
% %        imagesc(log2(ytfold2));
% %        caxis([-1 1])
% %        colormap(hsv)
% %        colorbar;
% %        title(strcat('TOM Scene ',int2str(scenecount),' log2Fold'));
% % 
% % 
% %    end


scenecount=scenecount+1
% pause
clear ytfold
clear ytfold2
clear ytmean
clear ytmean2
clear ytmean2_0
clear ytfold2_0
clear ytmean_0
clear ytfold_0
end