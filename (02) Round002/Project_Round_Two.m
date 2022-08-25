%% Clear Everything %%

close all ;
clear all ;
clc ;



%% Load necessary .mat files %%

load('linkker_driving_cycle.mat') ;



%% Vehicle Data %%

mass_veh = 10500 ;      % Vehicle mass (kg)
mass_payload = 5000 ;   % Extra payload (kg)
mass_batt = 663.5 ;     % Battery mass (kg) 
mass_motor = 1524*2 ;   % Motor mass (kg)

C_D = 0.36 ;      % Aerodynamic drag co-efficient
RHO = 1.17 ;      % Density of air (kg/m^3)s
A_CS = 12 ;       % Vehicle frontal area (m^2)
f_RR = 0.014 ;    % Rolling friction co-eff
beta = 0/100 ;        % Slope
trans_eff = 0.9 ; % Transmission efficiency

tyre_dyn_d = 686.5 * 10^(-3) ; % Dynamic tyre diameter (m)
tyre_dyn_r = tyre_dyn_d/2 ;    % Dynamic tyre raduis (m)




%% Compute the max tractive force here %%

speed_m_s = speed_km_h .* (5/18); % Vehicle speed (m/s)
acc_m_s2 = diff(speed_m_s);       % Vehicle acceleration (m/s^2) 
acc_max = max(acc_m_s2);          % Vehicle max acceleration (m/s^2)
speed_max = 180 * (5/18);         % Vehicle max speed (m/s)
g = 9.81 ;                        % Acceleration due to gravity (m/s^2)
mass_total = round(mass_veh + mass_payload + ...
             mass_batt + mass_motor) ; % Total mass (kg)

F_RR = round(f_RR * mass_total * g * cos(beta)) ;     % Rolling frictional force (N)
F_aero = round(0.5 * C_D * RHO * A_CS * speed_max^2) ; % Aerodynamic drag force (N)
F_slope = round(mass_total * g * sin(beta));          % Slope force (N)
F_iner = round(mass_total * acc_max) ;
F_trac = round(F_iner + F_RR + F_aero + F_slope) ; % Total tractive force (N)
F_max = round(3000 * (4448/1000)) ;
v_Fmax = round(30 * (44.7/100)) ;



%% Compute max power and max torque here %%

P_max = round((F_max * v_Fmax) / ((1 - 0.2) * 1000)) ; % Max Power (kW)



%% Compute max wheel speed and wheel torque here %%

speed_wheel_max = round((60 / (2*pi)) * (speed_max / tyre_dyn_r)) ; % Max wheel speed (rpm)

T_wheel_max = round(F_max * tyre_dyn_r) ; % Max wheel torque (Nm)



%% Compute max motor torque and speed here %%

gear_ratio = 5 ;

T_motor_max = round(T_wheel_max / (gear_ratio * trans_eff)) ; % Max motor torque (Nm)

speed_motor_max = round(speed_wheel_max * gear_ratio) ; % Max motor speed (rpm)



%% Fix battery voltage, compute battery power %%

cells_in_series = 192 ;    
cells_in_parallel = 6 ;
nom_cell_voltage = 3.6 ;   % Nominal cell voltage (V)
P_aux = 10 ;               % Auxiliary load (kW)

P_batt_max = round(P_max + P_aux) ; % Maximum battery power (kW)
U_batt_max = round(cells_in_series * nom_cell_voltage) ; % Maximum battery voltage (V)
I_batt_max = round((P_batt_max * 1000) / U_batt_max) ;   % Maximum battery current (A)



%% QSS_simulation %%

%%% Please run QSS_simulation.m file %%%

QSS_simulation ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Further Calculations %%

clc ;



%% Regenerative Energy %%

%%% Simulate .slx file here %%%
sim('Project_Vehicle_Model_Round_Two.slx') ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc ;
p_data = Total_Power.data ;
[r,c] = size(p_data);
P_reg = [] ;
for i=1:r
    if (p_data(i,1)<0)
        P_reg = vertcat(P_reg, p_data(i,1)); 
    end
end

P_REG = P_reg.*(-1);
E_REG = cumtrapz(P_REG);
E_REG_Wh = E_REG./(3600);
E_REG_kWh = E_REG_Wh ./ 1000 ;
E_REG_kWh_tot = E_REG_kWh(end) ;


%%% plot of regenerative energy %%%
time_01 = linspace(0,1923,size(E_REG_kWh,1))' ;
figure(1)
plot(time_01, E_REG_kWh, 'LineWidth', 2); 
grid on;
xlim([time_01(1) time_01(end)]) ;
xlabel('Time [secs]','Interpreter','Latex','FontSize',24); 
ylabel('$E_{\rm reg}$ [kWh]','Interpreter','Latex','FontSize',24);
title('Regenerative Energy (for 1 Cycle)','FontName','Times New Roman',...
      'FontSize',24) ;
set(gca,'Ticklabelinterpreter','Latex','FontSize',24) ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Energy %%

clc ;

time_02 = linspace(0,1923,size(E_BT,1))' ;
E_REG_kWh_remodelled = linspace(0,E_REG_kWh_tot,size(E_BT,1))' ;
dist = cumtrapz(speed_km_h) ; 
dist_end = dist(end) ;
E_cons_kWh = (E_BT ./ 1000) - E_REG_kWh_remodelled ;  % instantaneous energy in 1 cycle
E_cons_kWh_tot = round(E_cons_kWh(end)) ;  % total energy in 1 cycle
E_cons_kWh_per_km = E_cons_kWh / dist_end ; 
E_cons_kWh_per_100km = round(E_cons_kWh_per_km * 100) ; % energy consumption (kWh/100km) 


%%% plot of instantaneous energy %%
figure(2)
plot(time_02,E_cons_kWh,'Color',[0.00 0.38 0.11],'LineWidth',2) ;
grid on ;
xlim([time_02(1) time_02(end)]) ;
xlabel('Time [secs]','Interpreter','Latex','FontSize',24); 
ylabel('Energy Consumed [kWh]','Interpreter','Latex','FontSize',24);
title('Energy Consumed in 1 Cycle','FontName','Times New Roman',...
      'FontSize',24) ;
set(gca,'Ticklabelinterpreter','Latex','FontSize',24) ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Operating Range %%

nom_cell_capacity = 40 ;  % nominal cell capacity (Ah)
cell_capacity_tot = nom_cell_capacity * cells_in_parallel ; % Total cell capacity (Ah)
op_range = round((U_batt_max*cell_capacity_tot)/1822.72) ; % Operating range (km)











    



 













