clear all;
close all;
clc;

Ap = [-5 -0.96875;-8.3333 -104.1666];
Bp = [55 0;36.667 0.0005];
Cp = [1 0;0 1];
Dp = [0 1;1 0];
pp = minreal(ss(Ap, Bp, Cp, Dp));
ps = tf(pp);

%finding F
qq = Cp'*Cp - Cp'*Dp(1,2)*inv(Dp(1,2)'*Dp(1,2))*Dp(1,2)'*Cp;
aa = Ap - Bp*inv(Dp(1,2)'*Dp(1,2))*Dp(1,2)'*Cp;
rr = - Bp*inv(Dp(1,2)'*Dp(1,2))*Bp';

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
