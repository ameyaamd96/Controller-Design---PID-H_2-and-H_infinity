P=tf(1,[1 0 0]);
Wn=tf([1 1],[1 10]);
Wu=tf([1 1],[1 10]);
% Wu=tf(1);
GGs=[1 -P -Wn P; ...
    0 0 0 -Wu; ...
    -1 P Wn -P];
J=1;

G=ss(GGs,'minimal');

A=G.A;
B1=G.B(:,1:3);
B2=G.B(:,4);
C1=G.C(1:2,:);
C2=G.C(3,:);
D11=G.D(1:2,1:3);
D12=G.D(1:2,4);
D21=G.D(3,1:3);
D22=G.D(3,4);

[c2row, ~]=size(C2);
[~, b2col]=size(B2);
[K2,Tzw2,GAM2]=h2syn(G,c2row,b2col);
% Tzw=lft(G,K2);
rl=0;
ru=norm(Tzw2,'inf');

tol=0.1;
[Kinf,Tzwinf,GAMinf]=hinfsyn(G,c2row,b2col,rl,ru,tol);

LG2=loopsens(P,K2);
LGinf=loopsens(P,Kinf);

% norm(LG2.Si,'inf')
% norm(LG2.So,'inf')

% norm(LGinf.Si,'inf')
gam=norm(LGinf.So,'inf');

disp(['||M|| is ' num2str(gam) '. Uncertainty should be less than ' num2str(1/gam) '.'])

[Wnnum,Wnden]=tfdata(Wn);
[Wunum,Wuden]=tfdata(Wu);

% K=K2;
K=Kinf;

% subplot(211)
% % bode(S,T,L);
% % grid on;
% % legend('Sens','Comp','Loop');
% % [svH,wH]=sigma(Tzw,[0.1:0.1:1000]);
% % loglog(wH,svH(1,:)')
% [y,t]=impulse(T);
% plot(t,y)
% hold on
% grid on
% subplot(212)
% hold on
% % [y,t]=impulse(T);
% u=lsim(Ksub,y,t);
% plot(t,u)
% 
% 
% grid on
% legend('controlled');
% % legend('uncontrolled','controlled');
% 
% sigma(Tzwinf,[0.1:0.1:1000])
