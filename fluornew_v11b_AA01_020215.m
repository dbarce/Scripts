%()

%Programa version Final
%estima el background por la moda del histograma, la senial estimada
%corresponde con the raw senial - ese background 
clear all
direc='zBestFocus';
%well=('C01')
%BIN=('BIN1')
ini=2;% horas despues de induccion
interv=1; %en fracciones centesimales de hora
%ref_GFP=imread('refe_GFP_10X.tif');
%ref_TOM=imread('refe_TOM_10x.tif');
%[tamx tamy]=size(ref_GFP);
tamx=1024;
tamy=1024;
binv=4;
bin=0:tamx/binv:tamx;
se90=strel('line',5,90);
se0=strel('line',5,0);
se90b=strel('line',10,90);
se0b=strel('line',10,0);
xbin=0:800;
xbin8=xbin/800;
cd(direc);
%dirilist=dir('*0*');
%leng=size(dirilist,1);

%for iiii=1:leng
%     if dirilist(iiii).isdir==1
%         cd(dirilist(iiii).name)
%     end
  filist=dir('*GFP.tif');
  filist2=dir('*TOM.tif');
  lentot=length(filist);
 scenelist=(dir('*t01m01_GFP.tif'));
 lenscene= length(scenelist);
 mosaiclist=(dir('*s01t01m*GFP.tif'));
 lenmos=length(mosaiclist);
timelist=(dir('*s01t*m01_GFP.tif'));
 lentime=length(timelist);
times=lentime;

%seg=input('Which Timepoint should serve as reference for segmentation? ');

for iiii = 0:lenscene-1
    
    for iii=0:lenmos-1
BW1=zeros(tamx,tamy);
BW2=zeros(tamx,tamy);
BW3=zeros(tamx,tamy);    
segi=lentime*lenmos*iiii+1+iii+lenmos*(seg-1)
imageseg=imread(filist(segi).name);
 image=wiener2(imageseg);
   image = adapthisteq(mat2gray(image),'Range','Original');
   yy=reshape(image,tamx*tamy,1);
   peaks=histc(yy,xbin8);
   pks=max(peaks);
   locs=find(peaks==pks);
   if locs(1)==800
       shift=0.36;
   else
       shift=xbin8(locs(1))+0.09+0.03*j/times;
   end
   BW1=im2bw(image,shift);
   BW1=imclearborder(BW1);
BW=BW1;%+BW2+BW3;

%so that the complementary BW is truly complementary
BW=im2bw(BW,0.9);
BW=bwareaopen(BW,200);
BW=imdilate(BW,[se90,se0]);   
BW=bwareaopen(1-BW,2000);
BW=imerode(1-BW,[se90,se0]);
BW=bwareaopen(BW,2000);

BW1=bwareaopen(BW,20);
BW1=imerode(1-BW1,[se90,se0]);
[labi,num]=bwlabel(BW1);

res=regionprops(labi,'Area','PixelList','Centroid'); 

    %for iii=1:lenmos:lentot
%    if dirlist(iii).isdir==1
%       cd(dirlist(iii).name);
%       cd
      clock
      %filelist1=dir('*GFP*m*.tif');
      %filelist2=dir('*PH*.tif');
      %filelist3=dir('*TOM*.tif');
%       times=size(filist,1);
%    end

M=zeros(times,5);
background_GFP=zeros(times,1);
background_TOM=zeros(times,1);
cyst=zeros(times,1);
M(:,1)=ini:interv:ini+((times-1)*interv);
dali=zeros(times,tamx,tamy);
dalitom=zeros(times,tamx,tamy);
ali=zeros(times,tamx,tamy);
clock

%for j=1:times
j=1;
    for jn= (lentime*lenmos*iiii+1+iii):lenmos:(lentime*lenmos*(iiii+1))
    strfil=filist(jn).name %looking for file with name depedent on jn
    j
    jn
    strfilsplt=strsplit(strfil,'_');
    filsplt1=char(strfilsplt(1));
    filsplt2=char(strfilsplt(2));
    filsplt3=char(strfilsplt(3));  
    filsplt4=char(strfilsplt(4));
    
     
    
     
%     %PH or brightfield
%    image=imread(filelist2(j).name);
%    image=mat2gray(image);
%    image = adapthisteq(image,'Range','Original');
%    yy=reshape(image,tamx*tamy,1);
%    peaks=histc(yy,xbin8);
%    pks=max(peaks);
%    locs=find(peaks==pks);
%    shift=xbin8(locs(1))+0.03;
%    BW=im2bw(image,shift);
%    BW2=imerode(BW,[se90,se0]);
%    BW2=imfill(BW2,'holes'); %extra fill holes 
%    BW2=imclearborder(BW2);

