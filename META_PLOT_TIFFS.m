% %%RUN THIS PART TO GET DATS
% direc='zBestFocus';
% 
% for iiii=1:14
%  cd(direc);
% clear profi;kk=1;
% try
% listc=ls(strcat('*scene_',num2str(iiii),'_mosaic*','*.dat'));
% catch err
% if(strcmp(err.identifier,'MATLAB:ls:OSError'))
% end
% end
% while true
% [token, listc]=strtok(listc);
% if isempty(token),  break;  end
% profi(kk,:,:)=importdata(token);
% kk=kk+1;
% end
%       
% 
%     finame=strcat('scene_',num2str(iiii,'%02d'),'.mat');
%   
%     %figure('name',dirilist(iiii).name)
%     %for jj=1:si
%     %hold on
% %listc(jj).name  ;     
% 
% %plot(profi(jj,:,2))
% %plot(profi(jj,:,5))
%     %end
%      cd ..
%     save(finame,'profi');
%     clear profi;
%     kk    
% end
% 




%%edited from checkcysts
clear all
matname=input('Which directory?  ','s');
matlist=dir(strcat(matname,'/*.mat'));
matlist(:).name
contname=input('Which file is the control -tet -HGF?  ','s');
len=length(matlist);
cd(matname);
load(contname);
proficontGFP=mean(profi(:,:,2));
proficontGFP=proficontGFP/proficontGFP(1);
%proficontGFP=[431.2673 431.2673 431.2673 431.2673 431.2673 431.2673 431.2673 431.2673 431.2673 431.2673 431.2673 431.2673 431.2673 431.2673 431.2673 431.2673 431.2673 431.2673 431.2673 431.2673];
proficontTOM=mean(profi(:,:,5));
proficontTOM=proficontTOM/proficontTOM(1);
clear profi;
colplots(1)=input('How many columns for the subplots?');
colplots(2)=input('How many rows for the subplots?');
figure('name','Norm 1) to t0 for each cyst 2)to average ratio of -/- at each T');

for iii=1:len
iii
    load(matlist(iii).name)
   % figure('name',strcat('TME:',well));
times=size(profi,2);
% 
% %%%%%%%%%normalization with min max of each timepoint per cyst
% ss=size(profi,1)
% %gnorm=zeros(ss,times);
% %tnorm=zeros(ss,times);
% for i=1:ss
% gnorm(i,:)=(profi(i,:,2)-min(profi(i,:,2)))/(max(profi(i,:,2))-min(profi(i,:,2)));
% tomnorm(i,:)=(profi(i,:,5)-min(profi(i,:,5)))/(max(profi(i,:,5))-min(profi(i,:,5)));
% end
% %%%%%%%%%

%%%%%%%%normalization individual cysts to mean t0 of all cysts
ss=size(profi,1);
gnorm=zeros(ss,times);
tnorm=zeros(ss,times);
for i=1:ss
gnorm(i,:)=(profi(i,:,2)/mean(profi(:,1,2)));
tomnorm(i,:)=(profi(i,:,5)/mean(profi(:,1,5)));
end
%%%%%%%%%


%%%%%%%%normalization individual cysts to timepoint0
%ss=size(profi,1);
%gnorm=zeros(ss,times);
%tnorm=zeros(ss,times);
gnorm2=zeros(ss,times);
tnorm2=zeros(ss,times);
% for i=1:ss
% gnorm2(i,:)= gnorm(i,:)./proficontGFP;
% tomnorm2(i,:)=tomnorm(i,:)./proficontTOM;
% end
% %%%%%%%%%
% 
% % %%%%%%%%normalization of normalized cysts to minimum of self
% % ss=size(profi,1);
% %gnorm=zeros(ss,times);
% %tnorm=zeros(ss,times);
for j=1:ss
gnorm2(j,:)=(gnorm(j,:)/mean(gnorm(:,1)));
tomnorm2(j,:)=(tomnorm(j,:)/mean(tomnorm(:,1)));
end
%%%%%%%%%

figure(1);
figure(2);
figure(3);
% 
subplot(colplots(2),colplots(1),iii);
% % % % % % % %scatterplots
c=jet;
jcolor=round(linspace(1,64,times));

for jjj=1:1:times
figure(1)
subplot(colplots(2),colplots(1),iii);
 cc(jjj,:)=c(jcolor(jjj),:);
 scatter(log2(gnorm2(:,jjj)),log2(tomnorm2(:,jjj)),10,cc(jjj,:),'filled');

hold on



% for ll= 1:2:ss
%plot(log2(gnorm(ll,1:4:times)),log2(tomnorm(ll,1:4:times)),'b')
%plot(log2(gnorm2(ll,:)));
% end
tit=strsplit(matlist(iii).name,'_');

title(char(tit(2)));
% pause
end
GFPmean=zeros(times);
TOMmean=zeros(times);
for jjj=1:1:times
 figure(1)
subplot(colplots(2),colplots(1),iii);
hold on
 GFPmean_gnorm=(mean(log2(gnorm2(:,jjj))));
 TOMmean_tomnorm=(mean(log2(tomnorm2(:,jjj))));
 GFPstd_gnorm=(std(log2(gnorm2(:,jjj))));
 TOMstd_tomnorm=(std(log2(tomnorm2(:,jjj))));

  scatter(GFPmean_gnorm,TOMmean_tomnorm,150,cc(jjj,:),'filled','o');
  
  plot([GFPmean_gnorm-GFPstd_gnorm GFPmean_gnorm+GFPstd_gnorm],[TOMmean_tomnorm TOMmean_tomnorm],'g','LineWidth',5);
  plot([GFPmean_gnorm GFPmean_gnorm],[TOMmean_tomnorm-TOMstd_tomnorm TOMmean_tomnorm+TOMstd_tomnorm],'r','LineWidth',5);
xlabel('GFP')
ylabel('TOM')

GFPmean(jjj)=(mean(nonzeros(profi(:,jjj,2))));
TOMmean(jjj)=(mean(nonzeros(profi(:,jjj,5))));

end
axis([-2 5 -2 5])
%   uistack(p1,'bottom');
%   uistack(p3,'top');
%   uistack(p4,'top');
%   pause
% % % % % % % %plot mean  
% 

figure(2)
h_mean_GFP(iii)=subplot(colplots(2),colplots(1),iii);
% h_mean_GFP(iii)
plot(GFPmean)
 axis([0 25 0 3000])
 xlabel('Time')
ylabel('GFP')
tit=strsplit(matlist(iii).name,'_');
title(char(tit(2)));
 figure(3)
h_mean_TOM(iii)=subplot(colplots(2),colplots(1),iii);
% h_mean_TOM(iii)
plot(TOMmean)
 axis([0 25 0 4000])
  xlabel('Time')
ylabel('TOM')
tit=strsplit(matlist(iii).name,'_');
title(char(tit(2)));
%plot dose response curves






 %xmin xmax ymin ymax
% axis([0 25 500 5000]) %xmin xmax ymin ymax

set(gca,'FontSize',14)
% gnorm2(:,1);

clear profi
clear gnorm
clear tomnorm
clear gnorm2
clear tomnorm2

end
img=repmat(uint8(0:255), 100, 1);
figure;imshow(img,'Colormap',cc(any(cc,2),:))
cd ..
