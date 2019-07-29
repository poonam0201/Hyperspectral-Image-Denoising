%% Load Image
 clc;
clear all;

load('Indian_pines.mat');
img=double(indian_pines);

%load('urban.mat');
%img1=double(img1);
 %img=double(img1(1:256,1:256,[1:102 111:137 153:202]));
 [m,n,dim]=size(img);
 for i=1:dim 
 img(:,:,i)=mat2gray(img(:,:,i));
 end
 img1=img;
 figure,imshow(img1(:,:,200),[],'border','tight');title('Original Image');
 %img=reshape(img,[m*n,dim]);
 %figure,imshow(img,[],'border','tight');title('Reshaped Image');

%%
% diff algo      
% 1.FunGAP()  
%tic;        
%denoised1=FunGAP(noisy); %send to function for denoising
%toc;
%denois1=reshape(denoised1,[m,n,dim]);
%figure,imshow(denois1(:,:,100),[],'border','tight');title('Denoised GAP Image');

% 2.LRTV
y=reshape(img,m*n,dim);
sizex=[m,n];
mu=[.2 .2 .5]; iter=10;  % Iteration number
tic;
denoised2=funDenoising(y,sizex,mu,iter);
toc;
denois2=reshape(denoised2,[m,n,dim]);

 %psnrDenoised2=myPSNRcal(img1,denois2,1);
%figure,imshow(denois2(:,:,100),[],'border','tight');title('Denoised LRTV Image');
%%
% 3.SSTV
% lambda=.1; mu=.2; nu=.2; iter=40;
lambda=.01; mu=.02; nu=.02; iter=3; % iter=40; original
 tic;
  denoised3=funSSTV(img,iter,lambda,mu,nu);
 toc;
 denois3=reshape(denoised3,[m,n,dim]);
 %psnrDenoised3=myPSNRcal(img1,denois3,1);
%figure,imshow(denois3(:,:,100),[],'border','tight');title('Denoised SSTV Image');
%%
% 4. MyAlgo HSI
img=reshape(img,[m*n,dim]);
tic;
%denoised = denoiseHSI_temp(noisy,max_iter,lambda1,lambda2)
 %denoised4=denoiseHSI_temp(img,100,0.01,0.001);
  denoised4=den_newCode(img,2,6,0.001);
 toc;
 denois4=reshape(denoised4,[m,n,dim]);
 %psnrDenoised4=myPSNRcal(img1,denois4,1);
%figure,imshow(denois4(:,:,100),[],'border','tight');title('Denoised HSI Image');


%%

figure,
a = subplot(2,2,1); imshow(img1(:,:,164)); title('Original','FontSize',20);
b = subplot(2,2,2); imshow(denoised2(:,:,164)); title('LRTV','FontSize',20);
c = subplot(2,2,3);  imshow(denoised3(:,:,164));title('SSTV','FontSize',20);
d = subplot(2,2,4);  imshow(denois4(:,:,164));title('Proposed','FontSize',20);

 set(a,'Position',[0.1 0.52 0.3 0.44]);
 set(b,'Position',[0.45 0.52 0.3 0.44]);
 set(c,'Position',[0.1 0.02  0.3 0.44]);
 set(d,'Position',[0.45 0.02  0.3 0.44]);
%colormap  default

 
 %%
 %MY ALGO (check for diff values)
l1=linspace(50,250,20);
l2=0.001;
img=reshape(img,[m*n,dim]);
    for i=1:numel(l1)
    fprintf('\nL-1 Fidelity: %.6f , L-2 Fidelity: %.6f',l1(i),l2);
  
   denoised4=denoiseHSI_temp(img,100,l1(i),l2);
    denois4=reshape(denoised4,[m,n,dim]);
  
   figure,
a = subplot(2,2,1); imshow(img1(:,:,200)); title('Original');
b = subplot(2,2,2); imshow(denois2(:,:,200)); title('LRTV');
c = subplot(2,2,3);  imshow(denois3(:,:,200));title('SSTV');
d = subplot(2,2,4);  imshow(denois4(:,:,200));title('Proposed');

 set(a,'Position',[0.1 0.55 0.3 0.42]);
 set(b,'Position',[0.45 0.55 0.3 0.42]);
 set(c,'Position',[0.1 0.1  0.3 0.42]);
 set(d,'Position',[0.45 0.1  0.3 0.42]);
%colormap  default
    end



%%

% PSNR

psnrDenoised2=myPSNRcal(img1,denois2,1);
psnrDenoised3=myPSNRcal(img1,denois3,1);
psnrDenoised4=myPSNRcal(img1,denois4,1);
fprintf('\n Denoised image LRTV PSNR=%f dB \n',psnrDenoised2);
fprintf('\n Denoised image SSTV PSNR=%f dB \n',psnrDenoised3);
fprintf('\n Denoised image MYalgo HSI PSNR=%f dB \n',psnrDenoised4);

 
 
 
 %% SSIM

ssim2=ssim(denois2,img1);
ssim3=ssim(denois3,img1);
ssim4=ssim(denois4,img1);
fprintf('\n Denoised image LRTV SSIM=%f dB \n',ssim2);
fprintf('\n Denoised image SSTV SSIM=%f dB \n',ssim3);
fprintf('\n Denoised image MYalgo HSI SSIM=%f dB \n',ssim4);

