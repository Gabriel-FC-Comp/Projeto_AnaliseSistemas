%% Projeto de Sistemas Lineares
% 16/09/2022
% aluno: Vitor Batista
% prof: Daniel Campos

close all
clc
clear

%% Gravar áudios
Tempo = 5; %5 segundos de gravação
FS = 8000; %Frequência de amostragem em 8 kHz
Nbits = 8; %sinal de 8 bits
%8 bits x 8000/s = 8000 bytes/s ou 8kBps
Canais = 1; %1 = mono, 2 = stereo

vozGravacao = audiorecorder(FS, Nbits, Canais); %preparar para gravar
ruidoGravacao = audiorecorder(FS, Nbits, Canais);

disp("Voz gravando.");
record(vozGravacao);
pause(Tempo);
stop(vozGravacao);

disp("Ruido gravando.");
record(ruidoGravacao);
pause(Tempo);
stop(ruidoGravacao);

disp("Término.");

%guardar voz em uma variavel double
vozSinal = getaudiodata(vozGravacao, 'double');
subplot(3,1,1);
plot(vozSinal);

%guardar ruido em uma variavel double
ruidoSinal = getaudiodata(ruidoGravacao, 'double');
subplot(3,1,2);
plot(ruidoSinal);

somaSinal = vozSinal + ruidoSinal;
subplot(3,1,3);
plot(somaSinal);

