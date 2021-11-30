clc
clear all
close all

%% Levantamento de dados (massa, rigidez e amortecimento)
load massas.mat
m=massas;

m_mean=mean(m/4);
m_std = std(m/4);

% Confortavel e Seguro (Situação Otimizada)
fn = 1; % Freq. Natural
si = 0.2; % Tx. Amortecimento

k_mean = 4*((pi)^2)*((fn)^2)*(m_mean);
k_std = 4*((pi)^2)*((fn)^2)*(m_std);
b_mean = si*2*sqrt((m_mean)*k_mean);
b_std = si*2*sqrt((m_std)*k_std);

%% ------------------DADOS DA ENTRADA PERFIL DE ESTRADA----------------------
hp=zeros(2,length(x));

load('h2h.mat','x','h')
hp(1,:)=h;

load('h3h.mat','x','h')
hp(2,:)=h;

v=30;  % Velocidade de percurso (m/s)
t=x/v;  % Tempo de percurso observado (s)
Ndt = length(x);   % number of time steps

%% --------------- DADOS DO MODELO DE 1/4 DO VEICULO ----------------------

mp=40;  % Massa nao suspensa (kg)
kp=200000;  % Rigidez do pneu (N/m)

%% ------------------------ UQLab Distribuições ------------------------------------------
uqlab;

Ns = 10000;% number of samples

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
 
Qa = zeros(Ndt,Ns,length(1:2));
Qf = zeros(Ndt,Ns,length(1:2));

for p=1:2
%% Monte Carlo method
    for i=1:Ns
    
    %--------------- Modelo na forma de Eq. de Estado -------------------------
    A=[0 1 0 0;-(kp+ks(i))/mp -bs(i)/mp ks(i)/mp bs(i)/mp;0 0 0 1;ks(i)/ms(i) bs(i)/ms(i) -ks(i)/ms(i) -bs(i)/ms(i)];
    B=[0;kp/mp;0;0];
    C=[ks(i)/ms(i) bs(i)/ms(i) -ks(i)/ms(i) -bs(i)/ms(i);1 0 -1 0;-kp 0 0 0];
    D=[0;0;kp];
    
    %---------- Calculo da solucao com a Entrada Perfil de Estrada ------------
    sys=ss(A,B,C,D);
    y=lsim(sys,hp(p,:),t);
    
     % time series of system aceleration (m)
    Qa(:,i,p) = y(:,1);
    
    % time series of system force (m/s)
    Qf(:,i,p) = y(:,3);

    end
end

%% aceleration

for j=1:1:2
% sample mean
Qa_smean(j,:) = mean(Qa(:,:,j)');
% rms mean
Qa_rms_mean = rms(Qa_smean(j,:));
% rms
Qa_rms(j,:) = rms(Qa(:,:,j));
% mean rms
Qa_mean_rms(:,j) = rms(Qa_rms(j,:));

% confidence band
Pc = 95; 
r_plus = 0.5*(100 + Pc); r_minus = 0.5*(100 - Pc);
Qa_upp(j,:) = prctile(Qa(:,:,j)',r_plus);
Qa_low(j,:) = prctile(Qa(:,:,j)',r_minus);
% rms band
Qa_rms_upp(j,:) = prctile(Qa_rms(j,:),r_plus);
Qa_rms_low(j,:) = prctile(Qa_rms(j,:),r_minus);

end

%% force

ms_mean=mean(ms);
force_crit=0.25*9.81*ms_mean;

Qf_upp=zeros(2,Ndt);
Qf_low=zeros(2,Ndt);

for j=1:1:2
% sample mean
Qf_smean(j,:) = mean(Qf(:,:,j)');

% confidence band
Pc = 95; 
r_plus = 0.5*(100 + Pc); r_minus = 0.5*(100 - Pc);
Qf_upp(j,:) = prctile(Qf(:,:,j)',r_plus);
Qf_low(j,:) = prctile(Qf(:,:,j)',r_minus);

end

%% Histograma aceleração
% histogram of rms

for j=1:1:2
Nbins = round(sqrt(Ns));
[Qa_bins(j,:),Qa_freq(j,:)] = randvar_pdf(Qa_rms(j,:),Nbins);

% kernel density estimator
[Qa_ksd(j,:),Qa_supp(j,:)] = ksdensity(Qa_rms(j,:));
end

%% Histograma força
% histogram 

for j=1:1:2
Nbins = round(sqrt(Ns));
[Qf_bins(j,:),Qf_freq(j,:)] = randvar_pdf(Qf_smean(j,:),Nbins);

% kernel density estimator
[Qf_ksd(j,:),Qf_supp(j,:)] = ksdensity(Qf_smean(j,:));
end

%% Figures

run plot_figs_perfis