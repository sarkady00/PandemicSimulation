function out = Animation(struct,mkrSize,H_len,V_len,S,I,R,D,iteration,fname)

    % Draw popultation movement
    subplot(1,2,1);
    Data_table = struct2table(struct);
    Data_table = sortrows(Data_table,"state"); % Sort data to separate them by health state (For plotting purposes only)
    S_ind = find(cell2mat(Data_table.state) == 'S',1);
    I_ind = find(cell2mat(Data_table.state) == 'I',1);
    R_ind = find(cell2mat(Data_table.state) == 'R',1);
    if isempty(R_ind)
        R_ind = S_ind;
    end
    struct = table2struct(Data_table);
    struct = struct'; % Convert back for further use

    % Plot population with different colors
    scatter(Data_table.x(S_ind:end),Data_table.y(S_ind:end),mkrSize,'filled','o','MarkerFaceColor','Blue');
    hold on
    scatter(Data_table.x(I_ind:R_ind),Data_table.y(I_ind:R_ind),mkrSize+4,'filled','o','MarkerFaceColor','Red');
    scatter(Data_table.x(R_ind:S_ind),Data_table.y(R_ind:S_ind),mkrSize,'filled','o','MarkerFaceColor','Green');
    
    box on;
    xlim([-H_len/2 H_len/2]);
    ylim([-V_len/2 V_len/2]);
    xlabel('x (m)');
    ylabel('y (m)');
    legend('Susceptible','Infected','Recovered','NumColumns',3,'Location','northoutside');
    legend('boxoff');
    hold off

    % Plot live SIRD data
    subplot(1,2,2);
    plot(1:1:iteration-1,S(1:iteration-1),'b-', 1:1:iteration-1,I(1:iteration-1),'r-', 1:1:iteration-1,R(1:iteration-1),'g-',1:1:iteration-1,D(1:iteration-1),'k-');
    ylim([0 length(struct)]);
    box on;
    legend('Susceptible','Infected','Recovered','Dead','NumColumns',4,'Location','northoutside');
    legend('boxoff');
    xlabel('Time (h)');
    ylabel('Number of people');
    exportgraphics(gcf,fname,'Append',true);
    
    out = struct;
end