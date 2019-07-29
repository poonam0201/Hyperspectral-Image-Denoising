clc;
clear all;
close all;

 img=imread('dc.tif');                  % WDC
img=img(500:755,1:256,1:191);


%load('PaviaU.mat');                     %Pavia
%img=paviaU(100:355,1:256,1:103);                                        
 img=double(img);
 [m,n,dim]=size(img);
 for i=1:dim 
 img(:,:,i)=mat2gray(img(:,:,i));
 end


noisy=imnoise(img,'Gaussian',0,0.0005);
%s=var(img(:));
%n =var(noisy(:));

SNR=snr(img(:),noisy(:));

%SNR=10*log10(s./g);

%%

varI = std2(I)^2;
SNRdB = 5:5:30;
for i=1:numel(SNRdB)
  sigma_noise = sqrt(varI/10^(SNRdB(i)/10));
  N = sigma_noise*randn(size(I));
  IN1 = I+N; % using randn
  IN2 = imnoise(I, 'Gaussian', 0, sigma_noise^2); % using imnoise
  imshow([IN1 IN2])
  title(['SNR = ' int2str(SNRdB(i)) 'dB' ...
    ', \sigma_{noise} = ' num2str(sigma_noise)]);
  disp('Press any key to proceed')
  pause
end