clc
clear all
close all

%% Levantamento de dados (massa, rigidez e amortecimento)
load massas.mat
m=massas;

m_mean=mean(m/4);
m_std = std(m/4);

% Desconfortavel e Inseguro (Situação Não-Otimizada)
%fn = 3; % Freq. Natural
%si = 0.1; % Tx. Amortecimento

% Confortavel e Seguro (Situação Otimizada)
fn = 1; % Freq. Natural
si = 0.2; % Tx. Amortecimento

k_mean = 4*((pi)^2)*((fn)^2)*(m_mean);
k_std = 4*((pi)^2)*((fn)^2)*(m_std);
b_mean = si*2*sqrt((m_mean)*k_mean);
b_std = si*2*sqrt((m_std)*k_std);

%% ------------------DADOS DA ENTRADA PERFIL DE ESTRADA----------------------
load('h2h.mat','x','h')

v=30;  % Velocidade de percurso (m/s)
t=x/v;  % Tempo de percurso observado (s)
Ndt = length(x);   % number of time steps

%% --------------- DADOS DO MODELO DE 1/4 DO VEICULO ----------------------

mp=40;  % Massa nao suspensa (kg)
kp=200000;  % Rigidez do pneu (N/m)

%% ------------------------ UQLab Distribuições ------------------------------------------
uqlab;

Ns = 10000;% number of samples

Qa = zeros(Ndt,Ns);
Qf = zeros(Ndt,Ns);

Input.Marginals(1).Type = 'Gamma';
Input.Marginals(1).Moments = [k_mean, k_std];
Input.Marginals(2).Type = 'Gamma';
Input.Marginals(2).Moments = [b_mean, b_std];
Input.Marginals(3).Type = 'Gamma';
Input.Marginals(3).Moments = [m_mean, m_std];
myInput = uq_createInput(Input);
X = uq_getSample(myInput,Ns,'Sobol');

    ks = X(:,1);   
    bs = X(:,2);
    ms = X(:,3);

%% Monte Carlo method
for i=1:Ns
    
    %--------------- Modelo na forma de Eq. de Estado -------------------------
    A=[0 1 0 0;-(kp+ks(i))/mp -bs(i)/mp ks(i)/mp bs(i)/mp;0 0 0 1;ks(i)/ms(i) bs(i)/ms(i) -ks(i)/ms(i) -bs(i)/ms(i)];
    B=[0;kp/mp;0;0];
    C=[ks(i)/ms(i) bs(i)/ms(i) -ks(i)/ms(i) -bs(i)/ms(i);1 0 -1 0;-kp 0 0 0];
    D=[0;0;kp];
    
    %---------- Calculo da solucao com a Entrada Perfil de Estrada ------------
    sys=ss(A,B,C,D);
    y=lsim(sys,h,t);
    
     % time series of system aceleration (m)
    Qa(:,i) = y(:,1);
    
    % time series of system force (m/s)
    Qf(:,i) = y(:,3);

end

%% aceleration

% sample mean
Qa_smean = mean(Qa');
% rms mean
Qa_rms_mean = rms(Qa_smean);
% rms
Qa_rms = rms(Qa);

% mean rms
Qa_mean_rms = mean(Qa_rms);

% confidence band
Pc = 95; 
r_plus = 0.5*(100 + Pc); r_minus = 0.5*(100 - Pc);
Qa_upp = prctile(Qa',r_plus);
Qa_low = prctile(Qa',r_minus);
% rms band
Qa_rms_upp = prctile(Qa_rms,r_plus);
Qa_rms_low = prctile(Qa_rms,r_minus);

%% force

% sample mean
Qf_smean = mean(Qf');
% temporal mean
Qf_tmean = mean(Qf);
% std
Qf_std = std(Qf');

ms_mean=mean(ms);
force_crit=0.25*9.81*ms_mean;

% confidence band
Pc = 95; 
r_plus = 0.5*(100 + Pc); r_minus = 0.5*(100 - Pc);
Qf_upp = prctile(Qf',r_plus);
Qf_low = prctile(Qf',r_minus);

%% Histograma Aceleração
% histogram of rms
Nbins = round(sqrt(Ns));
[Qa_bins,Qa_freq] = randvar_pdf(Qa_rms,Nbins);

% kernel density estimator
[Qa_ksd,Qa_supp] = ksdensity(Qa_rms);

%% Histograma força
% histogram 
Nbins = round(sqrt(Ns));
[Qf_bins,Qf_freq] = randvar_pdf(Qf_smean,Nbins);

% kernel density estimator
[Qf_ksd,Qf_supp] = ksdensity(Qf_smean);

 %% Analise Convergência

 conv = sqrt(cumsum(mean(Qa.^2))./(1:Ns));
 
 conv = sqrt(cumsum(mean(Qf.^2))./(1:Ns));
 
 %% Figures
% Comment or Uncomment for each case below:
% Optimized
run plot_figs_comfort
% Non-optimized
run plot_figs_uncomfort