%GFP

   image=imread(filist(jn).name);
   %image=image./ref_GFP;
  
   %yy=reshape(image,tamx*tamy,1);
   %peaks=histc(yy,xbin);
   %pks=max(peaks);
   %locs=find(peaks==pks);
   %shiftb=xbin(locs(1)); 
   %background(j)=shiftb; 
   %image=image-background(j);
%    J_GFP(j,:) = entropy(image)
   dali(j,:,:)=image;
%    image=wiener2(image);
%    image = adapthisteq(mat2gray(image),'Range','Original');
%    yy=reshape(image,tamx*tamy,1);
%    peaks=histc(yy,xbin8);
%    pks=max(peaks);
%    locs=find(peaks==pks);
%    if locs(1)==800
%        shift=0.36;
%    else
%        shift=xbin8(locs(1))+0.09+0.03*j/times;
%    end
%    BW1=im2bw(image,shift);
%     BW1=imclearborder(BW1);
%     
   
  %TOMATO
while exist(strcat(filsplt1,'_',filsplt2,'_',filsplt3,'_','TOM.tif'),'file')
    strfilTOM=strcat(filsplt1,'_',filsplt2,'_',filsplt3,'_','TOM.tif');
  image=imread(strfilTOM);
%    image=image./ref_TOM;
  
   %yy=reshape(image,tamx*tamy,1);
   %peaks=histc(yy,xbin);
   %pks=max(peaks);
   %locs=find(peaks==pks);
   %shiftb=xbin(locs(1)); 
   %background(j)=shiftb; 
   %image=image-background(j);
%   J_TOM(j,:) = entropy(image) 
   dalitom(j,:,:)=image;
%    image=wiener2(image);
%    image = adapthisteq(mat2gray(image),'Range','Original');
%    yy=reshape(image,tamx*tamy,1);
%    peaks=histc(yy,xbin8);
%    pks=max(peaks);
%    locs=find(peaks==pks);
%    if locs(1)==801
%        shift=0.36;
%    else
%        shift=xbin8(locs(1))+0.09+0.03*j/times;
%    end
%    BW3=im2bw(image,shift);
%    BW3=imclearborder(BW3);
   break
end
%    BW=imdilate(BW,[se90,se0]);
%    BW=bwareaopen(BW,100);
%    BW=bwareaopen(1-BW,2000);
%    BW=1-BW;
%    BW=imfill(BW,'holes');

%    BW=imerode(BW,sed11);
%    BW2=bwareaopen(BW,500);
   
% BW=BW1;%+BW2+BW3;
% %so that the complementary BW is truly complementary
% BW=im2bw(BW,0.9);
% BW=bwareaopen(BW,200);
% BW=imdilate(BW,[se90,se0]);   
% BW=bwareaopen(1-BW,2000);
% BW=imerode(1-BW,[se90,se0]);
% BW=bwareaopen(BW,2000);
% 
% BW1=bwareaopen(BW,20);
% BW1=imerode(1-BW1,[se90,se0]);
% [labi,num]=bwlabel(BW1);
% 
% res=regionprops(labi,'Area','PixelList','Centroid'); 

%   para ir viendo como va la wea
% % 

% if mod(j,25)==0
% 
%    
% %figure('name',strcat(iii,'_GFP'));imshow(BW1);%GFP_Channel
% %figure('name','Brigthfield');imshow(BW2);%PH_Channel
% %figure('name','Tomato');imshow(BW3);%Tomato_Channel
% figure('name',strcat(iii,'Combine'));imshow(BW);%Combined
% %hold on
% pause
% end
%j;
shiftb_GFP=2600;
shiftb_TOM=2600;
for jk=1:num
   marea=res(jk).Area; 
   if marea>1000    
      vec=res(jk).PixelList;
      long=size(vec,1);
      veco=zeros(long,1);
      for it=1:long
         veco_GFP(it)=dali(j,vec(it,2),vec(it,1));
         veco_TOM(it)=dalitom(j,vec(it,2),vec(it,1));
      end
      q_GFP=quantile(veco_GFP,.05);
      q_TOM=quantile(veco_TOM,.05);

      if q_GFP < shiftb_GFP
         shiftb_GFP=q_GFP;
      end
      if q_TOM < shiftb_TOM
         shiftb_TOM=q_TOM;
      end  
   end
end



background_GFP(j)=shiftb_GFP;
background_TOM(j)=shiftb_TOM;



ali(j,:,:)=BW; %save cyst binary mask cysts=1 (cyst location)
j=j+1

    end
     
     
  %second part of the script  
    
