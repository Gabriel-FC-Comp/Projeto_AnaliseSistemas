%% Atividade Prática 5

close all
clc
clear

for ni = 1:30 % ni em 1 = 0 
x(ni) = (1/2)^(ni-1);
end
N = length(x)

y(1) = 8;

for ni = 2:N % ni em 1 = -1 
y(ni) = (1/4)*y(ni-1) + x(ni);
end

n = 0:N-1;
figure
subplot(2,1,1)
stem(n,x,'filled','k')
xlabel('n')
ylabel('x[n]')
grid on
ylim([0 2])
xlim([0 10])

n = -1:N-2;
subplot(2,1,2)
stem(n,y,'filled','r')
xlabel('n')
ylabel('y[n]')
grid on
ylim([0 9]) 
xlim([-1 9])