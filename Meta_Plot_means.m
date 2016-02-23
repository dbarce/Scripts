HGF_tet=[4 6 9 11 12];
HGF=[2 14 16 19 21];
tet=[5 10 13 17 18];
zero=[1 3 8 15 20];



% % % % % % %%average data 
% % -tet
%HGF+tet
profmean_HGF_tet=squeeze(mean(profile_smoo(HGF_tet,:,:),1));

%HGF
profmean_HGF=squeeze(mean(profile_smoo(HGF,:,:),1));

%tet
profmean_tet=squeeze(mean(profile_smoo(tet,:,:),1));

%zero
profmean_zero=squeeze(mean(profile_smoo(zero,:,:),1));


% % % % % % %%variance data E20160211

profvar_HGF_tet=squeeze(std(profile_smoo(HGF_tet,:,:),0,1));%./profmean_HGF_tet.^2;


%HGF
profvar_HGF=squeeze(std(profile_smoo(HGF,:,:),0,1));%./profmean_HGF;
%tet
profvar_tet=squeeze(std(profile_smoo(tet,:,:),0,1));%./profmean_tet;
%zero
profvar_zero=squeeze(std(profile_smoo(zero,:,:),0,1));%./profmean_zero;


levels =[mean(min(min(profile_smoo))) mean(max(max(profile_smoo)))];
levels_noise=[(mean(min(profvar_HGF_tet))) max(max(profvar_HGF_tet))];




%%%%%%%%%%%%%%%%%%%%%%%%%%plot the means 
figure;
subplot(2,2,1);
imagesc(profmean_zero);
caxis(levels);
title('-tet -HGF','FontSize',14);hold on
    [m loc]=(max(squeeze(profmean_zero)));
    loc_fit=polyfit(1:length(loc),loc,1);
    loc_val=polyval(loc_fit,1:length(loc));
% plot(loc,'-','Color','r');
    plot(loc_val,'-','Color','g');
clear loc_fit;clear loc_val;clear m;clear loc



subplot(2,2,2);
imagesc(profmean_tet);
caxis(levels);
title('+tet -HGF','FontSize',14);hold on
    [m loc]=(max(squeeze(profmean_tet)));
    loc_fit=polyfit(1:length(loc),loc,1);
    loc_val=polyval(loc_fit,1:length(loc));
% plot(loc,'-','Color','r');
    plot(loc_val,'-','Color','g');
clear loc_fit;clear loc_val;clear m;clear loc

subplot(2,2,3);
imagesc(profmean_HGF);
caxis(levels);
title('-tet +HGF','FontSize',14);hold on
    [m loc]=(max(squeeze(profmean_HGF)));
    loc_fit=polyfit(1:length(loc),loc,1);
    loc_val=polyval(loc_fit,1:length(loc));
% plot(loc,'-','Color','r');
plot(loc_val,'-','Color','g');
clear loc_fit;clear loc_val;clear m;clear loc

subplot(2,2,4);
imagesc(profmean_HGF_tet);
caxis(levels);
title('+tet +HGF','FontSize',14);hold on
    [m loc]=(max(squeeze(profmean_HGF_tet)));
    loc_fit=polyfit(1:length(loc),loc,1);
    loc_val=polyval(loc_fit,1:length(loc));
% plot(loc,'-','Color','r');
    plot(loc_val,'-','Color','g');
clear loc_fit;clear loc_val;clear m;clear loc


%%%%%%%%%%%%%%%%%%%%%%%plot variance
figure;
subplot(2,2,1);
imagesc(profvar_zero);
caxis(levels_noise);
title('-tet -HGF','FontSize',14);hold on
    [m loc]=(max(squeeze(profvar_zero)));
    loc_fit=polyfit(1:length(loc),loc,1);
    loc_val=polyval(loc_fit,1:length(loc));
% plot(loc,'-','Color','r');
%     plot(loc_val,'-','Color','g');
clear loc_fit;clear loc_val;clear m;clear loc



subplot(2,2,2);
imagesc(profvar_tet);
caxis(levels_noise);
title('+tet -HGF','FontSize',14);hold on
    [m loc]=(max(squeeze(profvar_tet)));
    loc_fit=polyfit(1:length(loc),loc,1);
    loc_val=polyval(loc_fit,1:length(loc));
% plot(loc,'-','Color','r');
%     plot(loc_val,'-','Color','g');
clear loc_fit;clear loc_val;clear m;clear loc

subplot(2,2,3);
imagesc(profvar_HGF);
caxis(levels_noise);
title('-tet +HGF','FontSize',14);hold on
    [m loc]=(max(squeeze(profvar_HGF)));
    loc_fit=polyfit(1:length(loc),loc,1);
    loc_val=polyval(loc_fit,1:length(loc));
% plot(loc,'-','Color','r');
% plot(loc_val,'-','Color','g');
clear loc_fit;clear loc_val;clear m;clear loc

