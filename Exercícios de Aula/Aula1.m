% Aula 1 - matlab 
% Análise de Sistemas Lineares 2022-2

%% Limpando variáveis 
%
close all % fechar as janelas
clc %limpar o command window
clear all % limpar as variáves

%
%% Declarar uma função

t = 0:0.01:2; %2 segundos
A = 1;
f = 1; % 1 Hz
w = 2*pi*f;
fi = 0;
B = 0;
y = A*sin(w*t + fi) + B;

figure % Cria uma janela para imagens
subplot(2,1,1) %Linhas, colunas, posição
plot(t,y)
subplot(2,1,2)
A = 0.5;
f = 1.5; 
w = 2*pi*f;
fi = pi/8;
B = 0.5;
y = A*sin(w*t + fi) + B;
plot(t,y,'r','LineWidth',1)
ylim([-2 2])
grid on %grades no gráfico
yticks([0.5:0.5:1.5])

hold all
plot(t,y.^2,'Color',[165 26 81]/255)

legend({'Função 1: sen(t)',...
    'Função 2 = sen^2(t)'},'Location','south')

title('Título')
ylabel('Amplitude')
xlabel('Tempo (s)')

%% Exercício 1

t = 0:0.01:2; %2 segundos
A = 1;
f = 1; 
w = 2*pi*f;
fi = 0;
B = 0;
y = A*sin(w*t + fi) + B;


figure % Cria uma janela para imagens
plot(t,y,'b','LineWidth',1)
hold all

A = 2;
f = 1; 
w = 2*pi*f;
fi = 0;
B = 0;
y = A*sin(w*t + fi) + B;
plot(t,y,'r','LineWidth',1)

A = 0.5;
f = 1; 
w = 2*pi*f;
fi = 0;
B = 0;
y = A*sin(w*t + fi) + B;
plot(t,y,'k--','LineWidth',1)

grid on %grades no gráfico


legend({'Função 1: sen(2*pi*t)',...
    'Função 2 = 2*sen(2*pi*t)', 'Função 3 = 0.5*sen(2*pi*t)'},'Location','south')

title('Exercício 1')
ylabel('Amplitude')
xlabel('Tempo (s)')




