%% Clear Everything %%

close all ;
clear all ;
clc ;



%% Load necessary .mat files %%

load ('linkker_driving_cycle.mat') ;



%% Vehicle Data %%

mass_veh = 10500 ;    % Vehicle mass (kg)
mass_payload = 5000 ; % Extra payload (kg)
mass_batt = 221 ;     % Battery mass (kg) 
mass_motor = 1524*2 ; % Motor mass (kg)

C_D = 0.36 ;      % Aerodynamic drag co-efficient
RHO = 1.17 ;      % Density of air (kg/m^3)
A_CS = 12 ;       % Vehicle frontal area (m^2)
f_RR = 0.014 ;    % Rolling friction co-eff
beta = 0 ;        % Slope
trans_eff = 0.9 ; % Transmission efficiency

tyre_dyn_d = 686.5 * 10^(-3) ; % Dynamic tyre diameter (m)
tyre_dyn_r = tyre_dyn_d/2 ;    % Dynamic tyre raduis (m)



%% Compute the max tractive force here %%

speed_m_s = speed_km_h .* (5/18); % Vehicle speed (m/s)
acc_m_s2 = diff(speed_m_s);       % Vehicle acceleration (m/s^2) 
acc_max = max(acc_m_s2);          % Vehicle max acceleration (m/s^2)
speed_max = max(speed_m_s);       % Vehicle max speed (m/s)
g = 9.81 ;                        % Acceleration due to gravity (m/s^2)
mass_total = mass_veh + mass_payload + mass_batt + mass_motor ; % Total mass (kg)

F_RR = f_RR * mass_total * g * cos(beta) ;     % Rolling frictional force (N)
F_aero = 0.5 * C_D * RHO * A_CS * speed_max^2; % Aerodynamic drag force (N)
F_slope = mass_total * g * sin(beta);          % Slope force (N)
F_trac = (mass_total * acc_max) + F_RR + F_aero + F_slope ; % Total tractive force (N)



%% Compute max power and max torque here %%

P_max = (F_trac * speed_max) / 1000 ; % Max Power (kW)



%% Compute max wheel speed and wheel torque here %%

speed_wheel_max = (60 / (2*pi)) * (speed_max / tyre_dyn_r) ; % Max wheel speed (rpm)

T_wheel_max = F_trac * tyre_dyn_r ; % Max wheel torque (Nm)



%% Compute max motor torque and speed here %%

gear_ratio = 5 ;

T_motor_max = T_wheel_max / (gear_ratio * trans_eff) ; % Max motor torque (Nm)

speed_motor_max = speed_wheel_max * gear_ratio ; % Max motor speed (rpm)



%% Fix battery voltage, compute battery power %%

cells_in_series = 192 ;  
cells_in_parallel = 25 ;
nom_cell_voltage = 3.6 ;
P_aux = 10 ;              % Auxiliary load (kW)

P_batt_max = P_max + P_aux ;
U_batt_max = cells_in_series * nom_cell_voltage ;
I_batt_max = (P_batt_max * 1000) / U_batt_max ; 



 













