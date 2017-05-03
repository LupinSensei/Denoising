function [f, nrj] = block_tnv_denoise(f0, lambda, nb_iter, tol, plot_t)
% --------------------------------------------------------------------
% BLOCK_TNV_DENOISE: DENOISES A 2D IMAGE
%    
%  block_tnv_denoise(f0, lambda, nb_iter, tol, plot_t)
%     f0: noisy image
%     lambda: multiplies l2 fidelity term
%     nb_iter: maximum number of iterations
%     tol: tolerance
%     plot_t: boolean to display or not the intermediate images
% -------------------------------------------------------------------

% -------------------------------------------------------------------
% -- Further work ---
% -------------------
% for now we work with 2x2 blocks, leading to 4 = 2^2 families of 
% partitions. This should be changed later so as the size of the
% cliques becomes a parameter of the function.
% -------------------------------------------------------------------

k = 4; % because we are working with 2x2 blocks

if nargin < 5
    plot_t = 0;
end

if nargin < 4
    tol = 1e-4;
end

if nargin < 3
    nb_iter = 50;
end

nrj = zeros(1, nb_iter);

nu = 10; %
zeta = 1.99; % 
opt.bound = 'per';

nu_lbd = nu * lambda;

lF = 1 + k*laplacian_freq_response(size(f0,1), size(f0,2));

svd_handle = @(x) prox_trace_norm(x.data,nu);

g  =   f0;
f  =   f0;
q1 =   grad(f0);
q2 =   q1;
q3 =   q1;
q4 =   q1;

% -- Les indices des Cliques ---
[indD, indC] = gen_indices(g,sqrt(k));

hwait = waitbar(0, 'Debruitage en cours ...');
fprintf('Running denosing by Block ...\n');
fprintf('iter\t\tPSNR : \n');

for ii = 1:nb_iter
    
    gradt_q = -div((q1 + q2 + q3 + q4), opt);
    f_old = f;
    f = real(ifft2(fft2(gradt_q+g) ./ lF));
    p = grad(f, opt);
    
    %
    g = g + zeta*( (nu_lbd*f0 + 2*f - g) / (nu_lbd + 1) - f);
    % -- Calcule des q1, q2, q3 et q4. --
    % -----------------------------------
    q_resh_1 = reshape(q1,[numel(g),2]);
    q_resh_2 = reshape(q2,[numel(g),2]);
    q_resh_3 = reshape(q3,[numel(g),2]);
    q_resh_4 = reshape(q4,[numel(g),2]);
    
    p_resh = reshape(p,[numel(g),2]);

    q1_resh = q_resh_1(indC{1},:);
    q2_resh = q_resh_2(indC{2},:);
    q3_resh = q_resh_3(indC{3},:);
    q4_resh = q_resh_4(indC{4},:);
    
    p1_c1 = p_resh(indC{1},:);
    p2_c2 = p_resh(indC{2},:);
    p3_c3 = p_resh(indC{3},:);
    p4_c4 = p_resh(indC{4},:);

    % -- result reshaped 
    qc1 = q1_resh + zeta*(blockproc(2*p1_c1-q1_resh,[4,2],svd_handle,'DisplayWaitbar', 0)- p1_c1);
    qc2 = q2_resh + zeta*(blockproc(2*p2_c2-q2_resh,[4,2],svd_handle,'DisplayWaitbar', 0)- p2_c2);
    qc3 = q3_resh + zeta*(blockproc(2*p3_c3-q3_resh,[4,2],svd_handle,'DisplayWaitbar', 0)- p3_c3);
    qc4 = q4_resh + zeta*(blockproc(2*p4_c4-q4_resh,[4,2],svd_handle,'DisplayWaitbar', 0)- p4_c4);

    
    qd1 = q_resh_1(indD{1},:) + zeta*(p_resh(indD{1},:)- q_resh_1(indD{1},:));
    qd2 = q_resh_2(indD{2},:) + zeta*(p_resh(indD{2},:)- q_resh_2(indD{2},:));
    qd3 = q_resh_3(indD{3},:) + zeta*(p_resh(indD{3},:)- q_resh_3(indD{3},:));
    qd4 = q_resh_4(indD{4},:) + zeta*(p_resh(indD{4},:)- q_resh_4(indD{4},:));
    
    q1 = zeros(numel(g),2);
    q2 = zeros(numel(g),2);
    q3 = zeros(numel(g),2);
    q4 = zeros(numel(g),2);
    
    % q1
    q1(indC{1},:) = qc1; 
    q1(indD{1},:) = qd1;
    q1 = reshape(q1, size(g,1), size(g,2), 2);
    
    % q2
    q2(indC{2},:) = qc2;
    q2(indD{2},:) = qd2;
    q2 = reshape(q2, size(g,1), size(g,2), 2);
    
    % q3
    q3(indC{3},:) = qc3;
    q3(indD{3},:) = qd3;
    q3 = reshape(q3, size(g,1), size(g,2), 2);
    
    % q4
    q4(indC{4},:) = qc4;
    q4(indD{4},:) = qd4;
    q4 = reshape(q4, size(g,1), size(g,2), 2);
    
    %-- Le terme de regularisation 
   
    svd_p1 = sum(blockproc(p1_c1,[4,2],@(x) sum(svd(x.data)),'DisplayWaitbar', 0));
    svd_p2 = sum(blockproc(p2_c2,[4,2],@(x) sum(svd(x.data)),'DisplayWaitbar', 0));
    svd_p3 = sum(blockproc(p3_c3,[4,2],@(x) sum(svd(x.data)),'DisplayWaitbar', 0));
    svd_p4 = sum(blockproc(p4_c4,[4,2],@(x) sum(svd(x.data)),'DisplayWaitbar', 0));
    reg = svd_p1 + svd_p2 + svd_p3 + svd_p4;
    
    % ----------------------------
    
    fid = f - f0;
    fid = fid .* fid;
    nrj(ii) = reg + 0.5 * lambda * sum(sum(fid));
    
    % -- PSNR 
    psnrs(ii) = psnr(f,g); 
    % ------------------------------
    if plot_t == 1
        subplot(2, 2, 1), imshow(uint8(I), []), title('Original Image')
        subplot(2, 2, 2), imshow(uint8(f0), []), title('Noisy Image')
        subplot(2, 2, 3), imshow(uint8(f), []), title('Iterate image : Denoised')
        subplot(2, 2, 4),plot(1:ii, log10(1 + nrj(1:ii))), title('Energy')
        drawnow;
    end
    
    fprintf('%g\t\t\t%.2f\t\n',ii, psnrs(ii));
    %
    rnc = abs(norm(f,'fro') - norm(f_old,'fro')) / ...
        norm(f, 'fro'); % relative norm change
    if (rnc < tol)
        break;
    end
waitbar(ii/nb_iter); 
    
end
close(hwait);
fprintf('Done !!\n');
nrj = nrj(1:ii);

end



