% ============================================
% Combustion Engine (based on consumption map)
% ============================================



% #####################################################################################################################

% Global variables
% ----------------
    global h                                    % Stepsize [s] from block "Driving Cycle"
    global eta_CE_map
    global w_CE_row
    global T_CE_col
    global w_CE_max
    global T_CE_max
    global H_u
    global rho_f
    
% #####################################################################################################################

% Load data
% ---------
%     load V_CE_map                               % Consumption map                           [kg/s]
%     load eta_CE_map                             % Efficiency map                            [-]
%     load w_CE_row                               % Engine speed range                        [rad/s]
%     load p_me_col                               % Brake mean effective pressure range       [Pa]
%     load w_CE_max                               % Maximum engine speed                      [rad/s]
%     load p_me_max                               % Maximum brake mean effective pressure     [Pa]
    
    load data_VW_CE.mat
    w_CE_max = w_CE_row;
    
    w_CE_upper      = max(w_CE_row);              % Upper limit engine speed                  [rad/s]

    V_CE_map        = V_CE_map .* (V_d/1.9);      % Scale engine consumption, default size is 1.9L                   
    
    T_CE_col        = p_me_col .* (V_d/1000)/(4*pi);   % Torque range                         [Nm]
    T_CE_max        = p_me_max .* (V_d/1000)/(4*pi);   % Maximum torque                       [Nm]

    T_CE_idle = T_CE_cutoff;                       % Torque limit for idle                     [Nm]
    
    % Idle consumption
    T_CE_col = [0; T_CE_col];
    V_CE_map = [ones(size(w_CE_row))'*0.00015 V_CE_map];
    
% #####################################################################################################################

% Which engine type?
% ------------------
    switch engine_type

    case 1                                      % -> Otto
        H_u         = 42.7e6;                   % Bosch-Manual
        rho_f       = 0.745;                    % Bosch-Manual

    case 2                                      % -> Diesel
        H_u         = 42.5e6;                   % Bosch-Manual
        rho_f       = 0.84;                     % Bosch-Manual
    end
    
% #####################################################################################################################

    % creating the efficiency map
    [T,w] = meshgrid(T_CE_col, w_CE_row);
    map_kW=T.*w;
    eta_CE_map = (map_kW./(V_CE_map*H_u))';

