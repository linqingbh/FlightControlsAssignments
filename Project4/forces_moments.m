% forces_moments.m
%   Computes the forces and moments acting on the airframe. 
%
%   Output is
%       F     - forces
%       M     - moments
%       Va    - airspeed
%       alpha - angle of attack
%       beta  - sideslip angle
%       wind  - wind vector in the inertial frame
%

function out = forces_moments(x, delta, wind, P)

    % relabel the inputs
    pn      = x(1);
    pe      = x(2);
    pd      = x(3);
    u       = x(4);
    v       = x(5);
    w       = x(6);
    phi     = x(7);
    theta   = x(8);
    psi     = x(9);
    p       = x(10);
    q       = x(11);
    r       = x(12);
    delta_e = delta(1); % elevator
    delta_a = delta(2); % aileron
    delta_r = delta(3); % rudder
    delta_t = delta(4); % throttle
    w_ns    = wind(1); % steady wind - North
    w_es    = wind(2); % steady wind - East
    w_ds    = wind(3); % steady wind - Down
    u_wg    = wind(4); % gust along body x-axis
    v_wg    = wind(5); % gust along body y-axis    
    w_wg    = wind(6); % gust along body z-axis
    
    % compute wind data in NED
    w_n = cos(theta)*cos(psi)*w_ns + cos(theta)*sin(psi)*w_es - sin(theta)*w_ds;
    w_e = (sin(phi)*sin(theta)*cos(psi)-cos(phi)*sin(psi))*w_ns + (sin(phi)*sin(theta)*sin(psi)+cos(phi)*cos(psi))*w_es + sin(phi)*cos(theta)*w_ds;
    w_d = (cos(phi)*sin(theta)*cos(psi)+sin(phi)*sin(psi))*w_ns + (cos(phi)*sin(theta)*sin(psi)-sin(phi)*cos(psi))*w_es + cos(phi)*cos(theta)*w_ds;
    
    % compute air data
    u_w = w_n + u_wg;
    v_w = w_e + v_wg;
    w_w = w_d + w_wg;
    
    u_r = u - u_w;
    v_r = v - v_w;
    w_r = w - w_w;
    
    Va = sqrt(u_r^2 + v_r^2 + w_r^2);
    alpha = atan2(w_r,u_r);
    beta = asin(v_r / Va);
    
    % blending function
    sigma_alpha = (1 + exp(-P.M*(alpha-P.alpha0)) + exp(P.M*(alpha+P.alpha0)))/...
        ((1 + exp(-P.M*(alpha-P.alpha0)))*(1 + exp(M*(alpha+P.alpha0))));
    
    % nonlinear lift model
    C_L_alpha = (1-sigma_alpha)*(P.C_L_0 + P.C_L_alpha*alpha) + sigma_alpha*(2*sign(alpha)*sin(alpha)^2*cos(alpha));
    
    % nonlinear drag model
    C_D_alpha = P.C_D_p + (P.C_L_0 + P.C_L_alpha*alpha)^2/(pi*P.e*P.AR);
    
    % pitching moment
    C_m_alpha = P.C_m_0 + P.C_m_alpha*alpha;
    
    % compute external forces and torques on aircraft
    Force(1) =  0;
    Force(2) =  0;
    Force(3) =  0;
    
    Torque(1) = 0;
    Torque(2) = 0;   
    Torque(3) = 0;
   
    out = [Force'; Torque'; Va; alpha; beta; w_n; w_e; w_d];
end



