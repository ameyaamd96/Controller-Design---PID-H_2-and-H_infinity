clear all;
close all;
clc;
A = [-5 -0.96875;-8.3333 -104.1666];
B = [55 0;36.667 0.0005];
C = [1 0;0 1];
D = [0 1;1 0];
eps = 1.0e-6 ;

gamma_l = 0.1 ; gamma_u = 5 ;

for iteration = 1:50   % To count the number of iterations required to get to the answer 
    if (gamma_u-gamma_l)/gamma_l <= eps 
        break , 
    end
    gamma = (gamma_u+gamma_l)/2 ;
    R = gamma^2*eye( size(D'*D,1) ) - D'*D ; 
    AA = A+B*inv(R)*D'*C  ;  DD = D*inv(R)*D' ;
    H = [ AA  B*inv(R)*B'  ;  -C'*(eye(size(DD))+DD)*C  -AA' ] ;
    eigH = eig(H)' ;
    if min( abs(real(eigH)) ) < 1.0e-5  % Using Lemma 4.5 of Robust Control Book
        gamma_l = gamma ;
    else 
        gamma_u = gamma ;
    end
end
iteration, gamma