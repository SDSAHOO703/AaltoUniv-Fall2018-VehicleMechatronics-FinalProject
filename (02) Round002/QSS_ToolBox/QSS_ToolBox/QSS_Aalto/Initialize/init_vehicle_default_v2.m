% =======
% Vehicle
% =======



% #####################################################################################################################

% Global variables
% ----------------
    global h                    % Stepsize [s] from block "Driving Cycle"
    global BT_mass
    global SC_mass
    
% #####################################################################################################################

% Constants
% ---------
    g           = 9.81;         % Gravitation constant
    rho         = 1.18;         % Air density
    
% Parameters conversion
% ---------------------
    mt2m_f      = mt2m_f/100;	% The user made the input in [%]
    r_wheel     = d_wheel/2;	% The user specified the diameter, not the radius
    
    if (isempty(BT_mass) && ~isempty(SC_mass))
        m_f = m_f + SC_mass;
    elseif (~isempty(BT_mass) && isempty(SC_mass))
        m_f = m_f + BT_mass;
    elseif (~isempty(BT_mass) && ~isempty(SC_mass))
        m_f = m_f + BT_mass + SC_mass;
    end
    
% #####################################################################################################################
