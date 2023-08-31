%% Aula 3 - Matlab
%  Análise de Sistemas Lineares

% Criar um vetor de sinal com ruído

t = 0:0.001:10;
T = 3;
w = 2*pi/T;
y =sin(w*t);
plot(t,y)

SNR = -10;
y_noise = awgn(y,SNR);
figure
hold all
plot(t,y_noise,'Color',[0.8 0.8 0.8])
plot(t,y,'k','LineWidth',2)

M1 = 100;
M2 = 100; 
y_mm = movingAverage(y_noise,M1,M2)
plot(t,y_mm,'b','LineWidth',2)

ylim([-5 5])

%% Métrica da diferença ds sinais
figure
residuo =y-y_conv;
plot(t,residuo)
ylabel('Erro')
xlabel('tempo')

% energia do erro
E = sum(residuo.^2);

%% Cálculo do Erro em função de M

M1 = M;
M
y_mm = movingAverage(y_noise,M1,M2)

%% Convolução
% Resposta ao Impulso
h = ones(1,M1+M2+1)/(M1+M2+1)
y_conv = conv(y_noise,h,'same')

plot(t,y_conv,'c','LineWidth',2)
legend({'Sinal com Ruído','Sinal sem Ruído','Filtrado - Média Móvel', ...
    'Filtrado - Convolução' })

function y = movingAverage(x,M1,M2)

N = length(x);
y = zeros(N,1);
for n = M1+1:N-M2
    soma = sum(x(n-M1:n+M2));
    y(n) = soma/(M1+M2+1);
end

end












