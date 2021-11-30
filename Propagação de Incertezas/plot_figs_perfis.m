%%% Plota as figuras

% - - - - - - FIGURE Envelope aceleracao - - - - -
figure(1)
hold on
plot(x,Qa_mean_rms(:,1)+Qa_smean(1,:)*0,'r:','linewidth',4) 
fill1 = fill([x fliplr(x)],[Qa_rms_low(1,:)+Qa_smean(1,:)*0 fliplr(Qa_rms_upp(1,:) +Qa_smean(1,:)*0)],'r--','LineStyle','none');
alpha(fill1,0.2)
plot(x,Qa_mean_rms(:,2)+Qa_smean(2,:)*0,'b:','linewidth',4)
fill2 = fill([x fliplr(x)],[Qa_rms_low(2,:)+Qa_smean(2,:)*0 fliplr(Qa_rms_upp(2,:) +Qa_smean(2,:)*0)],'b--','LineStyle','none');
alpha(fill2,0.2)
plot(x,0.315+Qa_smean(1,:)*0,'--','Color','k','linewidth',4)
plot(x,0.8+Qa_smean(1,:)*0,'--','Color','k','linewidth',4)
axis([0 max(x) 0 1.0])
%
txxt1=text(200,0.29,'Comfortable','FontSize',12,'Color','k');
txxt2=text(200,0.77,'Uncomfortable','FontSize',12,'Color','k');
hold off
ylabel('Acceleration (m/s^2)')
xlabel('Distance (m)')
%
leg11 ={'RMS sample mean (road class A-B)';...
        'Envelope (road class A-B)';...
        'RMS sample mean (road class B-C)';...
        'Envelope (road class B-C)'};
legend(leg11,'FontSize',12,'location','northeast');
ax = gca;
ax.FontSize = 14;
ax.BoxStyle = 'full';
ax.XColor = 'black';
ax.YColor = 'black';
ax.YAxis.TickLabelFormat = '%1.1f';
ax.XAxis.TickLabelFormat = '%1.0f';
%%% saving
saveas(gcf,'rms_aceleracao_distance.png');
% - - - - - - END FIGURE - - - - -

% - - - - - - FIGURE Envelope Forca - - - - -
figure(2)
hold on
plot(x,Qf_smean(1,:),'r:','linewidth',0.4)
fill3 = fill([x fliplr(x)],[Qf_low(1,:) fliplr(Qf_upp(1,:) )],'r--','LineStyle','none');
alpha(fill3,0.3)
plot(x,Qf_smean(2,:),'b:','linewidth',0.4)
fill4=fill([x fliplr(x)],[Qf_low(2,:) fliplr(Qf_upp(2,:) )],'b--','LineStyle','none');
alpha(fill4,0.3)
%
plot(x,force_crit+Qf_smean*0,'k--','linewidth',2)
txxt3=text(170,force_crit+90,'Critical dynamic force','FontSize',12,'Color','k');
%
axis([0 max(x) -2500 2500])
hold off
%
ylabel('Dynamic force (N)')
xlabel('Distance (m)')

leg12 ={'Sample mean (road class A-B)';...
        'Envelope (road class A-B)';...
        'Sample mean (road class B-C)';...
        'Envelope (road class B-C)'};
legend(leg12,'FontSize',12,'location','northeast');
%
ax = gca;
ax.FontSize = 14;
ax.BoxStyle = 'full';
ax.XColor = 'black';
ax.YColor = 'black';
ax.YAxis.TickLabelFormat = '%1.0f';
ax.XAxis.TickLabelFormat = '%1.0f';
%%% saving
saveas(gcf,'envelope_forca_distance.png');
% - - - - - - END FIGURE - - - - -

% - - - - - - FIGURE Histograma aceleracao - - - - -
figure(3)
hold on
bar1 = bar(Qa_bins(1,:),Qa_freq(1,:),'r');
alpha(bar1,0.3)
bar2=bar(Qa_bins(2,:),Qa_freq(2,:),'b');
alpha(bar2,0.3)
%
plot(Qa_supp(1,:),Qa_ksd(1,:),'r--','linewidth',2)
plot(Qa_supp(2,:),Qa_ksd(2,:),'b--','linewidth',2)
hold off
xlabel('Acceleration (m/s^2)')
ylabel('Frequency (-)')
leg13 = {'PDF (road class A-B)';'PDF (road class B-C)'};
legend(leg13,'FontSize',12,'location','northeast');
%
ax = gca;
ax.FontSize = 14;
ax.BoxStyle = 'full';
ax.XColor = 'black';
ax.YColor = 'black';
ax.YAxis.TickLabelFormat = '%1.0f';
ax.XAxis.TickLabelFormat = '%1.1f';
%%% saving
saveas(gcf,'histograma_aceleracao.png');
% - - - - - - END FIGURE - - - - -

% - - - - - - FIGURE Histograma forca - - - - -
figure(4)
hold on
bar1 = bar(Qf_bins(1,:),Qf_freq(1,:),'r');
alpha(bar1,0.3)
bar2 = bar(Qf_bins(2,:),Qf_freq(2,:),'b');
alpha(bar2,0.3)
plot(Qf_supp(1,:),Qf_ksd(1,:),'r--','linewidth',2)
plot(Qf_supp(2,:),Qf_ksd(2,:),'b--','linewidth',2)
hold off
xlabel('Dynamic force (N)')
ylabel('Frequency (-)')
leg14 = {'PDF (road class A-B)';'PDF (road class B-C)'};
legend(leg14,'FontSize',12,'location','northeast');
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
saveas(gcf,'histograma_forca.png')
% - - - - - - END FIGURE - - - - -


% - - - - - - FIGURE Road Profile
figure(5)
plot(x,hp(1,:)*1000,'r-','linewidth',2)
hold on
plot(x,hp(2,:)*1000,'b-','linewidth',2)
xlabel('Distance (m)')
ylabel('Road profile (mm)')
leg15 = {'Road class A-B (K=2)';'Road class B-C (K=3)'};
legend(leg15,'FontSize',12,'location','northeast');
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
saveas(gcf,'perfis_road.png')
% - - - - - - END FIGURE - - - - -