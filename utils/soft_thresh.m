function q = soft_thresh(p,sigma)    
    q = bsxfun(@times,p,max(0, 1-sigma./amplitude(p)));
end

