%Control maker
clear all
filist=dir('*mean_GFP*.csv');
% filist2=dir('*fold_TOM*.csv');
scenes=length(filist);
% times=length((dir('*GFP_s01*t*')));
% scenes=input('How many controls (-tet -HGF)?');
% profile=zeros(times,scenes);
% for j = 1:scenes
% cont(j)=input(strcat('Filename for control ',int2str(j)),'s');
% end
%importdata
maxlen=3740;
times=49;
win_smoo=450
levels=[5000 10000];

% profile_smoo=zeros(scenes,times,maxlen);

for k = 1:scenes
filist(k).name;
size(dlmread(filist(k).name))
profile(k,:,:)=dlmread(filist(k).name,',',[0 250 times-1 maxlen]);

%%SMOOOOOOOOOTHHHH
for i = 1:times
 profile_smoo(k,i,:)=smooth(squeeze(profile(k,i,:)),win_smoo);
 end




% oldratio=1;
% shifto=ytfold_0(1:1);
% 
% 
% for iii = 1:24
%     ratio(iii)=oldratio*shifto/ytfold_0(iii,1);
%     shifto=ytfold_0(iii,1);
%     oldratio=ratio(iii);
%     a(1)=shifto;
%     a(2)=oldratio;
% end
end


profmeancont=squeeze(profile(1,:,:)+profile(2,:,:)+(profile(3,:,:)+profile(4,:,:))+(profile(5,:,:)))./5;%+profile(6,:,:)))./6;
x=linspace(1,24,24);

%create reference data
% for iii = 1:3400
%    % figure
%     fittest=polyfit(x',profmeancont(:,iii),4);
%     p(:,iii)=polyval(fittest,x);
%    
% %     plot(profile(1,:,iii),'b')
% %     hold on
% %     plot(profile(2,:,iii),'r')
% %     plot(profmeancont(:,iii),'g');
% %     plot(p,'y')
%   
%     clear fittest
%     
% end

% pause

%correct data





for k = 1:scenes
profilecor(k,:,:)=squeeze(profile(k,:,:))-profmeancont;

end

binl=round(maxlen/5);
%plot data
figure;
for j=1:scenes
% 
    [m loc]=(max(squeeze(profile(j,:,:))));
    loc_fit=polyfit(1:length(loc),loc,2);
    loc_val=polyval(loc_fit,1:length(loc));


    subplot(4,6,j);
%     prof_choose=input(strcat('Which scene to plot on position ',int2str(j),': '));
   imagesc(squeeze(profile_smoo(j,:,:)));
   
   
%    imagesc(squeeze(profile_binl(j,:,:)));
   hold on
%    plot(loc,'-','Color','r');
    plot(loc_val,'-','Color','r');
     caxis(levels)
    %  caxis([-1 1])
   colormap(parula)
   colorbar;
  title(strcat('GFP Scene ',int2str(j),' Fold'));
   
%    subplot(4,6,j);
%   
%     imagesc(squeeze(profilecor((j),:,:)));
%      caxis([-150 1500])
% %    caxis([-.3 .3])
%     colormap(parula)
%    colorbar;
%     title(strcat('GFP Scene ',int2str(j),' Corr'));
   
end

