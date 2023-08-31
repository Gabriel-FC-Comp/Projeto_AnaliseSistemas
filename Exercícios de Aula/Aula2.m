%% Desafio 
close all
clc
clear

t = linspace(0,2,1000);
f = 1;
w = 2*pi*f;
x1 =sin(w*t);
x2 = 3*t-3;

figure
%% Plot 1
subplot(2,1,1)
hold all

plot(t,x1,'r','LineWidth',1)
plot(t,x2,'b','LineWidth',1)
legend('x1(t) = sin(\pi t)', ...
    'x2(t) = 3t-3', ...
    'Location', 'NorthWest')
xlabel('Tempo(s)')
ylabel('Amplitude')
title('Adição : y = x1+x2')
grid on

%% Plot 2
subplot(2,1,2)
hold all

plot(t,x1+x2,'k','LineWidth',1)
plot(t,x2,'b--','LineWidth',0.3)
plot(t,x1,'r--','LineWidth',0.3)
legend('y(t) = x1+x2', ...
    '3t-3', ...
    'sin(\pi t)', ...
    'Location', 'NorthWest')
xlabel('Tempo(s)')
ylabel('Amplitude')
grid on


%% Aula 2 - Matlab
% Análise de Sistemas Lineares 2022-2

close all
clc
clear

%%
t = 0:0.001:2;
w = 2*pi;

x1=sin(w*t);
N=length(x1);
x1_ruido= x1' +randn(N,1)*0.1;

figure
plot(t,x1_ruido)
th = 0.2;
x2=ceifar(x1_ruido,th);
hold on
plot(t,x2,'k--')


%% funções
function y = ceifar(x,th)
%Essa função ceifa um sinal
% Entradas: 
%  x: sinal de dimensão Nx1
%  th: threshold ou limiar
% Saídas:
%  y: sinal ceifado de dimensão Nx1
N = length(x);
y = zeros(N,1);
    for i =1:N
        if x(i)>th
            y(i) = th;
        elseif x(i)<-th
            y(i) = -th
        else
            y(i) = x(i);
        end 
    
    end
end

%%  Exercício - Criar função cos+exp

getFunc(15*pi/8,1,0,30)

function getFunc(w,A,a,n_ciclos)

T = 2*pi/w; %período
t = 0:0.001:n_ciclos*T; %5 períodos
N=round (n_ciclos*T);
n = 0:N;
x_cont = A*cos(w*t).*exp(-a*t);
x_disc = A*cos(w*n).*exp(-a*n);

figure hold all
plot(t,x_cont, 'k--')
plot(t,x_disc,'Filled')

legend({'Contínuo','Discreto'})

end



