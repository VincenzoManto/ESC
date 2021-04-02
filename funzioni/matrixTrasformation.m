function matrixTrasformed = matrixTrasformation(vector)
% This function converts the vector [1x25 double] to a matrix [5x5 double]
%
%   matrixTrasformed = matrixTrasformation(vector) 
%
%   takes the vector representing one Block of the Raw Sound as Input and
%   gives as Output the matrix trasformed
%
% Inputs:   vector:                         [1x25 double]
%
% Outputs:  matrixTrasformed                [5x5 double]
%
%

% Counter defining
counter = 1;

% Initialize the matrix 5x5
matrixTrasformed = NaN(5,5);

% Loop over the Rows of the matrix
for rowMatrixTrasformed = 1:5

    %   Loop over the Columns of the matrix
    for columnMatrixTrasformed = 1:5

        % Inserts the value of the vector in Input in index = counter in
        % the matrix in index (rowMatrixTrasformed, columnMatrixTrasformed)
        matrixTrasformed(rowMatrixTrasformed,columnMatrixTrasformed) = vector(counter);

        % Update the counter             
        counter = counter + 1;

    end

end