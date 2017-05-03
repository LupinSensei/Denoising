function [val, ind] = argmax(psnrs, lambdas)
    [~,ind] = max(psnrs);
    val = lambdas(ind);
end