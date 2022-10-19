%% Projeto de Sistemas Lineares
% 16/09/2022
% Alunos: 
%   Vitor Batista
%   Gabriel Finger
%   Leonardo Fagote
%   Arnard Souza
% Prof.: Daniel Campos

close all
clc
clear

%% setup variaveis
Tempo = 5; %5 segundos de gravação
FS = 44100; %Frequência de amostragem em 44.1 kHz
Nbits = 16; %sinal de 16 bits
%16 bits x 44100 Hz = 705600 bps ou 705.6 Kbps
Canais = 1; %1 = mono, 2 = stereo

%% setup gravacao
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

% delimitador em x
DelimitadorEmX = (0:length(vozSinal)-1)/FS;

% guardar voz em uma variavel double
vozSinal = getaudiodata(vozAudio, 'double');
subplot(3,1,1);
plot(DelimitadorEmX, vozSinal,'r');
ylim([-1 1]);
grid("on");
title("Sinal da gravação da voz");
xlabel("Tempo em segundos");
ylabel("Amplitude");
%xticks([0:0.25:5]);
%yticks([-1:0.25:1]);

% guardar ruido em uma variavel double
ruidoSinal = getaudiodata(ruidoAudio, 'double');
subplot(3,1,2);
plot(DelimitadorEmX, ruidoSinal,'k');
ylim([-1 1]);
grid("on");
title("Sinal da gravação do ruído");
xlabel("Tempo em segundos");
ylabel("Amplitude");

somaSinal = vozSinal + ruidoSinal;
subplot(3,1,3);
plot(DelimitadorEmX, somaSinal,'b');
ylim([-1 1]);
grid("on");
title("Sinal da soma entre os dois áudios");
xlabel("Tempo em segundos");
ylabel("Amplitude");

%% tocar voz, ruido e voz resultante
clc;

% 0: tocar voz
% 1: tocar ruido
% 2: tocar soma
%   3: tocar todos
selecaoTocar = 3;

% tocar voz
if (selecaoTocar == 0 || selecaoTocar == 3)
    tocar = audioplayer(vozSinal,FS);
    play(tocar);
    disp("Tocando voz");

    pause(Tempo);
end

% tocar ruido
if (selecaoTocar == 1 || selecaoTocar == 3)
    tocar = audioplayer(ruidoSinal,FS);
    play(tocar);
    disp("Tocando ruido");
    
    pause(Tempo);
end

% tocar soma
if (selecaoTocar == 2 || selecaoTocar == 3)
    somaAudio = audioplayer(somaSinal,FS);
    play(somaAudio);
    disp("Tocando audio resultante");
    
    pause(Tempo);
end

%% SNR
EnergiaVoz = sum(vozSinal(:).^2); %Energia do sinal da Voz
EnergiaRuido = sum(ruidoSinal(:).^2); %Energia do Ruído

PotenciaVoz = EnergiaVoz / length(vozSinal); %Potência do sinal da Voz
PotenciaRuido = EnergiaRuido / length(ruidoSinal); %Potência do Ruído

SNR = 10 * log10(PotenciaVoz / PotenciaRuido);
disp("SNR = " + SNR + " dB");

%% media movel em convolução
rangeDaMedia = 10;
tamSoma = length(somaSinal);
mediaMovel = zeros(tamSoma, 1);
for n = (1 + rangeDaMedia) : (tamSoma - rangeDaMedia)
    mediaMovel(n) = sum(somaSinal(n - rangeDaMedia : n + rangeDaMedia)) / (tamSoma + 1);
end


