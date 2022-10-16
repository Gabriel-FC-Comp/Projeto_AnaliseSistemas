%% Projeto de Sistemas Lineares
% 16/09/2022

close all
clc
clear

%% Gravar áudios
Tempo = 10; %5 segundos de gravação
FS = 44000; %Frequência de amostragem em 44 kHz
Nbits = 16; %sinal de 16 bits
Canais = 1; %1 = mono, 2 = stereo

vozGravacao = audiorecorder(FS, Nbits, Canais); %preparar para gravar
ruidoGravacao = audiorecorder(FS, Nbits, Canais);

record(vozGravacao);
pause(Tempo);
stop(vozGravacao);

record(ruidoGravacao);
pause(Tempo);
stop(ruidoGravacao);

%guardar voz em uma variavel double
vozSinal = getaudiodata(vozGravacao, 'double');
%guardar ruidoem uma variavel double
ruidoSinal = getaudiodata(ruidoGravacao, 'double');

