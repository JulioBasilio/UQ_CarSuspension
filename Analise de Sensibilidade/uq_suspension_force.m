function Y = uq_suspension_force(X)

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
y=zeros(length(t),4,length(ks));
    
    for i=1:length(ks)
    
    ks = X(i, 1);   
    bs = X(i, 2);
    ms = X(i, 3);
 y = uq_equation_force(ks,bs,ms,kp,mp,h,t);
 
    % time series of system force (m/s)
    Qf(:,i) = y(:,3,:);

    end
    
Y = rms(Qf);
Y = Y';