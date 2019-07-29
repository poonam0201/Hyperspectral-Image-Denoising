
function cpsnr=myPSNRcal(org,recon,skip)

org=org(skip+1:end-skip,skip+1:end-skip,:);
recon=recon(skip+1:end-skip,skip+1:end-skip,:);
[m, n,~]=size(org);
if (strcmp(class(org),'double') && strcmp(class(recon),'double'))
    
    %this is the sum of square error for each band
    sse=sum(sum((org-recon).^2));   
    mse=sse./(m*n);  %mean square error of each band.
    rmse=sqrt(sum(mse)/numel(mse)); 
    maxval=max( max(abs(org(:))),max(abs(recon(:))));
    
    cpsnr=20*log10(maxval/rmse);
else
    disp('Data type should be double with values 0 to 255');
end
end

%%
