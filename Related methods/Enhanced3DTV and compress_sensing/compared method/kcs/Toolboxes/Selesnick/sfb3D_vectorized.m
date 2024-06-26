function y = sfb3D_vectorized(LLL,LLH,LHL,LHH,HLL,HLH,HHL,HHH, sf1, sf2, sf3)

% Modified by Mike Wakin from Ivan Selesnick's original function

% filter along dimension 3
LL = sfb3D_A(LLL, LLH, sf3, 3);
LH = sfb3D_A(LHL, LHH, sf3, 3);
HL = sfb3D_A(HLL, HLH, sf3, 3);
HH = sfb3D_A(HHL, HHH, sf3, 3);

% filter along dimension 3
L = sfb3D_A(LL, LH, sf2, 2);
H = sfb3D_A(HL, HH, sf2, 2);

% filter along dimension 1
y = sfb3D_A(L, H, sf1, 1);


% LOCAL FUNCTION

function y = sfb3D_A(lo, hi, sf, d)

% 3D Synthesis Filter Bank
% (along single dimension only)
%
% y = sfb3D_A(lo, hi, sf, d);
% sf - synthesis filters
% d  - dimension of filtering
% see afb2D_A

lpf = sf(:, 1);     % lowpass filter
hpf = sf(:, 2);     % highpass filter

% permute dimensions of lo and hi so that dimension d is first.
p = mod(d-1+[0:2], 3) + 1;
lo = permute(lo, p);
hi = permute(hi, p);

[N1, N2, N3] = size(lo);
N = 2*N1;
L = length(sf);
y = zeros(N+L-2, N2, N3);

for k = 1:N3
   y(:, :, k) = upfirdn(lo(:, :, k), lpf, 2, 1) + upfirdn(hi(:, :, k), hpf, 2, 1);
end
y(1:L-2, :, :) = y(1:L-2, :, :) + y(N+[1:L-2], :, :);
y = y(1:N, :, :);
y = cshift3D(y, 1-L/2, 1);

% permute dimensions of y (inverse permutation)
y = ipermute(y, p);


