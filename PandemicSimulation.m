clear; close all; clc;
tic;

%% Initializing

% GIF filename
fname = sprintf('PandemicSimulation_%s.gif',datetime('now','Format','yyyy-MM-dd''T''HH-mm-ss'));

% Simulation parameters
timeStep = 24; % How much timestep is a day (now we're in hour scale)

% Initial parameters for population 
N = 10000;
R_I = 10; % Ratio of infected to population (%)
R_R = 0; % Ratio of recovered/protected to population (%)

S = zeros(N,1);
I = zeros(N,1);
R = zeros(N,1);
D = zeros(N,1);

I(1) = R_I/100*N;
R(1) = R_R/100*N;
S(1) = N-I(1)-R(1);
D(1) = 0;

% Describing parameters for covid-19
sickLen = 14*timeStep; % Length of sickness (default 14 days)
periodT = 60*timeStep; % Length of natural protection after sickness (periodicity, default: i.e. 60 days)
P_inf = 0.1; % Infection probability per contact (According to chatGPT)
P_death = 0.02; % Probability of death (not implemented yet) (According to chatGPT)
critDist = 3; % Critical distance (m)

% Parameters for map
P_den = 3250; % Population density 1/km^2 (Budapest)
A = N/P_den*1e6; % Needed area for N people in m^2
H_len = sqrt(A); % m
V_len = sqrt(A); % m
scale = sqrt(A); % Now they can spawn at the whole map (like there is no closed area inside)
mkrSize = 5; % Marker size in animation
Walk = 8000; % Average travel distance a day for people live in Budapest (m) (According to BKK)
Walk_scaled = Walk/timeStep;


% Initial values of people
% Coordinates
x = (rand(1,N)*2-1)*scale/2; % [-1;1] * scale
y = (rand(1,N)*2-1)*scale/2;
% Health state
state(1,1:N) = 'S';
startInd = randperm(N, I(1)+R(1)); % Generate I(1)+R(1) random index for the infected and recovered ones
state(startInd(1:I(1))) = 'I';
if R(1) ~=0
    state(startInd(I(1)+1:end)) = 'R';
end
% Sickness timer
timer = zeros(1,N);
timer(startInd) = randi(sickLen,[1,length(startInd)]); % Randomize the timer for the initialy infected ones
if R(1) ~=0
    timer(startInd(I(1)+1:end)) = randi(periodT,[1,length(startInd(I(1)+1:end))]); % And for the initialy protected ones
end
% Probability and timing of death
death = rand(1,N);
for ii = 1:N %!!!
    if death(ii) <= P_death
        death(ii) = 1;
    else
        death(ii) = 0;
    end
end
dTimer = randi(sickLen,[1,N]); % When will they die if they get sick

% Create empty structure array
Data(N).x = [];
Data(N).y = [];
Data(N).state = [];
Data(N).timer = [];
Data(N).death = [];
Data(N).deathTimer = [];

% Set population structure values
Data = SetStructure(Data,x,y,state,timer,death,dTimer);

% Distance from eachother
Dist = Distance(Data);
disp(['Initialization complete: ',num2str(toc()),'s']);

%% Simulation

% Draw map
f1 = figure;
f1.WindowState = 'Maximized';
Data = Animation(Data,mkrSize,H_len,V_len,S,I,R,D,2,fname);

disp(['Start simulation: ',num2str(toc()),'s']);
ii = 2;
while I(ii-1) ~= 0 && S(ii-1) ~= 0
    % Update sickness timer
    Data = UpdateTimer(Data,sickLen,periodT,P_death);
    % New coords
    Data = BrownianStep(Data,H_len,V_len,Walk_scaled);
    % New distances
    Dist = Distance(Data);
    % Spread 
    Data = Spread(Data,Dist,critDist,P_inf);

    % Update SIR data
    S(ii) = length(find([Data.state] == 'S'));
    I(ii) = length(find([Data.state] == 'I'));
    R(ii) = length(find([Data.state] == 'R'));
    D(ii) = length(find([Data.state] == 'D'));

    % Draw animation
    Data = Animation(Data,mkrSize,H_len,V_len,S,I,R,D,ii,fname);
    drawnow;

    % Procedure control text
    disp(['Population: ',num2str(S(ii)+I(ii)+R(ii)),', Timestep: ', num2str(ii),', Susceptible: ',num2str(S(ii)),', Infected: ',num2str(I(ii)),', Recovered: ',num2str(R(ii)),', Dead: ',num2str(D(ii))]);

    ii = ii+1;
end

disp(['Simulation ended: ',num2str(toc()),'s']);