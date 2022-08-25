% ==============
% CVT Controller
% ==============



% #####################################################################################################################

% Global variables
% ----------------
    global h                                        % Stepsize [s] from block "Driving Cycle"

% #####################################################################################################################

% Operating points, the control system considers to be optimum
% ----------------------------------------------------------------
    w_CVT_opt       = [50 100 150 200 370 700];     % CVT speed [rad/s]
    P_CVT_opt       = [-9 3 6 10 20 40] * 1000;     % CVT power [W] 
    
% Compute optmimal torque
% -----------------------
    T_CVT_opt       = P_CVT_opt ./ w_CVT_opt;       % CVT torque [Nm]

% #####################################################################################################################
    