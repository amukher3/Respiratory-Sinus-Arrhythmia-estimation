 % Efficient auditory coding using sparse approximation and gradient
% learning...
clear all
close all
[x0,fs]=audioread('a.wav');          %audio is read...
x=x0(:,1);
[P,Q]=rat(16e3/fs);                    % two coeffiecients are found to be used for resampling...
y=resample(x,P,Q);                    % audio is resampled to 16kHz...
fs=16e3;                                   % number of samples per second=16k....
N=1000;                                     %size of kernel....
eta=1;                                       % step size of gradient ascent it can be changed...
L=100;                                  % initial kernel size...
P=10;
Li=L*ones(16,1);
LPadi=P*ones(16,1);
RPadi=P*ones(16,1);
t=[0:1/fs:(N-1)/fs];                  % vector of time axis...
idict=randn([L 16]);           % random gaussian noise kernels with size 8/10 of the total size...
kernels=[zeros((N/2)-(L/2),16);idict;zeros((N/2)-(L/2),16)];
y=normc(y);                           %input signal is normalized...
kernels=normc(kernels);                     % kernels are normalized...
rdict=kernels;                                % another copy of the inital kernels are made(for experimental purpose)...
mpdict=sparse(N,N*16);          % a sparse redundant basis dictionary is created without the kernels...
r0=zeros(N,16);                        % an initial zero residual matrix is created...


% loop to initialize the basis dictionary...
for i=1:16                          
    mpdict(:,1+((i-1)*N):(i*N))=toeplitz(kernels(:,i));  % the dictionary is intialized with the toeplitz matrices of the kernel functions...
end
%The main loop in which encoding and learning is performed. 
for itrm=1:2
totcoeff=sparse(length(y),16);% vector storing the spike encoding of signals
resi=zeros(length(y)+L+(2*P)+10,1);%vector storing the residuals

for itr=1:(length(y)/N)         % loop runs from 1 to total length of the signal with a step size equal to the size of the kernel...
    
        y0=y(1+((itr-1)*N):itr*N);                  % an audio data segment equal to the size of the kernel is selected...
        [yfit,r,coeff,iopt]=wmpalg('BMP',y0,mpdict,'maxerr',{'L1',30});         % matching pursuit is performed...
    
        for j=1:length(iopt)     
            tshift=mod(iopt(j)-1,N);%temporal shift of the spike is calculated
            totcoeff(((itr-1)*N)+tshift+1,ceil(iopt(j)/N))=coeff(j);% coeff are stored in coeff vector
        end
        resi(((itr-1)*N)+1:(itr*N),1)=r;
        % this loop updates the kernle matrix using the residuals calculated
        % above and then normalizes it and creates the redundant basis
        % dictionary....
end

resi=padarray(resi,max(LPadi)+max(RPadi)+1,0,'post');
%this loop performs gradient ascent
for j=1:16
    for i=1:length(y)
        % gradient is added to kernels we can put a condition here that if
        % coeff is higher than o.1 than it will be added
        cc=totcoeff(i,j);
        rr=eta*cc*resi(i:i+(Li(j,1)+LPadi(j,1)+RPadi(j,1))-1);
        kernels(1+((N/2)-(Li(j,1)/2)-LPadi(j,1)):((N/2)+(Li(j,1)/2)+RPadi(j,1)),j)=kernels(1+((N/2)-(Li(j,1)/2)-LPadi(j,1)):((N/2)+(Li(j,1)/2)+RPadi(j,1)),j)+rr;

    end
end
%this loop updates the kernel sizes after the gradient step has been
%performed
for j=1:16
    k=kernels((1+((N/2)-(Li(j,1)/2)-LPadi(j,1))):(1+((N/2)-(Li(j,1)/2))),j);
    if((norm(k)^2)>0.00001)
        LPadi(j,1)=LPadi(j,1)+10;%padding is increased if condition is satisfied
%     else
%         LPadi(j,1)=LPadi(j,1)-10;%similarly we can decrease the padding
%         if that falls below the threshold
    end
    k=kernels(1+(N/2)+(Li(j,1)/2):(N/2)+(Li(j,1)/2)+RPadi(j,1),j);
    if((norm(k)^2)>0.00001)
        RPadi(j,1)=RPadi(j,1)+10;%padding is increased if condition is satisfied
%     else
%         RPadi(j,1)=RPadi(j,1)-10;%similarly we can decrease the padding
%         if that falls below the threshold
    end
end
    
kernels=normc(kernels);
for i=1:16                          
    mpdict(:,1+((i-1)*N):(i*N))=toeplitz(kernels(:,i));  % the dictionary is intialized with the toeplitz matrices of the kernel functions...
end

end

figure;
plot(t,y0,t,yfit); %plotnof orignal signal vs time overlaid on fitted signal vs time plot...
legend('original','fitted');
figure;
plot(t,r);  % plot of residual signal...
ylim([-0.2,0.2]);
disp(max(abs(r))); % display the max of magnitude of the residual...

%for ploting the kernels
for i=1:16
     figure;
     plot(kernels(:,i));
end
