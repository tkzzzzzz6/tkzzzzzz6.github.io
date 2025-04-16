function PQ = paddedsize(AB,CD,PARAM )
%PADDEDSIZE Computes padded sizes useful for FFT-based filtering.
%   Detailed explanation goes here
if nargin == 1
    PQ = 2*AB;
elseif nargin ==2 && ~ischar(CD)
    PQ = QB +CD -1;
    PQ = 2*ceil(PQ / 2);
elseif nargin == 2
    m = max(AB);    %maximum dimension
    
    %Find power-of-2 at least twice m.
    P = 2^nextpow(2*m);
    PQ = [P,P];
elseif nargin == 3 && strcmpi(PARAM,'pwr2')
    m = max([AB CD]);   %maximum dimension
    P = 2^nextpow2(2*m);
    PQ = [P,P];
else 
    error('Wrong number of inputs.');

end