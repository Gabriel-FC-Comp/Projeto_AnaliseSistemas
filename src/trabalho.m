%% Projeto de Sistemas Lineares
% 16/09/2022
% Alunos: 
%   Vitor Batista
%   Gabriel Finger
%   Leonardo Fagote
%   Arnald Souza
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

%% load audio
% load("Projeto_AnaliseSistemas-main\src\variaveisDeTeste.mat")

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

%% media movel em convolução otimizada

rangeDaMedia = 1:10:1000;
E = zeros(length(rangeDaMedia),1);
k = 1;
for a = rangeDaMedia
    size = a+a+1;
    respostaImpulso = ones(size, 1)/size;
    resultadoFiltro = conv(somaSinal,respostaImpulso,'same');
    residuo = vozSinal - resultadoFiltro;
    E(k) = sum(residuo.^2);
    k = k+1;
end

%% Determinando Melhor Intervalo de Filtragem

melhorRangeMedia = rangeDaMedia(E == min(E));
melhorRespostaImpulso = ones(melhorRangeMedia+melhorRangeMedia+1,1)/(melhorRangeMedia+melhorRangeMedia+1);
melhorResultadoFiltro = conv(somaSinal,melhorRespostaImpulso,'same');


%% Plotando Resultados

figure
%Plotando Energia Residual para cada intervalo de média móvel calculado
subplot(2,1,1)
plot(rangeDaMedia,E,'k-o');
title('Energia Residual por Range de Média Móvel');
xlabel('Range');
ylabel('Energia Residual');
% Plotando a forma de onda do melhor resultado do filtro em comparação com
% osinal original
subplot(2,1,2)
hold on
plot(DelimitadorEmX,vozSinal,'r');
plot(DelimitadorEmX,melhorResultadoFiltro,'k');
hold off
title('Melhor Resultado Filtrado vs Áudio Original');
legend({'Áudio Original','Melhor Áudio Filtrado'});
xlabel('Tempo');

F = audioplayer(melhorResultadoFiltro,FS,8);
play(F);
disp("Tocando audio resultante");
