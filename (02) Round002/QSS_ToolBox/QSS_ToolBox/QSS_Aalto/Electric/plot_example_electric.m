% Plot results of the electric vehicle
% =====================================

% #####################################################################################################################

%close all
%clc

% #####################################################################################################################

% Global variables
% ----------------
    
    % Electric Motor map
    global eta_EM_map
    global w_EM_row
    global T_EM_col
    global w_EM_max
    global T_EM_max

% #####################################################################################################################

%% Battery
% -------
fig = figure;
set(fig,'NumberTitle', 'off')
set(fig,'Name', 'Battery')
set(fig, 'Position', [100 100 1000 800]);

    subplot(2,2,1)
    plot(t, q_BT)
    grid on
    xlabel('Time [s]')
    ylabel('q_{BT} [0-1]')
    title('Battery charge ratio')

    subplot(2,2,2)
    plot(t, U_BT)
    grid on
    xlabel('Time [s]')
    ylabel('U_{BT} [V]')
    title('Battery voltage')

    subplot(2,2,3)
    plot(t, I_BT)
    grid on
    xlabel('Time [s]')
    ylabel('I_{BT} [A]')
    title('Battery current')

    subplot(2,2,4)
    plot(t, P_BT./1000)
    grid on
    xlabel('Time [s]')
    ylabel('P_{BT} [kW]')
    title('Battery power')
    
% #####################################################################################################################

%% Electric motor
% --------------
fig = figure;
set(fig,'NumberTitle', 'off')
set(fig,'Name', 'Electric Motor')

    tmp_map = eta_EM_map; tmp_map(tmp_map>1) = 1./tmp_map(tmp_map>1);
    
    [cc,hh]    = contour(w_EM_row, T_EM_col, tmp_map', 0.5:0.03:1);
    clabel(cc,hh)
    hold on
    plot(w_EM_max, T_EM_max)
    plot(w_EM_max, T_EM_max*1.25, 'r','linewidth', 2)
    plot(w_EM, T_EM, 'go')
    plot(w_EM_max, -T_EM_max)
    plot(w_EM_max, -T_EM_max*1.25, 'r','linewidth', 2)
    ylim([-max(T_EM_max*1.5)-10 max(T_EM_max*1.5)+10])
    xlabel('\omega_{EM} [rad/s]')
    ylabel('T_{EM} [Nm]')
    title('Electric Motor map')
    legend('Efficiency map','Nominal torque','Overtorque','Operation point')
    hold off

% #####################################################################################################################

%% Energy consumption
% -----------------
fig = figure;
set(fig,'NumberTitle', 'off')
set(fig,'Name', 'Energy consumption')
set(gca,'Position', [0.10 0.3 0.85 0.60])
set(fig, 'Position', [300 300 800 500])

plot(t, v*3.6, 'linewidth', 2)
hold on; grid on
plot(t, q_BT*100, 'm', 'linewidth', 2)
plot(t, w_EM.*T_EM/1000, 'g', 'linewidth', 2)
plot(t, P_BT/1000, 'k', 'linewidth', 2)
ylabel('Speed (km/h), SOC (%), Power (kW)')
xlabel('Time (s)')
legend('Speed', 'SOC', 'Motor power', 'Battery power')

th(1) = uicontrol(fig,'Style','text','String','Energy consumption',...
    'Position',[50 50 175 25], 'FontSize', 12);
th(2) = uicontrol(fig,'Style','text','String','Battery efficiency',...
    'Position',[350 50 175 25], 'FontSize', 12);
    
nrj_BT = E_BT(end)/(x_tot(end)/1000);
eta1_BT = trapz(t(P_BT>0), P_BT(P_BT>0))/trapz(t(P_BT>0), P_BT(P_BT>0)+L_BT(P_BT>0));
eta2_BT = trapz(t(P_BT<0), P_BT(P_BT<0))/trapz(t(P_BT<0), P_BT(P_BT<0)-L_BT(P_BT<0));
eta_BT = eta1_BT*eta2_BT;

th(1) = uicontrol(fig,'Style','text','String',[num2str(round(nrj_BT*10)/10) ' Wh/km'],...
    'Position',[230 50 100 25], 'FontSize', 12);
th(2) = uicontrol(fig,'Style','text','String',[num2str(round(eta_BT*1000)/10) ' %'],...
    'Position',[530 50 100 25], 'FontSize', 12);

% #####################################################################################################################

clear fig th tmp_map vvv 
