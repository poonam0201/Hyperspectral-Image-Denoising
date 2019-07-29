%% load
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
 

 %% SD
%   Difference in spectral  Vs Band number

load('noisy.mat');
load('lrtv.mat');
load('sstv.mat');
load('hsi.mat');
dlrtv=zeros(dim,1);
dsstv=zeros(dim,1);
dhsi=zeros(dim,1);
org=zeros(dim,1);
lrtv=zeros(dim,1);
sstv=zeros(dim,1);
hsi1=zeros(dim,1);
bnd = xlsread('hsiPSNR.xlsx'); % to read only band number
for i=1:dim
   
    org(i)=img1(50,96,i);
    lrtv(i)=denoised2(50,96,i);
    sstv(i)=denoised3(50,96,i);
    hsi1(i)=denoised4(50,96,i);
    
end
for i=1:dim
    %dlrtv(i)=abs(org(i)-lrtv(i));
    dlrtv(i)=org(i)-lrtv(i);
    dsstv(i)=org(i)-sstv(i);
    dhsi(i)=org(i)-hsi1(i);
end

figure
subplot(3,1,1);
plot(bnd(:,1),dhsi(:,1),'r','LineWidth',1.2);
title('Proposed','FontSize',13)
axis([ 0 200 -0.2 0.2])
%xlabel('Band number','FontSize',14)
%ylabel('Difference in spectral','FontSize',14)

%hold on

subplot(3,1,2);
plot(bnd(:,1),dlrtv(:,1),'b','LineWidth',1.2);
title('LRTV','FontSize',13)
axis([ 0 200 -0.2 0.2])
subplot(3,1,3);
plot(bnd(:,1),dsstv(:,1),'g','LineWidth',1.2);
title('SSTV','FontSize',13)
axis([ 0 200 -0.2 0.2])
%legend('HSI' ,'LRTV', 'SSTV')
%hold off



%% DN


%  Digital number(pixel value) Vs Band number

org=zeros(dim,1);
lrtv=zeros(dim,1);
sstv=zeros(dim,1);
hsi1=zeros(dim,1);
bnd = xlsread('hsiPSNR.xlsx'); % to read only band number
for i=1:dim
    org(i)=img1(50,96,i);
    lrtv(i)=denoised2(50,96,i);
    sstv(i)=denoised3(50,96,i);
    hsi1(i)=denoised4(50,96,i);
    
end

plot(bnd(:,1),org,'k','LineWidth',1.2);  %% for diff colour k,c,m,b,r,g,y,w
%axis([ 0 200 0 0.5])
xlabel('Band number','FontSize',14)
ylabel('Digital number','FontSize',14)

hold on
plot(bnd(:,1),lrtv,'b','LineWidth',1.2);
plot(bnd(:,1),sstv,'g','LineWidth',1.2);
plot(bnd(:,1),hsi1,'r','LineWidth',1.2);
legend('Original' ,'LRTV', 'SSTV','HSI')

hold off


%%
%PSNR Vs Band number
%clc;
%clear;
hsi = xlsread('hsiPSNR.xlsx');
lrtv=xlsread('lrtvPSNR.xlsx');
sstv=xlsread('sstvPSNR.xlsx');

plot(hsi(:,1),hsi(:,2),'r','LineWidth',1.2);
%axis([ 0 200 10 40])
xlabel('Band number','FontSize',14)
ylabel('PSNR','FontSize',14)

hold on
plot(lrtv(:,1),lrtv(:,2),'b','LineWidth',1.2);
plot(sstv(:,1),sstv(:,2),'g','LineWidth',1.2);
legend('HSI' ,'LRTV', 'SSTV')
hold off

%%
%SSIM Vs Band number
%clc;
%clear;
hsi = xlsread('hsiSSIM.xlsx');
lrtv=xlsread('lrtvSSIM.xlsx');
sstv=xlsread('sstvSSIM.xlsx');

plot(hsi(:,1),hsi(:,2),'r','LineWidth',1.2);
%axis([ 0 200 0 1])
xlabel('Band number','FontSize',14)
ylabel('SSIM','FontSize',14)

hold on
plot(lrtv(:,1),lrtv(:,2),'b','LineWidth',1.2);
plot(sstv(:,1),sstv(:,2),'g','LineWidth',1.2);
legend('HSI' ,'LRTV', 'SSTV')
hold off







%%
%  to check which is best  Difference in spectral  Vs Band number

load('noisy.mat');
load('lrtv.mat');
load('sstv.mat');
load('hsi.mat');
dlrtv=zeros(dim,100);
dsstv=zeros(dim,100);
dhsi=zeros(dim,100);
org=zeros(dim,100);
lrtv=zeros(dim,100);
sstv=zeros(dim,100);
hsi1=zeros(dim,100);
bnd = xlsread('hsiPSNR.xlsx'); % to read only band number
for i=1:dim
    for j= 1:100
       
    org(i,j)=img1(50,j,i);
    lrtv(i,j)=denoised2(50,j,i);
    sstv(i,j)=denoised3(50,j,i);
    hsi1(i,j)=denoised4(50,j,i);
        
    end
    
end

for i=1:dim
    for j= 1:100
    %dlrtv(i)=abs(org(i)-lrtv(i));
    dlrtv(i,j)=org(i,j)-lrtv(i,j);
    dsstv(i,j)=org(i,j)-sstv(i,j);
    dhsi(i,j)=org(i,j)-hsi1(i,j);
    end
end

for i=1:100
    
figure
subplot(3,1,1);
plot(bnd(:,1),dhsi(:,i),'r','LineWidth',1.2);
title('HSI','FontSize',15)
axis([ 0 200 -0.2 0.2])
%xlabel('Band number','FontSize',14)
%ylabel('Difference in spectral','FontSize',14)

%hold on

subplot(3,1,2);
plot(bnd(:,1),dlrtv(:,i),'b','LineWidth',1.2);
title('LRTV','FontSize',14)
axis([ 0 200 -0.2 0.2])
subplot(3,1,3);
plot(bnd(:,1),dsstv(:,i),'g','LineWidth',1.2);
title('SSTV','FontSize',14)
axis([ 0 200 -0.2 0.2])
%legend('HSI' ,'LRTV', 'SSTV')
%hold off

end

 

%%
figure,
a = subplot(3,3,2); imshow(img(:,:,100)); title('original');
b = subplot(3,3,4);  imshow(noisy(:,:,100)); title('Noisy');
c = subplot(3,3,5); imshow(denoised2(:,:,100)); title('LRTV');
d = subplot(3,3,8);  imshow(denoised3(:,:,100));title('SSTV');
e = subplot(3,3,9);imshow(denoised4(:,:,100));title('HSI');

 set(a,'Position',[0   0.6 0.3 0.3]);
 set(b,'Position',[0.3 0.6 0.3 0.3]);
 set(c,'Position',[0.6 0.6 0.3 0.3]);
 set(d,'Position',[0.2 0.2 0.3 0.3]);
 set(e,'Position',[0.5 0.2 0.3 0.3]);




