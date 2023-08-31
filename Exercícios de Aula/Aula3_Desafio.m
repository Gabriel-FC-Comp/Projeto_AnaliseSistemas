%% Desafio Aula 3
close all
clc
clear

fprintf('Iniciando o codigo...\n')
A = input('Digite o valor de A: \n')
B = input('Digite o valor de B: \n')

x = trapezio(A,B);
n=-B-A:B+A;
stem(n,x,'Filled','k')
xlabel('n')
ylabel('x[n]')
title('Função Trapézio')
ylim([ 0 1.2])
xlim([-B-A-1 B+A+1])
xticks(-B-A-1 : B+A+1)
yticks([0:0.1:1])
grid on 

function x = trapezio(A,Bi)
B = Bi - 1;
subida = (1:B)* (1/B);
reta = ones(1,2*A+1);
descida = flip(1:B) * (1/B);

x = [0 subida reta descida 0];

end
