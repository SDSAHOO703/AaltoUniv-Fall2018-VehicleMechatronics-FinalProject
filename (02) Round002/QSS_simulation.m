% Script for simulating QSS models
%==================================

% selection of the simulation type --> sim_type
%===============================================
% 0) parameter initialization for electric vehicle
% 1) single simulation
% 2) electric vehicle driving range --> qss_example_electric.mdl
% 3) series hybrid vehicle dimensioning --> qss_example_series.mdl
% 4) simulation of predefined number of cycles

clc; 

sim_type = 0;

% name of the simulation model
if sim_type == 0
	model_name = 'qss_example_electric';
elseif sim_type == 1
    model_name = 'qss_example_electric';
elseif sim_type == 2
    model_name = 'qss_example_electric';
elseif sim_type == 3
    model_name = 'qss_example_series';
elseif sim_type == 4
    model_name = 'qss_example_series_pi';
    nbr_cycles = 10;
end

% PARAMETER INITIALIZATION FOR ELECTRIC VEHICLE
%===============================================
if strfind(model_name, 'electric')
    % battery file choices: Kokam (init_Kokam_BT), EB (init_EB_BT), Altairnano (init_AltairNano_BT)
    battery_file_name = 'init_Kokam_BT'; %'init_AltairNano_BT'; %'init_Saft_BT'; %'init_EB_BT'; % 
    % battery initial state of charge
    battery_init_soc = 0.9;
    % cells in series in the battery
    battery_cell_s = 192;
    % cells in parallel in the battery
    battery_cell_p = 6;
end


switch sim_type
    
    % SINGLE SIMULATION
    %===============================================
    case 1
    
        sim(model_name);    

    
	% ELECTRIC VEHICLE DRIVING RANGE
    %===============================================
    case 2
        
        % target (final) battery state-of-charge
        soc_target = 0.2;
        soc_final = battery_init_soc;
        cycles = 0;
        
        % battery state of charge and energy consumption
        soc_vec = []; nrj_vec = []; spd_vec = [];
        
        % simulation loop until the target SOC is reached
        while (soc_final > soc_target)
            % initialization of the battery SOC
            battery_init_soc = soc_final;
            % model simulation
            sim(model_name);
            % counting the driving cycles
            cycles = cycles + 1;
            disp(['Cycle: ' num2str(cycles)])
            % final SOC at the end of the driving cycle
            soc_final = q_BT(end);
            % saving the results in a vector
            soc_vec = [soc_vec; q_BT];
            spd_vec = [spd_vec; v];
            
            if cycles == 1
                nrj_vec = E_BT;
                %soc_vec = q_BT;
            else
                nrj_vec = [nrj_vec; nrj_vec(end)+E_BT];
                %soc_vec = [soc_vec; soc_vec(end)+q_BT];
            end
        end
        
        dist_km = cycles*max(x_tot)/1000;
        disp(['Total distance: ' num2str(round(dist_km*10)/10) ...
            ' km - Energy consumption: ' num2str(round(nrj_vec(end)/dist_km*10)/10) ' Wh/km'])

	% COMPONENT SIZE SIMULATION FOR SERIES HYBRID VEHICLE
    %===============================================
    case 3
        
        % Before simulations, simulation model needs to be parameterized!!!
        
        results = [];
        cell_nbr = [50 80 110];
        Vdisp = [1.0 1.25 1.5 1.75];
        cycles = 0;
        
        for i_k = 1:length(cell_nbr)
            
            battery_cell_s = cell_nbr(i_k);
                
            for i_n = 1:length(Vdisp)
                
                V = Vdisp(i_n);

                battery_init_soc = 0.7;
                soc_delta = 1;
                % simulation until the initial and final SOC are close enough each other
                while (soc_delta > 0.01)
                    % model simulation
                     sim(model_name);
                    % difference of the initial and final SOC
                    soc_delta = abs(battery_init_soc-q_BT(end));
                    % definition a new initial SOC
                    battery_init_soc = (battery_init_soc+q_BT(end))/2;
                    % soc too low
                    if (battery_init_soc < 0.2)
                        disp('Battery SOC too low'); 
                        soc_delta = 0;
                        V_liter(:) = NaN;
                    end
                end

                cycles = cycles + 1;
                disp(['Cycle: ' num2str(cycles)])
           
                eta1_BT = trapz(t(P_BT>0), P_BT(P_BT>0))/trapz(t(P_BT>0), P_BT(P_BT>0)+L_BT(P_BT>0));
                eta2_BT = trapz(t(P_BT<0), P_BT(P_BT<0))/trapz(t(P_BT<0), P_BT(P_BT<0)-L_BT(P_BT<0));
                eta_BT = eta1_BT*eta2_BT;

                results(i_k,i_n,1) = V_liter(end);      % fuel consumption
                results(i_k,i_n,2) = soc_delta;         % soc deviation
                results(i_k,i_n,3) = battery_init_soc;  % battery initial SOC
                results(i_k,i_n,4) = eta_BT;            % battery roundtrip efficiency
                results(i_k,i_n,5) = min(q_BT);         % min battery SOC
                results(i_k,i_n,6) = min(U_BT);         % min battery voltage
            end
        end
        
	% SIMULATION OF MULTIPLE CYCLES
    %===============================================
    case 4
        
        % target (final) battery state-of-charge
        battery_init_soc = 0.9;
        soc_final = battery_init_soc;
        cycles = 0;
        
        % battery state of charge and energy consumption
        soc_vec = []; spd_vec = []; batt_pwr = []; eng_pwr = [];
        
        % simulation loop until the target SOC is reached
        for i_k = 1:nbr_cycles
            % initialization of the battery SOC
            battery_init_soc = soc_final;
            % model simulation
            sim(model_name);
            % counting the driving cycles
            cycles = cycles + 1;
            disp(['Cycle: ' num2str(cycles)])
            % final SOC at the end of the driving cycle
            soc_final = q_BT(end);
            % saving the results in a vector
            soc_vec = [soc_vec; q_BT];
            spd_vec = [spd_vec; v];
            batt_pwr = [batt_pwr; P_BT];
            eng_pwr = [eng_pwr; w_CE.*T_CE];
            
        end
        
        dist_km = cycles*max(x_tot)/1000;
        nrj_km = (sum(batt_pwr)/3600+sum(eng_pwr)/3600)/dist_km;
        disp(['Total distance: ' num2str(round(dist_km*10)/10) ...
            ' km - Energy consumption: ' num2str(round(nrj_km*10)/10) ' Wh/km'])
end

