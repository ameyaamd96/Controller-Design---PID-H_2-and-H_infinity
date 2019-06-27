clear all;
close all;
clc;

Ap = [-5 -0.96875;-8.3333 -104.1666];
Bp = [55 0;36.667 0.0005];
Cp = [1 0;0 1];
Dp = [0 1;1 0];
np = max(size(Ap));
pp = minreal(ss(Ap, Bp, Cp, Dp));
ps = tf(pp);

We = [tf(1,[1 0.001]) tf(1,[1 0.001]);tf(1,[1 0.001]) tf(1,[1 0.001])];
[Ae,Be,Ce,De] = ssdata(We);
ne = max(size(Ae));

Wu = [tf([1 2],[1 10]) tf([1 2],[1 10]);tf([1 2],[1 10]) tf([1 2],[1 10])];
[Au,Bu,Cu,Du] = ssdata(Wu);
nu = max(size(Au));

A = [Ap, zeros(np,ne), zeros(np,nu); -Be*Cp,Ae,zeros(ne,nu);zeros(nu,np),zeros(nu,ne),Au];
B2 = [Bp; zeros(ne,2); Bu];
B1 = [Bp, zeros(np,2); zeros(ne,2),Be; zeros(nu,2), zeros(nu,2)];
C1 = [zeros(2,np),Ce,zeros(2,nu);zeros(2,np),zeros(2,ne),Cu];
D12 = [zeros(2,nu);Du];
C2 = [-Cp,zeros(2,ne),zeros(2,nu)];
D21 = [0,1];

%finding F
qq = C1'*C1 - C1'*D12*inv(D12'*D12)*D12'*C1;
aa = A - B2*inv(D12'*D12)*D12'*C1;
rr = - B2*inv(D12'*D12)*B2';

x2 = are(aa,-rr,qq);
F = -inv(Dp(1,2)'*Dp(1,2)) * (Bp'*x2 + Dp(1,2)'*Cp);

%finding L
qq = Bp*Bp' - Bp*Dp(2,1)'*inv(Dp(2,1)*Dp(2,1)')*Dp(2,1)*Bp';
aa = Ap' - Cp'*inv(Dp(2,1)*Dp(2,1)')*Dp(2,1)*Bp';
rr = - Cp'*inv(Dp(2,1)*Dp(2,1)')*Cp;

y2 = are(aa,-rr,qq);
L = -(y2*Cp' + Bp*Dp(2,1)') * inv(Dp(2,1)*Dp(2,1)');

Ac = Ap + Bp*F + L*Cp;
Bc = -L;
Cc = F;
Dc = 0;

K = minreal(ss(Ac, Bc, Cc, Dc));
Ks = tf(K);

S = 1/(1 + ps*Ks);
T = 1 - S;
L = ps * Ks;

% subplot(221)
% bode(S,T,L)
% grid on;
% legend('Sensitivity','Complementary','Loop')
% subplot(212)
% step(ps);
% hold on;
% step(T);
% grid on;

subplot(221)
impulse(pp);
grid on;
% 
subplot(212)
impulse(-K);
