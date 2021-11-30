function Y = uq_suspension_acel(X)

%% ------------------DADOS DA ENTRADA PERFIL DE ESTRADA----------------------
load('h2h.mat','x','h')

v=30;  % Velocidade de percurso (m/s)
t=x/v;  % Tempo de percurso observado (s)

%% --------------- DADOS DO MODELO DE 1/4 DO VEICULO ----------------------

mp=40;  % Massa nao suspensa (kg)
kp=200000;  % Rigidez do pneu (N/m)

    ks = X(:, 1);   
    bs = X(:, 2);
    ms = X(:, 3);
y=zeros(length(t),1,length(bs));
    
    for i=1:length(ks)
    
    ks = X(i, 1);   
    bs = X(i, 2);
    ms = X(i, 3);
 y = uq_equation_acel(ks,bs,ms,kp,mp,h,t);
 
     % time series of system aceleration (m)
    Qa(:,i) = y(:,1,:);
    
    end
    
Y = rms(Qa);
Y = Y';
