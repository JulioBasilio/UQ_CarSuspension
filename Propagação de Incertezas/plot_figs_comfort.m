%%% Plota as figuras

% - - - - - - FIGURE Envelope Acceleration - - - - -
figure(1)
plot(x,Qa_smean,'b:','linewidth',0.1)
hold on
fill1=fill([x fliplr(x)],[Qa_upp fliplr(Qa_low)],'b','LineStyle','none');
alpha(fill1,0.1);
plot(x,Qa_mean_rms+Qa_smean*0,'r:','linewidth',4)
fill2=fill([x fliplr(x)],[Qa_rms_upp+Qa_smean*0 fliplr(Qa_rms_low +Qa_smean*0)],'r','LineStyle','none');
alpha(fill2,0.3);
plot(x,0.315+Qa_smean(1,:)*0,'--','Color','k','linewidth',4)
plot(x,0.8+Qa_smean(1,:)*0,'--','Color','k','linewidth',4)
txxt1=text(200,0.21,'Comfortable','FontSize',12,'Color','k');
txxt2=text(200,0.7,'Uncomfortable','FontSize',12,'Color','k');
ylabel('Acceleration (m/s^2)')
xlabel('Distance (m)')
leg15 = {'Sample mean';...
         'Envelope sample mean';...
         'RMS sample mean';...
         'RMS Envelope'};
legend(leg15,'FontSize',12,'location','northeast');
hold off
%
ax = gca;
ax.FontSize = 14;
ax.BoxStyle = 'full';
ax.XColor = 'black';
ax.YColor = 'black';
ax.YAxis.Exponent = 0;
ax.YAxis.TickLabelFormat = '%1.1f';
ax.XAxis.TickLabelFormat = '%1.0f';
%%% saving
saveas(gcf,'envelope_aceleracao_confort.png')
% - - - - - - END FIGURE - - - - -

% - - - - - - FIGURE Envelope forca - - - - -
figure(2)
hold on
fill3 = fill([x fliplr(x)],[Qf_upp fliplr(Qf_low)],'b','LineStyle','none'); 
alpha(fill3,0.1)
plot(x,Qf_smean,'b:','linewidth',0.1)
plot(x,force_crit+Qf_smean*0,'k--','linewidth',2)
txxt3=text(160,force_crit+70,'Critical dynamic force','FontSize',12,'Color','k');
ylabel('Dynamic force (N)')
xlabel('Distance (m)')
leg16 = {'Envelope sample mean';'Sample mean'};
legend(leg16,'FontSize',12,'location','northeast');
hold off
%
ax = gca;
ax.FontSize = 14;
ax.BoxStyle = 'full';
ax.XColor = 'black';
ax.YColor = 'black';
ax.YAxis.Exponent = 0;
ax.YAxis.TickLabelFormat = '%1.0f';
ax.XAxis.TickLabelFormat = '%1.0f';
%%% saving
saveas(gcf,'envelope_forca_confort.png')
% - - - - - - END FIGURE - - - - -

% - - - - - - FIGURE histograma aceleracao - - - - -
figure(3)
hold on
bar(Qa_bins,Qa_freq,1.0);
plot(Qa_supp,Qa_ksd,'r','linewidth',3)
xlabel('Acceleration (m/s^2)')
ylabel('Frequency (-)')
hold off
%
ax = gca;
ax.FontSize = 14;
ax.BoxStyle = 'full';
ax.XColor = 'black';
ax.YColor = 'black';
ax.YAxis.Exponent = 0;
ax.YAxis.TickLabelFormat = '%1.1f';
ax.XAxis.TickLabelFormat = '%1.1f';
%%% saving
saveas(gcf,'histograma_aceleracao_confort.png')
% - - - - - - END FIGURE - - - - -

% - - - - - - FIGURE histograma forca - - - - -
figure(4)
hold on
bar(Qf_bins,Qf_freq,1.0);
plot(Qf_supp,Qf_ksd,'r','linewidth',3)
xlabel('Dynamic force (N)')
ylabel('Frequency (-)')
hold off
%
ax = gca;
ax.FontSize = 14;
ax.BoxStyle = 'full';
ax.XColor = 'black';
ax.YColor = 'black';
ax.YAxis.Exponent = 0;
ax.YAxis.TickLabelFormat = '%1.4f';
ax.XAxis.TickLabelFormat = '%1.0f';
%%% saving
saveas(gcf,'histograma_forca_confort.png')
% - - - - - - END FIGURE - - - - -


% - - - - - - FIGURE Analise Convergencia 2nd momentum aceleracao
figure(5)
conv = sqrt(cumsum(mean(Qa.^2))./(1:Ns));
loglog(1:Ns,conv(1:Ns),'xb','linewidth',1.5)
ylim([0.220 0.265])
xlabel('Number of samples')
ylabel('2nd moment of acceleration')
%
ax = gca;
ax.FontSize = 14;
ax.BoxStyle = 'full';
ax.XColor = 'black';
ax.YColor = 'black';
ax.YAxis.TickLabelFormat = '%1.3f';
ax.XAxis.TickLabelFormat = '%1.0f';
%%% saving
saveas(gcf,'convergencia_aceleracao_confort.png')
% - - - - - - END FIGURE - - - - -

% - - - - - - FIGURE Analise Convergencia 2nd momentum forca
figure(6)
conv = sqrt(cumsum(mean(Qf.^2))./(1:Ns));
loglog(1:Ns,conv(1:Ns),'xr','linewidth',1.5)
ylim([214 230])
xlabel('Number of samples')
ylabel('2nd moment of force')
%
ax = gca;
ax.FontSize = 14;
ax.BoxStyle = 'full';
ax.XColor = 'black';
ax.YColor = 'black';
%ax.YAxis.Exponent = 0;
ax.YAxis.TickLabelFormat = '%1.0f';
ax.XAxis.TickLabelFormat = '%1.0f';
%%% saving
saveas(gcf,'convergencia_forca_confort.png')
% - - - - - - END FIGURE - - - - -