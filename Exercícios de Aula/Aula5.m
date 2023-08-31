%% Aula 5 - Análise de Sistemas Lineares
close all
clc
clear

%% Exemplo de laço de repetição
x = [0 0 0 1 1 1 0 0 0 0]
N = length(x);

%% forma 1
%for ni = 1:N-1
%   y(ni+1) = y(ni) + x(ni+1);
% end

%% forma 2
% y(1) não existe, é preciso declarar
% como uma consição inicial

y(1) = 1;

for ni = 2:N
    y(ni) = y(ni-1) + x(ni);
end

%vetor de n para plotar
n = -1:N-2

figure
subplot(2,1,1)
stem(n,x,"filled", 'k')
xlabel('n')
ylabel('x[n]')
grid on
ylim([-1 4])

subplot(2,1,2)
stem(n,y,'filled','r')
xlabel('n')
ylabel('x[n]')
grid on
ylim([-1 4])
