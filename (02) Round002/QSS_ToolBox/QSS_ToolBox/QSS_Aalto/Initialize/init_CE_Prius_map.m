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
load data_Prius_CE

    w_CE_upper      = max(w_CE_max);            % Upper limit engine speed                  [rad/s]

    bore = 0.075;
    stroke = 0.0847;
    stroke2 = V_d/(4*pi*(bore/2)^2)/1000;
    cm = (w_CE_row*stroke)/pi;
    cm2 = (w_CE_row*stroke2)/pi;
    
    for i_map=1:length(p_me_col)
        fuel_map(:,i_map) = interp1(cm, V_CE_map(:,i_map), cm2, 'linear', 'extrap');
    end

    V_CE_map        = fuel_map;      % Scale engine consumption                   
        
    T_CE_col        = p_me_col .* (V_d/1000)/(4*pi);   % Torque range                              [Nm]
    T_CE_max        = p_me_max .* (V_d/1000)/(4*pi);   % Maximum torque                            [Nm]

    T_CE_idle = T_CE_cutoff;                           % Torque limit for idle                     [Nm]
    
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

    %% creating the efficiency map
    [T,w] = meshgrid(T_CE_col, w_CE_row);
    map_kW=T.*w;
    eta_CE_map = (map_kW./(V_CE_map*H_u))';
    
