% ==================
% Electric Generator
% ==================



% #####################################################################################################################

% Global variables
% ----------------
    global h                            % Stepsize [s] from block "Driving Cycle"
    global eta_EG_map
    global w_EG_row
    global T_EG_col
    global w_EG_max
    global T_EG_max
    
    global w_CE_max
    global T_CE_max
    
% #####################################################################################################################

% Load data
% ---------
load data_UQM_EG

    w_EG_upper = max(w_EG_max);         % Upper limit generator speed       [rad/s]
    
    scale_EG = ((max(w_CE_max.*T_CE_max)/max(w_EG_max.*T_EG_max))/0.75)/1.85;
    
    T_EG_col = scale_EG * T_EG_col;     % Scale generator torque
    T_EG_max = scale_EG * T_EG_max;

% #####################################################################################################################


