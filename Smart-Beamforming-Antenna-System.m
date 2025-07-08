clc; clear; close all;

%% ================================
% Step 1: Uniform Linear Array (ULA)
% ----------------------------------
% Create and visualize the basic radiation pattern of a ULA
% without any beam steering
% ----------------------------------
N = 8;                  % Number of antenna elements
d = 0.5;                % Inter-element spacing (in wavelengths)
theta = -90:0.1:90;     % Observation angles (in degrees)
k = 2*pi;               % Wave number (assume λ = 1)

AF = zeros(size(theta));
for n = 1:N
    AF = AF + exp(1j*(n-1)*k*d*sind(theta));  % No steering
end
AF = abs(AF) / max(abs(AF));  % Normalize

figure;
pax1 = polaraxes;
polarplot(pax1, deg2rad(theta), AF, 'LineWidth', 2);
title('Step 1: ULA Radiation Pattern (No Steering)');
pax1.ThetaZeroLocation = 'top';
pax1.ThetaDir = 'clockwise';

pause(2);

%% ================================
% Step 2: Apply Beam Steering
% ----------------------------------
% Beam is steered to a desired angle (e.g., 30 degrees)
% ----------------------------------
theta0 = 30;  % Desired beam direction

AF_steered = zeros(size(theta));
for n = 1:N
    weight = exp(-1j*2*pi*d*(n-1)*sind(theta0));  % Beamforming weight
    AF_steered = AF_steered + weight * exp(1j*(n-1)*k*d*sind(theta));
end
AF_steered = abs(AF_steered) / max(abs(AF_steered));

figure;
pax2 = polaraxes;
polarplot(pax2, deg2rad(theta), AF_steered, 'r', 'LineWidth', 2);
title(['Step 2: Beam Steered towards ', num2str(theta0), '°']);
pax2.ThetaZeroLocation = 'top';
pax2.ThetaDir = 'clockwise';

pause(2);

%% ================================
% Step 3: Compare Multiple Beam Directions
% ----------------------------------
beam_directions = [-30, 0, 30, 60];  % Multiple beam targets

figure;
pax3 = polaraxes;
hold(pax3, 'on');
for i = 1:length(beam_directions)
    t0 = beam_directions(i);
    AF_temp = zeros(size(theta));
    
    for n = 1:N
        w = exp(-1j * 2 * pi * d * (n - 1) * sind(t0));
        AF_temp = AF_temp + w * exp(1j * (n - 1) * k * d * sind(theta));
    end
    
    AF_temp = abs(AF_temp) / max(abs(AF_temp));
    polarplot(pax3, deg2rad(theta), AF_temp, 'LineWidth', 2, ...
              'DisplayName', ['\theta_0 = ' num2str(t0) '°']);
end
legend('show', 'Location', 'southoutside');
title('Step 3: Beamforming in Multiple Directions');
pax3.ThetaZeroLocation = 'top';
pax3.ThetaDir = 'clockwise';

pause(2);

%% ================================
% Step 4: Animate Beam Steering
% ----------------------------------
% Sweep beam from -60 to +60 degrees
% ----------------------------------
figure;
pax4 = polaraxes;

for t0 = -60:5:60
    AF_temp = zeros(size(theta));
    
    for n = 1:N
        weight = exp(-1j*2*pi*d*(n-1)*sind(t0));
        AF_temp = AF_temp + weight * exp(1j*(n-1)*k*d*sind(theta));
    end
    
    AF_temp = abs(AF_temp) / max(abs(AF_temp));
    
    polarplot(pax4, deg2rad(theta), AF_temp, 'b', 'LineWidth', 2);
    title(['Step 4: Beam Steering at \theta_0 = ', num2str(t0), '°']);
    pax4.ThetaZeroLocation = 'top';
    pax4.ThetaDir = 'clockwise';
    pause(0.15);
end

pause(2);

%% ================================
% Step 5: Modularize as Function
% ----------------------------------
% You can now call the function below for custom direction
% ----------------------------------

beamform_ula(N, d, 45);   % Example: steer to 45°

% === Function for Beamforming ===
function beamform_ula(N, d, theta0)
    theta = -90:0.1:90;
    k = 2*pi;
    AF = zeros(size(theta));
    
    for n = 1:N
        weight = exp(-1j*2*pi*d*(n-1)*sind(theta0));
        AF = AF + weight * exp(1j*(n-1)*k*d*sind(theta));
    end
    
    AF = abs(AF) / max(abs(AF));
    
    figure;
    pax = polaraxes;
    polarplot(pax, deg2rad(theta), AF, 'LineWidth', 2);
    title(['Step 5: Beamforming to \theta_0 = ' num2str(theta0) '°']);
    pax.ThetaZeroLocation = 'top';
    pax.ThetaDir = 'clockwise';
end
