function vectorDiff = createVectorDifference(matrixTrasformed)
% This function creates a vector [1x9 int] that represents the calculated differences according to the Spiral pattern
%
%   vectorDiff = createVectorDifference(matrixTrasformed)
%
%   takes the matrix trasformed as Input and gives as Output a vector 
%   containing the differences as follow.
%
% Inputs:   matrixTrasformed:               [5x5 double]
%
% Outputs:  vectorDiff:                     [1x9 double]
%
%

% Calculate the differences according to the Spiral pattern
%{%

vectorDiff(1) = matrixTrasformed(3,3) - matrixTrasformed(2,3);
vectorDiff(2) = matrixTrasformed(2,3) - matrixTrasformed(2,4);
vectorDiff(3) = matrixTrasformed(2,4) - matrixTrasformed(4,4);
vectorDiff(4) = matrixTrasformed(4,4) - matrixTrasformed(4,2);
vectorDiff(5) = matrixTrasformed(4,2) - matrixTrasformed(1,2);
vectorDiff(6) = matrixTrasformed(1,2) - matrixTrasformed(1,5);
vectorDiff(7) = matrixTrasformed(1,5) - matrixTrasformed(5,5);
vectorDiff(8) = matrixTrasformed(5,5) - matrixTrasformed(5,1);
vectorDiff(9) = matrixTrasformed(5,1) - matrixTrasformed(1,1);
%}

%{
vectorDiff(1) = matrixTrasformed(1,1) - matrixTrasformed(5,1);
vectorDiff(2) = matrixTrasformed(5,1) - matrixTrasformed(5,2);
vectorDiff(3) = matrixTrasformed(5,2) - matrixTrasformed(1,2);
vectorDiff(4) = matrixTrasformed(1,2) - matrixTrasformed(1,3);
vectorDiff(5) = matrixTrasformed(1,3) - matrixTrasformed(5,3);
vectorDiff(6) = matrixTrasformed(5,3) - matrixTrasformed(5,4);
vectorDiff(7) = matrixTrasformed(5,4) - matrixTrasformed(1,4);
vectorDiff(8) = matrixTrasformed(1,4) - matrixTrasformed(1,5);
vectorDiff(9) = matrixTrasformed(1,5) - matrixTrasformed(5,5);

%}

%{
M
vectorDiff(1) = matrixTrasformed(1,1) - matrixTrasformed(1,4);
vectorDiff(2) = matrixTrasformed(5,2) - matrixTrasformed(5,5);
vectorDiff(3) = matrixTrasformed(2,1) - matrixTrasformed(5,1);
vectorDiff(4) = matrixTrasformed(1,5) - matrixTrasformed(4,5);
vectorDiff(5) = matrixTrasformed(2,2) - matrixTrasformed(2,3);
vectorDiff(6) = matrixTrasformed(4,3) - matrixTrasformed(4,4);
vectorDiff(7) = matrixTrasformed(2,4) - matrixTrasformed(3,4);
vectorDiff(8) = matrixTrasformed(3,2) - matrixTrasformed(4,2);
vectorDiff(9) = matrixTrasformed(3,3);% - matrixTrasformed(5,5);
%}

%{
V
vectorDiff(1) = matrixTrasformed(1,5) - matrixTrasformed(1,1);
vectorDiff(2) = matrixTrasformed(1,1) - matrixTrasformed(5,1);
vectorDiff(3) = matrixTrasformed(5,1) - matrixTrasformed(5,5);
vectorDiff(4) = matrixTrasformed(5,5) - matrixTrasformed(2,5);
vectorDiff(5) = matrixTrasformed(2,5) - matrixTrasformed(2,2);
vectorDiff(6) = matrixTrasformed(2,2) - matrixTrasformed(4,2);
vectorDiff(7) = matrixTrasformed(4,2) - matrixTrasformed(4,4);
vectorDiff(8) = matrixTrasformed(4,4) - matrixTrasformed(3,4);
vectorDiff(9) = matrixTrasformed(3,4) - matrixTrasformed(3,3);
%}
%{
SQ
vectorDiff(1) = matrixTrasformed(3,3);
vectorDiff(2) = matrixTrasformed(2,2) - matrixTrasformed(4,2);
vectorDiff(3) = matrixTrasformed(4,2) - matrixTrasformed(4,4);
vectorDiff(4) = matrixTrasformed(4,4) - matrixTrasformed(2,4);
vectorDiff(5) = matrixTrasformed(2,4) - matrixTrasformed(2,2);
vectorDiff(6) = matrixTrasformed(1,1) - matrixTrasformed(5,1);
vectorDiff(7) = matrixTrasformed(5,1) - matrixTrasformed(5,5);
vectorDiff(8) = matrixTrasformed(5,5) - matrixTrasformed(1,5);
vectorDiff(9) = matrixTrasformed(1,5) - matrixTrasformed(1,1);
%}

%{
D
vectorDiff(1) = matrixTrasformed(1,1);
vectorDiff(2) = matrixTrasformed(2,1) + matrixTrasformed(1,2);
vectorDiff(3) = matrixTrasformed(3,1) + matrixTrasformed(2,2) + matrixTrasformed(1,3);
vectorDiff(4) = matrixTrasformed(4,1) + matrixTrasformed(3,2) + matrixTrasformed(2,3) + matrixTrasformed(1,4);
vectorDiff(5) = matrixTrasformed(5,1) + matrixTrasformed(4,2) + matrixTrasformed(3,3) + matrixTrasformed(2,4) + matrixTrasformed(1,5);
vectorDiff(6) = matrixTrasformed(5,2) + matrixTrasformed(4,3) + matrixTrasformed(3,4) + matrixTrasformed(2,5);
vectorDiff(7) = matrixTrasformed(5,3) + matrixTrasformed(4,4) + matrixTrasformed(3,5);
vectorDiff(8) = matrixTrasformed(5,4) + matrixTrasformed(4,5);
vectorDiff(9) = matrixTrasformed(5,5);
%}