%% Load Image
clc;
clear all;
close all;

 img=imread('dc.tif');                  % WDC
img=img(500:755,1:256,1:191);


%load('PaviaU.mat');                     %Pavia
%img=paviaU(100:355,1:256,1:103);                                        %carosati matrix (m*n*p to mn*p)

 img=double(img);
 [m,n,dim]=size(img);
 for i=1:dim 
 img(:,:,i)=mat2gray(img(:,:,i));
 end
 img1=img;
 %figure,imshow(img(:,:,100),[],'border','tight');title('Original Image');
 %img=reshape(img,[m*n,dim]);
 %figure,imshow(img,[],'border','tight');title('Noisy Image');

% again carosati matrix to normal form(mn*p to m*n*p)
% S=reshape(img,[m,n,dim]);
 %figure,imshow(S(:,:,100),[],'border','tight'); title('Original Image');

p = 0.005;
noisy=imnoise(img,'Gaussian',0,0.0005);
noisy = (noisy+ p*rand(size(noisy)))/(1+p);
noisy=reshape(noisy,[m,n,dim]);
%nois=reshape(noisy,[m,n,dim]);
psnrNoisy=myPSNRcal(img1,noisy,1);
figure,imshow(noisy(:,:,100),[],'border','tight');title('Noisy Image');
%%

% diff algo      
% 1.FunGAP()  
%tic;        
%denoised1=FunGAP(noisy); %send to function for denoising
%toc;
%denois1=reshape(denoised1,[m,n,dim]);
%figure,imshow(denois1(:,:,1),[],'border','tight');title('Denoised GAP Image');
%%
% 2.LRTV
y=reshape(noisy,m*n,dim);
sizex=[m,n];
mu=[.2 .2 .5]; iter=10;  % Iteration number
tic;
denoised2=funDenoising(y,sizex,mu,iter);
toc;
%denois2=reshape(denoised2,[m,n,dim]);
psnrDenoised2=myPSNRcal(img1,denoised2,1);
figure,imshow(denoised2(:,:,1),[],'border','tight');title('Denoised LRTV Image');
%%
% 3.SSTV
% lambda=.1; mu=.2; nu=.2; iter=40;
lambda=.01; mu=.02; nu=.02; 
%iter=40;    Original
iter=3;
 tic;
  denoised3=funSSTV(noisy,iter,lambda,mu,nu);
 toc;
 %denois3=reshape(denoised3,[m,n,dim]);
psnrDenoised3=myPSNRcal(img1,denoised3,1);
figure,imshow(denoised3(:,:,100),[],'border','tight');title('Denoised SSTV Image');
 %%
% 4. MyAlgo HSI
nois=reshape(noisy,[m*n,dim]);
tic;
%denoised = denoiseHSI_temp(noisy,max_iter,lambda1,lambda2)
 denois4=denoiseHSI_temp(nois,100,-0.0021, 0.0002);
 toc;
 denoised4=reshape(denois4,[m,n,dim]);
 psnrDenoised4=myPSNRcal(img1,denoised4,1);
figure,imshow(denoised4(:,:,100),[],'border','tight');title('Denoised HSI Image');
%%
% PSNR
psnrNoisy=myPSNRcal(img1,noisy,1);  %find noisy image psnr
%psnrDenoised1=myPSNRcal(img1,denois1,1); %find reconstructed image psnr
psnrDenoised2=myPSNRcal(img1,denoised2,1);
psnrDenoised3=myPSNRcal(img1,denoised3,1);
psnrDenoised4=myPSNRcal(img1,denoised4,1);
fprintf('\n    Noisy image new PSNR=%f dB',psnrNoisy);
%fprintf('\n Denoised image GAP PSNR=%f dB \n',psnrDenoised1);
fprintf('\n Denoised image LRTV PSNR=%f dB \n',psnrDenoised2);
fprintf('\n Denoised image SSTV PSNR=%f dB \n',psnrDenoised3);
fprintf('\n Denoised image MYalgo HSI PSNR=%f dB \n',psnrDenoised4);

%%
%figure,
%subplot(161); imshow(img1(:,:,1)); title('Original');
%subplot(162); imshow(nois(:,:,1));title('Noisy');
%subplot(163); imshow(denois1(:,:,1));title('GAP');
%subplot(164); imshow(denois2(:,:,1)); title('LRTV');
%subplot(165); imshow(denois3(:,:,1));title('SSTV');
%subplot(166); imshow(denois4(:,:,1));title('HSI');

%figure,
%a = subplot(3,3,2); imshow(img1(:,:,100)); title('Original');
%b = subplot(3,3,4);  imshow(denois1(:,:,1));title('GAP');
%b = subplot(3,3,4);  imshow(img1(:,:,100));title('oroginal');
%c = subplot(3,3,5);  imshow(denois2(:,:,100)); title('LRTV');
%d = subplot(3,3,8);  imshow(denois3(:,:,100));title('SSTV');
%e = subplot(3,3,9); imshow(denois4(:,:,100));title('HSI');
%f = subplot(3,3,7); imshow(nois(:,:,100));title('Noisy');

 %set(a,'Position',[0   0.6 0.3 0.3]);
 %set(b,'Position',[0.3 0.6 0.3 0.3]);
 %set(c,'Position',[0.6 0.6 0.3 0.3]);
 %set(d,'Position',[0.3 0.2 0.3 0.3]);
 %set(e,'Position',[0.6 0.2 0.3 0.3]);
 %set(f,'Position',[0 0.2 0.3 0.3]);


figure,
a = subplot(3,3,2); imshow(img1(:,:,100)); title('Original');
b = subplot(3,3,4);  imshow(noisy(:,:,100)); title('Noisy');
c = subplot(3,3,5); imshow(denoised2(:,:,100)); title('LRTV');
d = subplot(3,3,8);  imshow(denoised3(:,:,100));title('SSTV');
e = subplot(3,3,9);imshow(denoised4(:,:,100));title('Proposed');

 set(a,'Position',[0   0.6 0.3 0.3]);
 set(b,'Position',[0.3 0.6 0.3 0.3]);
 set(c,'Position',[0.6 0.6 0.3 0.3]);
 set(d,'Position',[0.2 0.2 0.3 0.3]);
 set(e,'Position',[0.5 0.2 0.3 0.3]);
