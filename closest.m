function [oval,ix] = closest(ival,vec,opt);
% [oval,ix] = closest(ival,vec,opt);
% Find the value and index of closest value in a vector
% vec = vector to search
% ival = value to match
% opt  = search option: 'next'=find closest value higher than ival
%                       'prev'=find closest value lower than ival
%                       'abs'= find absolute closest value (default)

if nargin<3
    opt='abs';
end

if strcmp(opt,'abs') % need to work on the other two...
    [~, ix] = min(abs(vec-ival));
    oval=vec(ix);
end

end