clock
[lab,num]=bwlabeln(ali);
res=regionprops(lab,'Area');
h=1;
ll=zeros(num,1); %cyst label
for j=1:num
    if res(j).Area > 10000 %label cysts only if volume in time is higher than
    ll(h)=j;
    h=h+1;
    end
end
h=h-1;
media_GFP=zeros(h,times);
media_TOM=zeros(h,times);
sumtot_GFP=zeros(h,times);
sumtot_TOM=zeros(h,times);
sup=zeros(h,times);
correc=zeros(h,times);
correc_GFP=zeros(h,times);
correc_TOM=zeros(h,times);
maxarea=zeros(h,1);
partix=zeros(h,times);
partiy=zeros(h,times);
centx=zeros(h,times);
centy=zeros(h,times);
for j=1:times
[labxy,xy]=bwlabeln(ali(j,:,:));
resc=regionprops(labxy,'Centroid');

AA(:,:)=lab(j,:,:);
 %ii para los labels con regiones grandes 1:h
for ii=1:h

% centxy(j,ii,:,:,:)=resc(ii).Centroid;
[r, c]=find(AA==ll(ii)); %this looks for cysts in image
sla=size(r);
average_GFP=0;
average_TOM=0;
sdev=0;
area=0;
%pmatrix=zeros(tamx,tamy);
if sla(1)~=0
   for k=1:sla(1)
       average_GFP=average_GFP+dali(j,r(k),c(k));
       average_TOM=average_TOM+dalitom(j,r(k),c(k));
       %pmatrix(r(k),c(k))=1;
       area=area+1;
    end
%substract background
    average_GFP=average_GFP-area*background_GFP(j);
    average_TOM=average_TOM-area*background_TOM(j);
    if area>maxarea(ii)
       maxarea(ii)=area;
    end
    
%  centxy=regionprops(pmatrix,'Centroid');
%  centx(ii,j)=round(centxy.Centroid(1));
%  centy(ii,j)=round(centxy.Centroid(2));
 

%     for q = 1:binv
%     if centx(ii,j) > bin(q) && centx(ii,j) < bin(q+1)
%         partix(ii,j)=q;
%     end
%     if centy(ii,j) > bin(q) && centy(ii,j)< bin(q+1)
%         partiy(ii,j)=q;
%     end
%    end
 
%  cx(ii,j)=centx;
%  cy(ii,j)=centy;
  
    media_GFP(ii,j)=average_GFP/area;
    media_TOM(ii,j)=average_TOM/area;
    sumtot_GFP(ii,j)=average_GFP;
    sumtot_TOM(ii,j)=average_TOM;
    correc_GFP(ii,j)=background_GFP(j);
    correc_TOM(ii,j)=background_TOM(j);
    sup(ii,j)=area;
else
    media_GFP(ii,j)=0;
    media_TOM(ii,j)=0;
    sumtot_GFP(ii,j)=0;
    sumtot_TOM(ii,j)=0;
    correc_GFP(ii,j)=background_GFP(j);
    correc_TOM(ii,j)=background_TOM(j);
    sup(ii,j)=0;
end

end

end

for ii=1:h
M(:,2)=media_GFP(ii,:);
M(:,3)=sumtot_GFP(ii,:);
M(:,4)=correc_GFP(ii,:);
M(:,5)=media_TOM(ii,:);
M(:,6)=sumtot_TOM(ii,:);
M(:,7)=correc_TOM(ii,:);
M(:,8)=sup(ii,:,1);
%M(:,9)=centx(ii,:);
%M(:,10)=centy(ii,:);
%M(:,11)=partix(ii,:);
%M(:,12)=partiy(ii,:);


cleo=find(sup(ii,:)==0)
ss=size(cleo);
if ss(2)<1 %% AQUI IMPRIME EN FILE LOS CISTOS BUENOS
filename_of_responsive_cyst=strcat(strcat('11.final._scene_',int2str(iiii+1),'_mosaic_',int2str(iii+1),'_cyst_',int2str(ll(ii))),'.dat')
dlmwrite(filename_of_responsive_cyst, M);
end
end



    end
% figure('name',strcat('TOM_',dirlist(iii).name));
% for w = 1:ii
% plot(media_TOM(w,:));
% hold('on');
% end
% hold('off');
% 
% 
% figure('name',strcat('GFP_',dirlist(iii).name));
% for w = 1:ii   
% plot(media_GFP(w,:))
% hold('on');
% end
% pause
% cd ..

%dlmwrite('numcynt11.txt',cyst', '-append')
end
%end
cd ..
%end
cd ..






