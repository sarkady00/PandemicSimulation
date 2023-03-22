function out = Distance(struct)
    temp = [struct.x; struct.y]'; % Coordinates
    D = pdist(temp); % Calculate Euclidesian distances in pairs (2,1),(3,1)...(N,1),(3,2),(4,2)...
    D_m = squareform(D); % Make a symmetric matrix to be able to locate the different points
    out = triu(D_m); % Take the upper triangular matrix of a symmetric matrix
end