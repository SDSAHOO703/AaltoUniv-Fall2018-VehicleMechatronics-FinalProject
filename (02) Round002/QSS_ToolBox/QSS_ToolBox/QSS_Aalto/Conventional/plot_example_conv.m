% Plot results of the conventional vehicle 
% ========================================

% #####################################################################################################################

%close all
%clc

% #####################################################################################################################

%% Fuel consumption [g/s]
% ----------------------
fig = figure;
set(fig,'NumberTitle', 'off')
set(fig,'Name', 'Fuel consumption [g/s]')

    plot(t, m_dot_fuel .* 1000)
    xlabel('Time [s]')
    ylabel('Fuel consumption [g/s]')
    
%% Fuel consumption [liters/100 km]
% --------------------------------
fig = figure;
set(fig,'NumberTitle', 'off')
set(fig,'Name', 'Fuel consumption [liters/100 km]')

    plot(t, V_liter)
    xlabel('Time [s]')
    ylabel('Fuel consumption [liters/100 km]')
            
%% Drivetrain efficiency 
% ---------------------
fig = figure;
set(fig,'NumberTitle', 'off')
set(fig,'Name', 'Gearbox efficiency')

    % Consider only traction phase
    eta_DT = [];
    for i_n = 1 : length(P_wheel)
        if (P_MGB(i_n) > 0)
            eta_DT(i_n) = P_wheel(i_n)/P_MGB(i_n);
        else
            eta_DT(i_n) = 0;
        end
    end
    eta_DT(eta_DT<0) = 0;

    plot(t, eta_DT)
    xlabel('Time [s]')
    ylabel('\eta_{DT,trac} [-]')
    
% #####################################################################################################################

%% Combustion Engine map
% ----------------------
    global eta_CE_map
    global w_CE_row
    global T_CE_col
    global w_CE_max
    global T_CE_max

fig = figure;
set(fig,'NumberTitle', 'off')
set(fig,'Name', 'Combustion Engine')
    
    [cc, hh] = contour(w_CE_row, T_CE_col, eta_CE_map, 0.1:0.02:0.5);
    clabel(cc, hh)
    hold on
    plot(w_CE_max, T_CE_max, 'linewidth', 2)
    plot(w_CE, T_CE, 'go')
    title('Combustion Engine map')
    xlabel('\omega_{CE} [rad/s]')
    ylabel('T_{CE} [Nm]')
    xlim([min(w_CE_row) max(w_CE_row)])
    ylim([0 max(T_CE_max)+20])
    legend('Efficiency map', 'Maximum torque', 'Operation points')
    hold off
    
% #####################################################################################################################

clear cc fig hh i_n 