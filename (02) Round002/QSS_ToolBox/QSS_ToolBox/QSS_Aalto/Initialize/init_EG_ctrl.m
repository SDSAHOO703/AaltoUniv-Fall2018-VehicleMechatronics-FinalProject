% ==================
% Generator Control
% ==================



% #####################################################################################################################

% Global variables
% ----------------
    global h                            % Stepsize [s] from block "Driving Cycle"
    global w_CE_max
    global T_CE_max
    
% #####################################################################################################################

power_max = 0.9*interp1(w_CE_max, T_CE_max.*w_CE_max, ctrl_speed*pi/30);
