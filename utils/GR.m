clear;    
clc;
    A = reshape(1:36,6,6);
    A = A + 15 * randn(size(A,1), size(A,2));
    
    ind = gen_indices(A)
    
    q1 = grad(A);
    q2 = q1;
    q3 = q1;
    q4 = q1;

%     disp('Sizes : ');
%     size(q1)
%     size(q2(2:end-1,:,:))
%     size(q1(:,2:end-1,:))
%     size(q1(2:end-1,2:end-1,:))
%     
%     disp('Nombre des elements : ');
%     numel(q1)
%     numel(q2(2:end-1,:,:))
%     numel(q3(:,2:end-1,:))
%     numel(q1(2:end-1,2:end-1,:))

    q1_resh = reshape(q1,[numel(A),2]);
%     q2_resh = reshape(q2(2:end-1,:),[numel(A(2:end-1,:)),2]);
%     q3_resh = reshape(q3(:,2:end-1),[numel(A(:,2:end-1)),2]);
%     q4_resh = reshape(q4(2:end-1,2:end-1),[numel(A(2:end-1,2:end-1)),2]);
    
    
    q1 = q1_resh(ind{1},:);
    q2 = q1_resh(ind{2},:);
    q3 = q1_resh(ind{3},:);
    q4 = q1_resh(ind{4},:);
    
        disp('Sizes : ');
    size(q1)
    numel(q1)
    size(q2)
    numel(q2)
    size(q3)
    numel(q3)
    size(q1)
    
    % --  
    A=A(setdiff(1:length(A),ind));
    A(ind) = [];
    
%     p_c1 = reshape(p,[numel(g),2]);
%     p_c2 = reshape(p(2:end-1,:),[numel(g(2:end-1,:)),2]);
%     p_c3 = reshape(p(:,2:end-1),[numel(g(:,2:end-1)),2]);
%     p_c4 = reshape(p(2:end-1,2:end-1),[numel(g(2:end-1,2:end-1)),2]);
%     
%     
%     p1_c1 = P1_c1(ind1,:);
%     p2_c2 = P2_c2(ind2,:);
%     p3_c3 = p3_c4(ind3,:);
%     p4_c4 = p4_c4(ind4,:);