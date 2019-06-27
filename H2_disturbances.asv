clear all;
close all;
clc;

A = [-5 -0.96875;-8.3333 -104.1666];
Bu = [55 0;36.667 0.0005];
Bw = [0 0;0 1];
nx = 2; nu = 2;
nz = 2; nw = 2;
Cz = [1 0;0 0];
Du = [1 0; 0 1];
cvx_begin sdp
variable X(nx,nx) symmetric
variable W(nz,nz) symmetric
variables Z(nu,nx) gam
[A Bu]*[X;Z] + [X Z']*[A';Bu'] + Bw*Bw' < 0
[W (Cz*X + Du*Z); (Cz*X + Du*Z)' X] > 0
minimize trace(W)
cvx_end
h2K = Z*inv(X);
[lqrKs] = pid(A,Bu,Cz'*Cz,Du'*Du);
g11=tf([-4 50 55],[1 1 0]);
g12=tf([-8.33 36.7],[1 0]);
g21=-0.969;
g22=tf([0.06994 0.03405 0.004153 2.892e-005],[1 2.462 0.986 0.1108 0.0007886]);
s=tf('s');
Gspm=[g11 g12;g21 g22]
% Simulation
h2G = ss(A+Bu*h2K, Bw, Cz + Du*h2K, zeros(nz,nw));
lqrG = ss(A-Bu*lqrK, Bw, Cz + Du*lqrK, zeros(nz,nw));
T = [0:0.01:20]/10;
w = [2*rand(length(T),1)-1;2*rand(length(T),1)-1];
w = [0.5*sin(10*T);0.5*sin(10*T)];
[y1,t1,x1] = lsim(h2G,w,T);
[y2,t2,x2] = lsim(lqrG,w,T);
f1 = figure(1); clf;
set(f1,'defaulttextinterpreter','latex');
plot(t1,y1,'r',t2,y2,'b:','Linewidth',2);
xlabel('Time'); ylabel('output $z(t)$');
title('$d(t) = 0.5*\sin\;\; (5*T)$ m');
title('$d(t)$ = white noise $\in [-1,\;1]$ m');
legend('H2','LQR');
print -depsc h2qcar2.eps