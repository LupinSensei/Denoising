function mat_ind = matrix2index(mat)
% -----------------------------------------
% -- Function to convert matrix element
% -- to matrix indices : matrix2index(mat)
% -- Parametres : 
% --       intput : 
% --            mat : matrix
% --       output :
% --            mat_ind : matrix of indices
% -- Example : 
% -- A =
% --    2.3858    2.3894    2.1497
% --    2.8665    2.2850    2.8943
% --    2.7239    2.0601    2.3087
% -----------------------------------------
% -- ind_ =
% --     1     4     7
% --     2     5     8
% --     3     6     9
% -----------------------------------------
% -- Author : El Houcine Latif 2017
% -----------------------------------------
    mat_ind = reshape(1:numel(mat), size(mat,1), size(mat,2));
end