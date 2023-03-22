function out = UpdateTimer(struct,sickLen,periodT,p_death)

%     struct(struct.state == 'I' || struct.state == 'R').timer = struct(struct.state == 'I' || struct.state == 'R').timer + 1;
% 
%     struct(struct.state == 'R' || struct.timer == periodT).timer = 0;
%     struct(struct.state == 'R' || struct.timer == periodT).state = 'S';
% 
%     struct(struct.state == 'I' || struct.timer == sickLen).timer = 0;
%     struct(struct.state == 'I' || struct.timer == sickLen).state = 'R';

    N = length(struct);
    for ii = 1:N     
        if struct(ii).state == 'I' || struct(ii).state == 'R'
            struct(ii).timer = struct(ii).timer+1;
        end

        if struct(ii).state == 'I' && struct(ii).death
            if struct(ii).deathTimer == 0
                struct(ii).state = 'D';
            end
            struct(ii).deathTimer = struct(ii).deathTimer-1;
        end

        if struct(ii).timer == periodT && struct(ii).state == 'R' % If the final day has finished
            struct(ii).timer = 0;
            struct(ii).state = 'S';
        end

        if struct(ii).timer == sickLen && struct(ii).state == 'I' % If the final day has finished
            struct(ii).timer = 0;
            struct(ii).state = 'R';
            % If they survived they again will have a chance of deacease in
            % the next wave
            struct(ii).death = rand(); 
            if struct(ii).death <= p_death
                    struct(ii).death = 1;
                else
                    struct(ii).death = 0;
            end
            struct(ii).deathTimer = randi(sickLen);
        end
    end
    
    out = struct;
end