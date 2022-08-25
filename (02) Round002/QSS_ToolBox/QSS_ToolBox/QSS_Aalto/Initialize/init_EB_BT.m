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

cap_BT = 45; % (Ah) cell capacity
soc_map_BT = 0:0.1:1; % SOC
voc_map_BT = [2.50 3.10 3.17 3.19 3.205 3.22 3.235 3.25 3.26 3.27 3.28]; % (V)
rdis_map_BT = ones(1,size(soc_map_BT, 2))*2.0/1000; % (Ohm) 
rchg_map_BT = ones(1,size(soc_map_BT, 2))*2.0/1000; % (Ohm) 

pack_factor = 2;
weight_factor_BT = 146; % (Wh/kg)
BT_mass = pack_factor*(mean(voc_map_BT)*cell_series_BT*cell_parallel_BT*cap_BT)/weight_factor_BT; % battery weight

% #####################################################################################################################
