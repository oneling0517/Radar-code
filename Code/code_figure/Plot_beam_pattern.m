%% Plot beam pattern
clc; close all; clear all;
%% Enhanced Firefly Algorithm
load('nbest(FA).mat');
load('light_record(FA).mat');
load('nbest.mat');
load('nlight_record.mat');
load('nLightbest.mat');
call = 5;
call2 = 1;
call3 = 7;
call4 = 2;
NB = Nbest_pos{1,call}; %取最好的
nlr_worse= Light_record{1,call};
nbest_pos = NB(call2,:);
nlight_record_worse = nlr_worse(call2,:);

nlr_best = Light_record{1,call3};
nlight_record_best = nlr_best(call4,:);
nbest_pos = Nbest_pos{1,1} ;
nbest_pos = nbest_pos(3,:) ;
[EFA1, EFA2] = Beam_pattern(nbest);
Ephi = linspace(-pi/2,pi/2,360); 
Etheta = linspace(-pi/2,pi/2,360); 
%% Enhanced FA 水平角圖
figure();
plot(Ephi*180/pi,EFA1,'linewidth',1.2); 

%% Firefly Algorithm
nbest = nbest(1,:); %取最好的
light_record = light_record(1,:); 
[FA1, FA2] = Beam_pattern(nbest);
phi = linspace(-pi/2,pi/2,360); 
theta = linspace(-pi/2,pi/2,360); 
%% FA 水平角圖
plot(phi*180/pi,FA1,'--','linewidth',1.2); hold on;

%% Random 500
load('SLL_azimuth.mat');
load('SLL_elevation.mat');
load('azimuth.mat');
load('elevation.mat');
azimuth_random = azimuth;
elevation_random = elevation;
SLL = [SLL_azimuth;SLL_elevation];
for i = 1:length(SLL)
    sum_SLL(i) = SLL(1,i) ;
    if  sum_SLL(i) <= -20 % 防呆
        sum_SLL(i) =0;
    end
end
[val, num] = min(sum_SLL);
[val_azi, num_azi] = min(SLL_azimuth); %水平角最小

%% GA水平角圖
load('fBest.mat') 
d = 0.5; 
lamda = 1;
Ny = 7; 
Nz = 12; 
theta0 = 0; 
phi0 = 0; 
NA = 360; 
NE = 360; 

phi = linspace (-pi/2,pi/2,NA); 
theta = linspace (-pi/2,pi/2,NE) ; 
aa = [0:d: (Ny-1)*d]; 
DD1 = repmat (aa',1,Nz) ; 
bb = [0:d: (Nz-1)*d]; 
DD2 = repmat (bb,Ny,1); 
DD = DD1+sqrt (-1) .*DD2; 
f = reshape (fBest,Ny,Nz) ; 
for jj = 1:length (phi)
    for ii = 1:length(theta) 
        pattern (jj,ii) =sum(sum (exp (sqrt (-1) *2*pi/lamda* (sin (phi(jj))... 
        * cos (theta (ii))*real(DD)+sin(theta(ii))*imag(DD))... 
        -sin (phi0) *cos (theta0) *real (DD) -sin(theta0) *imag (DD) ) .*f));
    end 
end 
max_p = max(max (abs (pattern) )); 
pattern_dbw = 20*log10 (abs (pattern) /max_p+eps) ; 
number = find(pattern_dbw<-50) ; 
g_temp = -50+unifrnd(-1,1,1,length (number) ) ; 
for ii = 1:length (number) 
    pattern_dbw(number (ii)) = g_temp(ii); 
end 
temp2 = pattern_dbw(round (NA* ((pi/2-phi0)/pi)),:); 
plot (theta*180/pi, temp2,'linewidth',1.2); hold on;

%% Random 水平角圖
fig_azi = cell2mat(azimuth_random);
Random1 = fig_azi(:,num); %要畫的圖
plot(phi*180/pi,Random1,'--','linewidth',1.2); hold on;
%% Uniform 
load('azimuth_uni.mat');
load('elevation_uni.mat');

%% Uniform 水平角圖
Uniform1 = cell2mat(azimuth);
plot(phi*180/pi,Uniform1,'-.','linewidth',1.2); hold on;
legend('Enhanced FA','FA','GA', 'Best random ','Uniform');
grid;
title('Pattern');
xlabel ('\phi azithum/。');t
ylabel (' Gain (dB)'); 
%% FA天線擺放圖
figure; 
n = 1;
numTX = 6;
numRX =7;
[ns, virtual_array] = cal_location(n, nbest, numTX, numRX);
array_TX_x = nbest(1,1:numTX);
array_TX_y = nbest(1,numTX+1:numTX*2);
array_RX_x = nbest(1,numTX*2+1:numTX*2+numRX);
array_RX_y = nbest(1,numTX*2+1+numRX:end);
count = 0;
for i = 1:numTX
     for j = 1:numRX
         count = count +1;
         virtual_x(1,count) = array_TX_x(i)+array_RX_x(j);
         virtual_y(1,count) = array_TX_y(i)+array_RX_y(j);
     end
end
virtual_array = [virtual_x;virtual_y];
scatter(array_TX_x,array_TX_y,'s','filled');hold on;
scatter(array_RX_x,array_RX_y,'r','filled');hold on;
scatter(virtual_x,virtual_y,'^');
legend('TX','RX','Virtual');
title('Optimal antenna array');
xlabel ('Position of antennas \lambda');
ylabel ('Position of antennas \lambda'); 

%% Enhanced FA仰角圖
figure()
plot (Etheta*180/pi,EFA2,'linewidth',1.2); hold on;

%% FA仰角圖
plot (theta*180/pi,FA2,'--','linewidth',1.2); hold on;

%% GA仰角圖
temp1 = pattern_dbw(:, round (NE* ((pi/2-theta0) /pi))); 
plot (phi*180/pi,temp1,'linewidth',1.2); hold on;

%% Random 仰角圖
fig_ele = cell2mat(elevation_random');
Random2 = fig_ele(num,:); %要畫的圖
plot(phi*180/pi,Random2,'--','linewidth',1.2); hold on;
%% Uniform 仰角圖
Uniform2 = cell2mat(elevation);
plot(phi*180/pi,Uniform2,'-.','linewidth',1.2); hold on;
legend('Enhanced FA','FA','GA', 'Best random ','Uniform');
grid;
title('Pattern');
xlabel('\theta elevation/。');
ylabel(' Gain (dB)'); 
%% 迭代趨勢圖
figure();
x_axis = 1:500; 
plot(x_axis,nlight_record_worse(1:500)); hold on;
plot(x_axis,nlight_record_best(1:500));
%gtext('SLL = -22.5362','fontsize',12); 
title('Iteration');
xlabel ('Times'); 
ylabel ('Fitness function');
%% ===================================%%
% 第1-2筆數據當fa不好的範例 
% 第9-1筆為改進fa


