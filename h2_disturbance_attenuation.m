clear; clc;
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
variable Z(nu,nx)
[A Bu]*[X;Z] + [X Z']*[A';Bu'] + Bw*Bw' < 0
[W (Cz*X + Du*Z); (Cz*X + Du*Z)' X] > 0
minimize trace(W)
cvx_end
h2K = Z*inv(X);
hinfK = [-1.4 -4e-14;3e-11 4e-16];
[lqrK,S,E] = lqr(A,Bu,Cz'*Cz,Du'*Du);
h2G = ss(A+Bu*h2K, Bw, Cz + Du*h2K, zeros(nw,2));
hinfG = ss(A+Bu*hinfK, Bw, Cz + Du*hinfK, zeros(nw,2));
lqrG = ss(A-Bu*lqrK, Bw, Cz + Du*lqrK , zeros(nw,2));
T = [0:0.01:20];
w = [5*randn(length(T),1) 5*randn(length(T),1)];
% w = [0.5*sin(10*T);0.5*sin(10*T)];
[y1,t1,x1] = lsim(h2G,w,T);
[y2,t2,x2] = lsim(lqrG,w,T);
[y3,t3,x3] = lsim(hinfG,w,T);
f1=figure(1); clf;
set(f1,'defaulttextinterpreter','latex');
for i=1:2
subplot(2,1,i);
plot(t1,y1(:,i),'r',t2,y2(:,i),'b:',t3,y3(:,i),'y', 'linewidth',2);
xlabel('Time(s)');
ylabel(sprintf('Output $z_%d$',i));
end
subplot(2,1,1); legend('H_2','LQR','Hinf');
print -depsc h2ex1.eps
