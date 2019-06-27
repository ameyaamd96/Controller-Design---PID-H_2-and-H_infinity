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
Bp1 = Bp(:,1);
Bp2 = Bp(:,2);
Cp1 = Cp(1,:);
Cp2 = Cp(2,:);

Gs1 = ss(Ap,Bp1,Cp1,Dp(1,1));
G1 = tf(Gs1);

Gs2 = ss(Ap,Bp2,Cp1,Dp(2,1));
G2 = tf(Gs1);

Gs3 = ss(Ap,Bp1,Cp2,Dp(1,2));
G3 = tf(Gs3);

Gs4 = ss(Ap,Bp2,Cp2,Dp(2,2));
G4 = tf(Gs4);

H = 1;
M = G3;
impulse(M)
hold on

%%
Kp = 71;
Ki = 20;
Kd = 0;

Gc = pid(Kp,Ki,Kd)

Mc = feedback(G3,Gc)
impulse(Mc)
grid on
