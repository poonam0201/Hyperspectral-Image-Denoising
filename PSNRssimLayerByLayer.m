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
 
 
 
 %% load all files
% noise pavia with casorati
load('noisy.mat');
load('lrtv.mat');
load('sstv.mat');
load('hsi.mat');

%%
ps1=myPSNRcal(img1,noisy,1);
ps2=myPSNRcal(img1,denoised2,1);
ps3=myPSNRcal(img1,denoised3,1);
ps4=myPSNRcal(img1,denoised4,1);
%%
%values=zeros(dim,2)
sum=0;
 for i=1:dim 
  ps(:,:,i)=myPSNRcal(img1(:,:,i),noisy(:,:,i),1); %noisy
  %ps(:,:,i)=myPSNRcal(img1(:,:,i),denoised2(:,:,i),1); %lrtv
   %ps(:,:,i)=myPSNRcal(img1(:,:,i),denoised3(:,:,i),1); %sstv
   %ps(:,:,i)=myPSNRcal(img1(:,:,i),denoised4(:,:,i),1); %hsi

   band(i)=i;
   psnr(i)=ps(:,:,i);
   sum=sum+psnr(i);
  
   %fprintf('\n    PSNR of band %f is %f dB ', i  , ps(:,:,i));
 end
 bandv=band.';
 psnrv=psnr.';
 combine=[bandv,psnrv];
 xlswrite('noisyPSNR.xlsx',combine);
 avg=sum/dim;
fprintf('\n    avg PSNR is %f dB \n' ,  avg);

plot(bandv,psnrv);
plot(bandv,psnrv);


%%
% SSIM
% direct calculated SSIM

load('noisy.mat');
load('lrtv.mat');
load('sstv.mat');
load('hsi.mat');
%%
ssim1=ssim(noisy,img1);
ssim2=ssim(denoised2,img1);
ssim3=ssim(denoised3,img1);
ssim4=ssim(denoised4,img1);
%%
%layer by layer SSIM
sum=0;
 for i=1:dim 
   %ps(:,:,i)=ssim(img1(:,:,i),noisy(:,:,i)); %noisy
  % ps(:,:,i)=ssim(img1(:,:,i),denoised2(:,:,i)); %lrtv
   %ps(:,:,i)=ssim(img1(:,:,i),denoised3(:,:,i)); %sstv
   ps(:,:,i)=ssim(img1(:,:,i),denoised4(:,:,i)); %hsi

   BAND(i)=i;
   SSIM(i)=ps(:,:,i);
   sum=sum+SSIM(i);
  
   fprintf('\n    SSIM of band %f is %f dB ', i  , ps(:,:,i));
 end
 bandv=BAND.';
 SSIMv=SSIM.';
 combine=[bandv,SSIMv];
 xlswrite('hsiSSIM.xlsx',combine);
 avg=sum/dim;
fprintf('\n    avg SSIM is %f dB \n' ,  avg);



