% function [f, nrj, psnrs] = denoise_block(f0, lambda, nb_iter, tol, plot_t)
% --------------------------------------------------------------------
% Check : DENOISES A 2D IMAGE
%    
%     f0: noisy image
%     lambda: multiplies l2 fidelity term
%     nb_iter: maximum number of iterations
%     tol: tolerance
%     plot_t: boolean to display or not the intermediate images
% -------------------------------------------------------------------

clc;

k = 4; % because we are working with 2x2 blocks
nu = 10; % � modifier de pour nu > 0
zeta = 1.99; % � modifier pour 0 > zeta > 2
lambdas = linspace(0.1,1,10);
stdRange = linspace(15,25,3);
N = length(lambdas);
opt.bound = 'per';

tol = 1e-6;
plot_t = 1;
nb_iter = 10;

[imgs, nbr_img] = read_images();
nrj = zeros(1, nb_iter);
psnr_i = zeros(1,nbr_img);
ssimval = zeros(1,nbr_img);
psnrs = cell(1, N);
psnrs_mean = zeros(1,N);
ssim_value = cell(1,N);
lambda_op = zeros(1,length(stdRange));
svd_handle = @(x) prox_trace_norm(x.data,nu);

if(~exist('./results'))
    mkdir('./results');
end

fprintf('Running denosing by Block ... \n');
kk = 1;
for std = stdRange
    jj = 1;
     fprintf('Sigma = %g :\n',std);
    for lambda = lambdas
        fprintf('\t lambda = %.2f\n',lambda)
        for im =1:nbr_img
            I = double(imread(imgs{im}));
            I = crop(I,64); % A remettre au 128
            % -- Les indices des Cliques ---
            [indD, indC] = gen_indices(I,sqrt(k));
            %
            f0  = I + std*randn(size(I,1), size(I,2));
            lF = 1 + k*laplacian_freq_response(size(f0,1), size(f0,2));
            g  =   f0;
            f  =   f0;
            q1 =   grad(f0);
            q2 =   q1;
            q3 =   q1;
            q4 =   q1;
            nu_lbd = nu * lambda;
            fprintf('image %g ... \n',im);
            for ii = 1:nb_iter
                  %
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
                if plot_t == 1
                    subplot(2, 2, 1), imshow(uint8(I), []), title('Original Image')
                    subplot(2, 2, 2), imshow(uint8(f0), []), title('Noisy Image')
                    subplot(2, 2, 3), imshow(uint8(f), []), title('Iterate image : Denoised')
                    subplot(2, 2, 4),plot(1:ii, log10(1 + nrj(1:ii))), title('Energy')
                    drawnow;
                end
                %
                rnc = abs(norm(f,'fro') - norm(f_old,'fro')) / ...
                    norm(f, 'fro'); % relative norm change
                if (rnc < tol)
                    break;
                end
            end
            nrj = nrj(1:ii);
            psnr_i(im) = psnr(g,I);
            [ssimval(im),~] = ssim(g,I);
            % -- Sauvgarder les images
            imwrite(uint8(g),['./results/image_',int2str(im),'_std_',int2str(std),'.tiff'],'tiff');
        end
        % -- PSNR
        psnrs_mean(jj) = mean(psnr_i);
        psnrs{1, jj} = psnr_i;
        % -- SSIM
        ssim_value{1, jj} = ssimval;
        jj = jj +1;
    end
    [lambda_op(kk), index] = argmax(psnrs_mean, lambdas);
    save(['./results\results_std_',int2str(std),'.mat'], 'psnrs', 'psnrs_mean', 'lambda_op', 'ssim_value');
    
    fprintf('Pour le niveau de bruit segma = %g lambda Optimale est : %.2f\n', std, lambda_op(kk));
    fprintf('Tableau de PSNR : \n');
    fprintf('\t\t%.3f\t\n',psnrs{1,index})
    fprintf('The SSIM value is %0.4f.\n',ssim_value{1,index});
    kk = kk + 1;
end
disp('Done !!');







