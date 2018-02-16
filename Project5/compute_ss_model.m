function [A_lon,B_lon,A_lat,B_lat] = compute_ss_model(filename,x_trim,u_trim)
% x_trim is the trimmed state,
u = x_trim(4);
v = x_trim(5);
w = x_trim(6);
phi_trim = x_trim(7);
theta_trim = x_trim(8);
psi_trim = x_trim(9);
p_trim = x_trim(10);
q_trim = x_trim(11);
r_trim = x_trim(12);

% u_trim is the trimmed input
delta_e_trim = u_trim(1);
delta_a_trim = u_trim(2);
delta_r_trim = u_trim(3);
delta_t_trim = u_trim(4);

% derived trim values
Va_trim = sqrt(u^2 + v^2 + w^2);
alpha_trim = atan(w/u);
beta_trim = asin(v/Va_trim);

% add stuff here 

% Lateral Coefficients %%%%%
Y_v = P.rho*P.S_wing*P.b*v/(4*P.mass*Va_trim)*(P.C_Y_p*p_trim + P.C_Y_r*r_trim)...
    + P.rho*P.S_wing*v/P.mass*(P.C_Y_0 + P.C_Y_beta*beta_trim + P.C_Y_delta_a...
    *delta_a_trim + P.C_Y_delta_r*delta_r_trim) + P.rho*P.S_wing*P.C_Y_beta...
    /(2*P.mass)*sqrt(u^2 + w^2);

Y_p = w + P.rho*Va_trim*P.S_wing*P.b*P.C_Y_p/(4*P.mass);
Y_r = -u + P.rho*Va_trim*P.S_wing*P.b*P.C_Y_r/(4*P.mass);
Y_delta_a = P.rho*Va_trim^2*P.S_wing*P.C_Y_delta_a/(2*P.mass);
Y_delta_r = P.rho*Va_trim^2*P.S_wing*P.C_Y_delta_r/(2*P.mass);

L_v = P.rho*P.S_wing*P.b^2/(4*Va_trim)*(P.C_p_p*p_trim + P.C_p_r*r_trim) +...
    P.rho*P.S_wing*P.b*v*(P.C_p_0 + P.C_p_beta*beta_trim + P.C_p_delta_a*...
    delta_a_trim + P.C_p_delta_r*delta_r_trim) + P.rho*P.S_wing*P.b*P.C_p_beta...
    /2*sqrt(u^2 + w^2);
L_p = P.Gamma1*q_trim + P.rho*Va_trim*P.S_wing*P.b^2*P.C_p_p/4;
L_r = -P.Gamma2*q_trim + P.rho*Va_trim*P.S_wing*P.b^2*P.C_p_r/4;
L_delta_a = P.rho*Va_trim^2*P.S_wing*P.b*P.C_p_delta_a/2;
L_delta_r = P.rho*Va_trim^2*P.S_wing*P.b*P.C_p_delta_r/2;

N_v = P.rho*P.S_wing*P.b^2*v/(4*Va_trim)*(P.C_r_p*p_trim + P.C_r_r*r_trim)...
    + P.rho*P.S_wing*P.b*v*(P.C_r_0 + P.C_r_beta*beta_trim + P.C_r_delta_a*...
    delta_a_trim + P.C_r_delta_r*delta_r_trim) + ...
    P.rho*P.S_wing*P.b*P.C_r_beta/2*sqrt(u^2 + w^2);
N_p = P.Gamma7*q_trim + P.rho*Va_trim*P.S_wing*P.b^2*P.C_r_p/4;
N_r = -P.Gamma1*q_trim + P.rho*Va_trim*P.S_wing*P.b^2*P.C_r_r/4;
N_delta_a = P.rho*Va_trim^2*P.S_wing*P.b*P.C_r_delta_a/2;
N_delta_r = P.rho*Va_trim^2*P.S_wing*P.b*P.C_r_delta_r/2;

% Longitudinal Coefficients

