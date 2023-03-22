function out = Spread(struct,Dist,critDist,p_inf)
    % Find contacts
    [indRow,indCol] = find((0<Dist) & (Dist<critDist));
%     randNumb = rand();
    
    % Spread of virus
    for ii = 1:length(indRow)
        if struct(indRow(ii)).state == 'I' && struct(indCol(ii)).state == 'S' && rand() <= p_inf
            struct(indCol(ii)).state = 'I';
        end
        if struct(indCol(ii)).state == 'I' && struct(indRow(ii)).state == 'S' && rand() <= p_inf
            struct(indRow(ii)).state = 'I';
        end
    end

    % Cases of death
%     I_ind = find([struct.state] == 'I');
%     for ii = 1:length(I_ind)
%         randNumb = rand();
%         if randNumb <= p_death
%             struct(I_ind(ii)).state = 'D';
%         end
%     end
    
%     struct(struct.state == 'I' && rand() <= p_death).state = 'D';
    
    out = struct;
end