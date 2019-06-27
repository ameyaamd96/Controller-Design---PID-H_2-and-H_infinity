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

nmeas = 1;
ncont = 1;
[K,CL,gamma] = h2syn(pp,nmeas,ncont);
rl = 0;
ru  = 100;
gamma = 5;
r1 = Dp(1,2)'*Dp(1,2);
r2 = Dp(2,1)*Dp(2,1)';

% tol=0.1;
% [Kinf,Tzwinf,GAMinf]=hinfsyn(pp,nmeas,ncont,rl,ru,tol);

aa = Ap - Bp*inv(r1)*Dp(1,2)'*Cp;
rr = (gamma^-2*Bp*Bp' - Bp*inv(r1)*Bp');
ct1 = (eye(max(size(Dp))) - Dp(1,2)*inv(r1)*Dp(1,2)')*Cp;
qq = ct1'*ct1;

Xinf = are(aa,-rr,qq);
%Finf = -Bp'*Xinf;
Finf = -inv(r1)*(Bp'*Xinf + Dp(1,2)'*Cp);

%finding L
aa = (Ap - Bp*Dp(2,1)'*inv(r2)*Cp)';
rr = (gamma^-2*Cp'*Cp - Cp'*inv(r2)*Cp);
bt1 = Bp*(eye(max(size(Dp)))-Dp(2,1)'*inv(r2)*Dp(2,1));
qq = bt1*bt1';

Yinf = are(aa,-rr,qq);
% Linf = -Yinf*Cp';
Zinf = inv(eye(size(Ap))-gamma^-2*Yinf*Xinf);
Linf = -Zinf*(Yinf*Cp' + Bp*Dp(2,1)')*inv(r2);

Ainf = Ap + gamma^-2*(Bp*Bp' + Linf*Dp(2,1)*Bp')*Yinf + Bp*Finf + Linf*Cp;
Binf = -Linf;
Cinf = Finf;
Dinf = 0;
Ksub = minreal(ss(Ainf,Binf,Cinf,Dinf));
Ksubs = tf(Ksub);

S = 1/(1+ps*Ksubs);
T = 1-S;
L = ps*Ksubs;
% bode(S,T,L)
subplot(211)
impulse(ps);

grid on

subplot(212)
impulse(-Ksubs);