subplot(2,2,4);
imagesc(profvar_HGF_tet);
caxis(levels_noise);
title('+tet +HGF','FontSize',14);hold on
    [m loc]=(max(squeeze(profvar_HGF_tet)));
    loc_fit=polyfit(1:length(loc),loc,1);
    loc_val=polyval(loc_fit,1:length(loc));
% plot(loc,'-','Color','r');
%     plot(loc_val,'-','Color','g');
clear loc_fit;clear loc_val;clear m;clear loc
    
    
    
    
    
%%%% calculate Gradient and plot contour + vector field    
%%1st Reduce dimensions
 [sizet sizex]=size(profmean_HGF);

 profmean_HGF_tet_res=imresize(profmean_HGF_tet,[sizet sizet]);
 [FX_HGF_tet,FY_HGF_tet]=gradient(profmean_HGF_tet_res(2:25,2:25));
 
 profmean_HGF_res=imresize(profmean_HGF,[sizet sizet]);
 [FX_HGF,FY_HGF]=gradient(profmean_HGF_res(2:25,2:25));
 
 profmean_tet_res=imresize(profmean_tet,[sizet sizet]);
 [FX_tet,FY_tet]=gradient(profmean_tet_res(2:25,2:25));
 
 profmean_zero_res=imresize(profmean_zero,[sizet sizet]);
 [FX_zero,FY_zero]=gradient(profmean_zero_res(2:25,2:25));
    

%%%%%%%PLOTS
figure;
subplot(2,2,1);
    contourf(profmean_zero_res(2:25,2:25));
    title('-tet -HGF','FontSize',14);hold on
    quiver(-FX_zero,-FY_zero,1.5,'LineWidth',1);
    colormap(hot);
    caxis(levels)
    set(gca,'YDir','reverse');

subplot(2,2,2);
    contourf(profmean_tet_res(2:25,2:25));
    title('+tet -HGF','FontSize',14);hold on
    quiver(-FX_tet,-FY_tet,1.5);
    colormap(hot);
    caxis(levels)
    set(gca,'YDir','reverse');

subplot(2,2,3);
    contourf(profmean_HGF_res(2:25,2:25));
    title('-tet +HGF','FontSize',14);hold on
    quiver(-FX_HGF,-FY_HGF,1.5);
    colormap(hot);
    caxis(levels)
    set(gca,'YDir','reverse');

subplot(2,2,4);
    contourf(profmean_HGF_tet_res(2:25,2:25));
    title('+tet +HGF','FontSize',14);hold on
    quiver(-FX_HGF_tet,-FY_HGF_tet,1.5);
    colormap(hot);
    caxis(levels)
    set(gca,'YDir','reverse');
 
 break    
    
    
    
    
    

% %%plot snr
% %calculate
% snrmat=zeros(24,24,3000);
% for jj=1:24
% for j = 1:24
% parfor k=1:3000
% 
%     snrmat(jj,j,k)=snr(profmean_tet(j,k),squeeze(profilecor(jj,j,k)));
% 
% end
% end
% end
% 
% 
% %plot
% figure;
% for j=1:scenes
% % 
% %     subplot(4,6,j);
% %     prof_choose=input(strcat('Which scene to plot on position ',int2str(j),': '));
% %    imagesc(squeeze(profile(prof_choose,:,:)));
% %     caxis([1500 2000])
% %    %    caxis([0.5 1.5])
% %    colormap(parula)
% %    colorbar;
% %   title(strcat('GFP Scene ',int2str(j),' Fold'));
% %    
%     [m loc]=(max(squeeze(snrmat(j,:,:))));
%     loc_fit=polyfit(1:length(loc),loc,1);
%     loc_val=polyval(loc_fit,1:length(loc));
%     
%     subplot(4,6,j);
%      
%     imagesc(squeeze(snrmat(j,:,:)));
%     hold on
%     
%     
%     plot(loc,'-','Color','r');
%     plot(loc_val,'-','Color','g');
%     caxis([-30 70])
% %    caxis([-.3 .3])
%     colormap(parula)
%    colorbar;
%     title(strcat('Q5+tet vs. scene ',int2str(j),'SNR'),'FontSize',14);
%    j
% end
% 
% 
% 
% 
% %%Mutual information Copyright (c) 2015, Generoso Giangregorio
% 
% X=profmean_Q5-min(profmean_Q5(:))+1;
% Y=profmean_Q5-min(profmean_Q5(:))+1;
% 
% 
% matAB(:,1) = X(:);
% matAB(:,2) = Y(:);
% matAB = int32(matAB);
% 
% h = accumarray(matAB, 1); % joint histogram
% 
% hn = h./sum(h(:)); % normalized joint histogram
% y_marg=sum(hn,1); 
% x_marg=sum(hn,2);
% 
% Hy = - sum(y_marg.*log2(y_marg + (y_marg == 0))); % Entropy of Y
% Hx = - sum(x_marg.*log2(x_marg + (x_marg == 0))); % Entropy of X
% 
% arg_xy2 = hn.*(log2(hn+(hn==0)));
% h_xy = sum(-arg_xy2(:)); % joint entropy
% M = Hx + Hy - h_xy;

