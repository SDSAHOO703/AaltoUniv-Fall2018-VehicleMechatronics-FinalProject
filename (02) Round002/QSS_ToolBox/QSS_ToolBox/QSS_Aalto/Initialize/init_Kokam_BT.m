% =======
% Battery
% =======



% #####################################################################################################################

% Global variables
% ----------------
    global BT_mass % battery weight

% #####################################################################################################################

% Battery parameters
% ------------------

cap_BT = 40; % (Ah) cell capacity
soc_map_BT = 0:0.1:1; % SOC
voc_map_BT = [3.457 3.457 3.525 3.573 3.616 3.665 3.729 3.812 3.915 4.027 4.193]; % (V)
rdis_map_BT = [2.65 2.65 2.25 2.45 2.30 1.95 1.80 2.15 2.20 1.85 1.85]/1000; % (Ohm) 
rchg_map_BT = [2.65 2.65 2.25 2.45 2.30 1.95 1.80 2.15 2.20 1.85 1.85]/1000; % (Ohm) 

pack_factor = 2;
weight_factor_BT = 135; % (Wh/kg)
BT_mass = pack_factor*(mean(voc_map_BT)*cell_series_BT*cell_parallel_BT*cap_BT)/weight_factor_BT; % battery weight

% #####################################################################################################################
