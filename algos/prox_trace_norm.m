function g = prox_trace_norm(f,lambda)

% computes prox_{\lambda \|.\|_*}(f) by thresholding singular
% values


    % if a==1
    %     %% V1    
    %     [U,S,V] = svd(f);
    %     S_thresh = max(S-lambda,0);
    %     g = U*S_thresh*V';
    % 
    % elseif a==2
        
        %% V2 : economy size
        % %% 23/04/2014                        
        
        [U,S,V] = svd(f,'econ');
        %[U,S,V] = svd(squeeze(f),'econ');
        S_thresh = max(S-lambda,0);        
        g = U*S_thresh*V';
                 
        
                

    % elseif a==3
    %     
    %     %% V2 : economy size
    %     % %% 23/04/2014
    %     
    %     
    %     [U,S,V] = svd(f,'econ');
    %     s = diag(S);
    %     s = max(s-lambda,0);
    %     r = sum(s > 0);
    %     U = U(:,1:r); 
    %     V = V(:,1:r); 
    %     S = diag(s(1:r));
    %     g = U*S*V';



    end
