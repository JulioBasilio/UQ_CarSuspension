function y=uq_equation_force(ks,bs,ms,kp,mp,h,t)

%--------------- Modelo na forma de Eq. de Estado -------------------------
    A=[0 1 0 0;-(kp+ks)/mp -bs/mp ks/mp bs/mp;0 0 0 1;ks/ms bs/ms -ks/ms -bs/ms];
    B=[0;kp/mp;0;0];
    C=[-kp 0 0 0];
    D=[kp];
    
    %---------- Calculo da solucao com a Entrada Perfil de Estrada ------------
    sys=ss(A,B,C,D);
    y=lsim(sys,h,t);
