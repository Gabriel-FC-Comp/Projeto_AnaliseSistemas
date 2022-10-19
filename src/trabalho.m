%% Projeto de Sistemas Lineares
% 16/09/2022
% aluno: Vitor Batista
% prof: Daniel Campos

close all
clc
clear

%% setup gravação
Tempo = 10; %5 segundos de gravação
FS = 44100; %Frequência de amostragem em 44.1 kHz
Nbits = 16; %sinal de 16 bits
%16 bits x 44100 Hz = 705600 bps ou 705.6 Kbps
Canais = 1; %1 = mono, 2 = stereo

vozAudio = audiorecorder(FS, Nbits, Canais); %preparar para gravar
ruidoAudio = audiorecorder(FS, Nbits, Canais);

%% gravar voz
disp("Voz gravando.");
record(vozAudio);
pause(Tempo);
stop(vozAudio);

disp("Término gravacao voz.");

%% gravar ruido
disp("Ruido gravando.");
record(ruidoAudio);
pause(Tempo);
stop(ruidoAudio);

disp("Término gravacao ruido.");

%% traduzir sinais gravados para vetor, somar ruido e voz + plotar 
% janela
figure('Name','Gráficos dos áudios','NumberTitle','off');

% guardar voz em uma variavel double
vozSinal = getaudiodata(vozAudio, 'double');
subplot(3,1,1);
plot(vozSinal);
ylim([-1 1]);
xlim([0 5]);

% guardar ruido em uma variavel double
ruidoSinal = getaudiodata(ruidoAudio, 'double');
subplot(3,1,2);
plot(ruidoSinal);
ylim([-1 1]);
xlim([0 5]);

somaSinal = vozSinal + ruidoSinal;
subplot(3,1,3);
plot(somaSinal);
ylim([-1 1]);
xlim([0 5]);

%% tocar voz, ruido e voz resultante
clc;
% tocar voz
tocar = audioplayer(vozSinal,FS);
play(tocar);
disp("tocando voz");

pause(Tempo);

% tocar ruido
tocar = audioplayer(ruidoSinal,FS);
play(tocar);
disp("tocando ruido");

pause(Tempo);

% tocar soma
somaAudio = audioplayer(somaSinal,FS);
play(somaAudio);
disp("tocando audio resultante");

pause(Tempo);

%% SNR
% janela
figure('Name','Gráfico SNR','NumberTitle','off');

% plotar
r = snr(vozSinal,ruidoSinal);
plot(r);
