% Plot results of the series hybrid vehicle
% =========================================

% #####################################################################################################################

%close all
%clc

% #####################################################################################################################

%% Global variables
% ----------------
    
    % Electric Motor map
    global eta_EM_map
    global w_EM_row
    global T_EM_col
    global w_EM_max
    global T_EM_max

    % Electric Generator map
    global eta_EG_map
    global w_EG_row
    global T_EG_col
    global w_EG_max
    global T_EG_max

    % Combustion Engine map
    global eta_CE_map
    global w_CE_row
    global T_CE_col
    global w_CE_max
    global T_CE_max

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
    plot(w_EM_max, T_EM_max, 'linewidth',2)
    plot(w_EM, T_EM, 'go')
    plot(w_EM_max, -T_EM_max, 'linewidth',2)
    xlabel('\omega_{EM} [rad/s]')
    ylabel('T_{EM} [Nm]')
    title('Electric Motor map')
    legend('Efficiency map','Nominal torque','Operation point')
    hold off

% #####################################################################################################################

%% Electric generator
% ------------------
fig = figure;
set(fig,'NumberTitle', 'off')
set(fig,'Name', 'Electric Generator')

    vvv     = [0.7,0.75,0.8,0.83,0.85,0.87,0.88,0.89,0.90,0.91,0.92,0.93,0.94];
    [cc,hh] = contour(w_EG_row, T_EG_col, eta_EG_map', vvv);
    clabel(cc,hh)
    hold on
    plot(w_EG_max, T_EG_max, 'linewidth',2)
    xlabel('\omega_{EG} [rad/s]')
    ylabel('T_{EG} [Nm]')
    ylim([0 max(T_EG_max)+10])
    title('Electric Generator map')
    plot(w_EG, T_EG,'go')
    legend('Efficiency map','Nominal torque','Operation point')
    hold off

% #####################################################################################################################

%% Combustion engine
% -----------------
fig = figure;
set(fig,'NumberTitle', 'off')
set(fig,'Name', 'Combustion Engine')

    [cc, hh]=contour(w_CE_row, T_CE_col, eta_CE_map, 0.1:0.03:0.5);
    clabel(cc, hh)
    title('Combustion Engine map')
    xlabel('\omega_{CE} [rad/s]')
    ylabel('T_{CE} [Nm]')
    hold on
    plot(w_CE_max, T_CE_max, 'linewidth',2)
    plot(w_CE, T_CE, 'go')
    legend('Efficiency map','Maximum torque','Operation point')
    hold off

% #####################################################################################################################

%% Gen-set control
% -----------------
fig = figure;
set(fig,'NumberTitle', 'off')
set(fig,'Name', 'Gen-set control')
set(gca,'Position', [0.10 0.3 0.85 0.60])
set(fig, 'Position', [300 300 900 500])

plot(t, v*3.6, 'linewidth', 2)
hold on; grid on
plot(t, ice_on*5+max(v*3.6)+10, 'r', 'linewidth', 2)
plot(t, q_BT*100, 'm', 'linewidth', 2)
plot(t, P_EG/1000, 'g', 'linewidth', 2)
plot(t, P_BT/1000, 'k', 'linewidth', 2)
ylabel('Speed (km/h), SOC (%), Power (kW)')
xlabel('Time (s)')
legend('Speed', 'Engine on', 'SOC', 'Gen-set power', 'Battery power')

th(1) = uicontrol(fig,'Style','text','String','Gen-set efficiency',...
    'Position',[50 50 175 25], 'FontSize', 12);
th(2) = uicontrol(fig,'Style','text','String','Battery efficiency',...
    'Position',[300 50 175 25], 'FontSize', 12);
th(3) = uicontrol(fig,'Style','text','String','Fuel consumption',...
    'Position',[540 50 175 25], 'FontSize', 12);

eta_GS = trapz(t, P_EG)/trapz(t, P_CE);
eta1_BT = trapz(t(P_BT>0), P_BT(P_BT>0))/trapz(t(P_BT>0), P_BT(P_BT>0)+L_BT(P_BT>0));
eta2_BT = trapz(t(P_BT<0), P_BT(P_BT<0))/trapz(t(P_BT<0), P_BT(P_BT<0)-L_BT(P_BT<0));
eta_BT = eta1_BT*eta2_BT;

th(1) = uicontrol(fig,'Style','text','String',[num2str(round(eta_GS*1000)/10) ' %'],...
    'Position',[230 50 75 25], 'FontSize', 12);
th(2) = uicontrol(fig,'Style','text','String',[num2str(round(eta_BT*1000)/10) ' %'],...
    'Position',[480 50 75 25], 'FontSize', 12);
th(2) = uicontrol(fig,'Style','text','String',[num2str(round(V_liter(end)*100)/100) ' l/100km'],...
    'Position',[720 50 100 25], 'FontSize', 12);
