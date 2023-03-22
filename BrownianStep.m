function out = BrownianStep(struct,sidex,sidey,Walk)
    N = length(struct);
    dt = 0.01; % Stepsize
    dW = sqrt(dt)*randn(N,2);
    stepScale = Walk/max(max(dW)); % Scaling travel distance increment to timescale
    dW = sqrt(dt)*randn(N,2)*stepScale; % Standard Brown spacial step /hour

    Coords = [[struct.x]'+dW(:,1),[struct.y]'+dW(:,2)];

    % If they would go outside, reflect them with the same angle (like a
    % flat mirror)
    for ii = 1:length(Coords)
        if abs(Coords(ii,1)) > sidex/2
            Coords(ii,1) = sign(Coords(ii,1))*(sidex/2 - (abs(Coords(ii,1)) - sidex/2));
        end
        if abs(Coords(ii,2)) > sidey/2
            Coords(ii,2) = sign(Coords(ii,2))*(sidey/2 - (abs(Coords(ii,2)) - sidey/2));
        end
    end

    struct = arrayfun(@(s,v) setfield(s,'x',v), struct, Coords(:,1)');
    struct = arrayfun(@(s,v) setfield(s,'y',v), struct, Coords(:,2)');

    out = struct;
end