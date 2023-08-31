clc
close all
clear all 

%% Exercicio 1
syms x(t)
x(t) = 0.2*sin(2*t)+1

fplot(x(t),[0,20])

%% Exercicio 2
syms u(t)
X=laplace(x(t))
u(t)=heaviside(t)

%% Exercicio 3
NUM = 5
DEN = [1 1 2]

H = tf(NUM,DEN)

impulse(H,20,'k')
step(H,20,'r')

%% Exercicio 4
pzmap(H)

%% Exercicio 5
X
NUM2 = 2
DEN2 = [5 0 20] 
NUM3 = 1
DEN3 = [1 0]

X = tf(NUM2,DEN2) + tf(NUM3,DEN3)

Y = H*X
figure

%% Exercicio 6
impulse(Y)
figure

%% Exercicio 7 
bode(H)
figure

%% Exercicio 8
pzmap(Y) 


