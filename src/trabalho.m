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
%16 bits x 44100 Hz = 705600 bps ou 705.6 Kbps (~88 KBps)
Canais = 1; %1 = mono, 2 = stereo
vozSinal = double.empty;
ruidoSinal = double.empty;
somaSinal = double.empty;

%% setup gravacao
vozAudio = audiorecorder(FS, Nbits, Canais); %preparar para gravar
ruidoAudio = audiorecorder(FS, Nbits, Canais);

%% Menu
opcaoMenu = 0;
while opcaoMenu ~= -1
    disp("---------------------------------------------------------" + newline + ...
         "---------Projeto de Análise de Sistemas Lineares---------" + newline + ...
         "----------------Manipulador de Áudios V.1----------------" + newline + ...
         "---------------------------------------------------------" + newline + ...
         "---------------------------------------------------------" + newline);
    
    if(isempty(vozSinal) || isempty(ruidoSinal))
        
        disp("- 1 -> Gravar voz e ruído e manipulá-los-----------------" + newline + ...
             "- 2 -> Sair----------------------------------------------" + newline + ...
             "---------------------------------------------------------" + newline);
        opcaoMenu = input("Qual sua opção?  -> ");
        

        switch opcaoMenu

            case 1

                % gravar voz
                disp(".");
                disp("Gravando a voz.");
                record(vozAudio);
                pause(Tempo);
                stop(vozAudio);
                disp("Término gravacao da voz.");
    
                % guardar voz em uma variavel double
                vozSinal = getaudiodata(vozAudio, 'double'); %transforma pra vetor double
                
                % workaround erro de tam diferente
                pause(1);
                
                % gravar ruido
                disp(".");
                disp("Gravando o ruído.");
                record(ruidoAudio);
                pause(Tempo);
                stop(ruidoAudio);
                disp("Término da gravação do ruído.");
    
                % guardar ruido em uma variavel double
                ruidoSinal = getaudiodata(ruidoAudio, 'double');
                
                % soma o ruido e o sinal
                disp(".");
                disp("Somando a voz com o ruído.");
                somaSinal = vozSinal + ruidoSinal;

                % media movel em convolução otimizada
                disp(".");
                disp("Filtrando por média móvel.");
                rangeDaMedia = 1:1:200;
                E = zeros(length(rangeDaMedia),1);
                % "zeros()" cria vetor/matriz de zeros 
                k = 1;
                for a = rangeDaMedia
                    size = a+a+1;
                    respostaImpulso = ones(size, 1)/size;
                    resultadoFiltro = conv(somaSinal,respostaImpulso,'same');
                    residuo = vozSinal - resultadoFiltro;
                    E(k) = sum(residuo.^2);
                    k = k+1;
                end
                
                % Determinando Melhor Intervalo de Filtragem
                
                melhorRangeMedia = rangeDaMedia(E == min(E));
                melhorRespostaImpulso = ones(melhorRangeMedia+melhorRangeMedia+1,1)/(melhorRangeMedia+melhorRangeMedia+1);
                melhorResultadoFiltro = conv(somaSinal,melhorRespostaImpulso,'same');

                % obtem o tamanho do sinal
                tamSinal = length(vozSinal);
                
                % delimitador em x (converte a escala de amostras para segundos)
                DelimitadorEmX = (0:tamSinal-1)/FS;
                
                opcaoMenu = 0;
                pause(3);

            case 2

                clc;
                disp("Saindo...");
                break;

            otherwise
                
                disp(".");
                disp("Opção inválida");
                disp(".");
                pause(2);
                opcaoMenu = 0;

        end %end switch

    else % Se já se tem o áudio à manipular
        
        disp("- 1 -> Regravar áudios-----------------------------------" + newline + ...
             "- 2 -> Plotar os Sinais----------------------------------" + newline + ...
             "- 3 -> Manipular os Sinais-------------------------------" + newline + ...
             "- 4 -> Reproduzir os Sinais------------------------------" + newline + ...
             "- 5 -> Obter o SNR---------------------------------------" + newline + ...
             "- 6 -> Obter Espectros de Frequência---------------------" + newline + ...
             "- 7 -> Sair do programa----------------------------------" + newline + ...
             "---------------------------------------------------------" + newline);

        opcaoMenu = input("Qual sua opção?  -> ");

        switch opcaoMenu
            
            case 1

                vozSinal = double.empty;
                ruidoSinal = double.empty;
                clc;
                opcaoMenu = 0;

            case 2

                % Plotando Resultados
                
                % janela
                figure('Name','Gráficos dos áudios','NumberTitle','off');
                
                % plota
                subplot(3,1,1);
                plot(DelimitadorEmX, vozSinal,'r');
                ylim([-1 1]);
                grid("on");
                title("Sinal da gravação da voz");
                xlabel("Tempo em segundos");
                ylabel("Amplitude");
                %xticks([0:0.25:5]);
                %yticks([-1:0.25:1]);
                
                subplot(3,1,2);
                plot(DelimitadorEmX, ruidoSinal,'k');
                ylim([-1 1]);
                grid("on");
                title("Sinal da gravação do ruído");
                xlabel("Tempo em segundos");
                ylabel("Amplitude");
                
                subplot(3,1,3);
                plot(DelimitadorEmX, somaSinal,'b');
                ylim([-1 1]);
                grid("on");
                title("Sinal da soma entre os dois áudios");
                xlabel("Tempo em segundos");
                ylabel("Amplitude");

                figure('Name','Gráficos da energia residual','NumberTitle','off');
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
                ylim([-1 1]);
                title('Melhor Resultado Filtrado vs Áudio Original');
                legend({'Áudio Original','Melhor Áudio Filtrado'});
                xlabel('Tempo');
                
                opcaoMenu = 0;
                
            case 3
                manipulacao = 0;
                % 0 = nada
                % 1 = modular por funçao
                % 2 = clipping
                % 3 = inverter
                % 4 = echo
                funcao = linspace(1,6,tamSinal);

                while manipulacao ~= -1
                    clc;
                    disp("-------------------Manipulando o Áudio-------------------" + newline + ...
                         "---------------------------------------------------------" + newline + ...
                         "- 1 -> Modular por uma exponencial negativa--------------" + newline + ...
                         "- 2 -> Clipping da amplitude-----------------------------" + newline + ...
                         "- 3 -> Inverter o sinal (reverso)------------------------" + newline + ...
                         "- 4 -> Adição de Echo------------------------------------" + newline + ...
                         "---------------------------------------------------------" + newline + ...
                         "- 5 -> Reprodução e plotagem do sinal manipulado---------" + newline + ...
                         "---------------------------------------------------------" + newline + ...
                         "- 6 -> Sair da manipulação-------------------------------" + newline + ...
                         "---------------------------------------------------------" + newline);
                    manipulacao = input("Qual sua opção?  -> ");
       
                    switch manipulacao
                    
                        case 1
                            % multiplicação do sinal por uma função
                            sinalManipulado = zeros(1, tamSinal);
                            for i = 1:tamSinal
                                funcao(i) = exp(-funcao(i));
                                sinalManipulado(i) = somaSinal(i) * funcao(i);
                            end
                            disp("Sinal multiplicado pela função");
                            pause(2);
                        case 2
                            % manipulação da amplitude
                            sinalManipulado = zeros(1, tamSinal);
                            limiteClipping = input("Qual o limite desejado (entre 0 e 1)? -> ");

                            for i = 1: tamSinal
                                if(somaSinal(i) > limiteClipping)
                                    sinalManipulado(i) = limiteClipping;
                                elseif(somaSinal(i) < -limiteClipping)
                                    sinalManipulado(i) = -limiteClipping;
                                else
                                    sinalManipulado(i) = somaSinal(i);
                                end    
                            end
                            disp("Clipping aplicado no sinal");
                            pause(2);
                        case 3
                            % Inverte o áudio
                            sinalManipulado = zeros(1, tamSinal);
                             for i = 1: tamSinal
                                sinalManipulado(tamSinal-i+1) = somaSinal(i);
                             end
                            disp("Sinal invertido");
                            pause(2);
                        case 4
                            % Echo
                            sinalManipulado = zeros(1, tamSinal);
                            for i = 1 : 10000
                                sinalManipulado(i) = somaSinal(i);
                            end
                            
                            for i = 10001: tamSinal
                                sinalManipulado(i) = somaSinal(i) + (somaSinal(i-10000))/3;
                            end
                            
                            for i = tamSinal + 1 : tamSinal + tamSinal/5
                                sinalManipulado(i) = (sinalManipulado(i-10000))/3;
                            end
                            disp("Echo adicionado ao sinal");
                            pause(2);
                            
                        case 5
                            % Plota e reproduz o áudio manipulado
                            tocar = audioplayer(sinalManipulado,FS);
                            DelimitadorEmXManipulado = (0:length(sinalManipulado)-1)/FS;
                            plot(DelimitadorEmXManipulado,sinalManipulado,'g');
                            ylim([-1 1]);
                            grid("on");
                            title("Sinal da soma entre os dois áudios manipulado");
                            xlabel("Tempo em segundos");
                            ylabel("Amplitude");
                            disp("Tocando sinal manipulado");
                            play(tocar);
                        
                            pause(Tempo);

                        case 6

                            manipulacao = -1;

                        otherwise
                            disp(".");
                            disp("Opção inválida");
                            disp(".");
                            pause(2);
    
                    end % switch manipulação

                end % while manipulação

                opcaoMenu = 0;

            case 4
                
                % tocar voz, ruido e voz resultante
                clc;
                disp("---------------Reproduzindo o(s) Áudio(s)----------------" + newline + ...
                     "---------------------------------------------------------" + newline + ...
                     "- 0 -> Tocar áudio da voz--------------------------------" + newline + ...
                     "- 1 -> Tocar áudio do ruído------------------------------" + newline + ...
                     "- 2 -> Tocar áudio do sinal somado-----------------------" + newline + ...
                     "- 3 -> Tocar áudio do áudio melhor filtrado--------------" + newline + ...
                     "- 4 -> Tocar áudio dos quatro sinais---------------------" + newline + ...
                     "---------------------------------------------------------" + newline);
                selecaoTocar = input("Qual sua opção?  -> ");
                
                % tocar voz
                if (selecaoTocar == 0 || selecaoTocar == 4)
                    tocar = audioplayer(vozSinal,FS);
                    play(tocar);
                    disp("Tocando voz");
                
                    pause(Tempo);
                end
                
                % tocar ruido
                if (selecaoTocar == 1 || selecaoTocar == 4)
                    tocar = audioplayer(ruidoSinal,FS);
                    play(tocar);
                    disp("Tocando ruido");
                    
                    pause(Tempo);
                end
                
                % tocar soma
                if (selecaoTocar == 2 || selecaoTocar == 4)
                    tocar = audioplayer(somaSinal,FS);
                    play(tocar);
                    disp("Tocando audio resultante");
                    
                    pause(Tempo);
                end

                if (selecaoTocar == 3 || selecaoTocar == 4)
                    tocar = audioplayer(melhorResultadoFiltro,FS,8);
                    play(tocar);
                    disp("Tocando audio resultante");

                    pause(Tempo);
                end
                
                if(selecaoTocar < 0 || selecaoTocar > 4)
                    disp(".");
                    disp("Seleção inválida...");
                    disp(".");
                    pause(2);
                end

                opcaoMenu = 0;

            case 5 

                % SNR
                EnergiaVoz = sum(vozSinal(:).^2); %Energia do sinal da Voz
                EnergiaRuido = sum(ruidoSinal(:).^2); %Energia do Ruído
                
                PotenciaVoz = EnergiaVoz / length(vozSinal); %Potência do sinal da Voz
                PotenciaRuido = EnergiaRuido / length(ruidoSinal); %Potência do Ruído
                
                SNR = 10 * log10(PotenciaVoz / PotenciaRuido);
                disp("SNR = " + SNR + " dB");
                pause(5);
                opcaoMenu = 0;

            case 6

                % espectro freq
                clc;
                disp("------------Obtendo o Espectro de Frequência-------------" + newline + ...
                     "---------------------------------------------------------" + newline + ...
                     "- 0 -> Plotar espectro da voz----------------------------" + newline + ...
                     "- 1 -> Plotar espectro do ruído--------------------------" + newline + ...
                     "- 2 -> Plotar espectro do sinal somado-------------------" + newline + ...
                     "- 3 -> Plotar espectro do áudio melhor filtrado----------" + newline + ...
                     "- 4 -> Plotar espectro dos quatro sinais-----------------" + newline + ...
                     "---------------------------------------------------------" + newline);
                selecaoPlotar = input("Qual sua opção?  -> ");

                % janela
                figure('Name','Espectro dos sinais','NumberTitle','off');
                
                freqVozSinal = fft(vozSinal);
                freqRuido = fft(ruidoSinal);
                freqSomaSinal = fft(somaSinal);
                freqMelhorResultado = fft(melhorResultadoFiltro);
           
                % fft de voz
                if (selecaoPlotar == 0 || selecaoPlotar == 4)
                    if (selecaoPlotar == 4)
                        subplot(4,1,1)
                    end
                    semilogx(abs(freqVozSinal),'k');
                    title("Espectro de Frequência do Sinal Original")
                    xlabel("Frequência em Hertz");
                    ylabel("Amplitude");
                    xlim([0 inf]);
                    ylim([0 1000]);
                    grid on;
                end
                
                % fft do ruido
                if (selecaoPlotar == 1 || selecaoPlotar == 4)
                    if (selecaoPlotar == 4)
                        subplot(4,1,2)
                    end
                    semilogx(abs(freqRuido),'b');
                    title('Espectro de Frequência do Ruído')
                    xlabel("Frequência em Hertz");
                    ylabel("Amplitude");
                    xlim([0 inf]);
                    ylim([0 1000]);
                    grid on;
                end
                
                % fft da soma
                if (selecaoPlotar == 2 || selecaoPlotar == 4)
                    if (selecaoPlotar == 4)
                        subplot(4,1,3)
                    end
                    semilogx(abs(freqSomaSinal));
                    title('Espectro de Frequência do Sinal Somado')
                    xlabel("Frequência em Hertz");
                    ylabel("Amplitude");
                    xlim([0 inf]);
                    ylim([0 1000]);
                    grid on;
                end
                
                % fft do filtrado
                if (selecaoPlotar == 3 || selecaoPlotar == 4)
                    if (selecaoPlotar == 4)
                        subplot(4,1,4)
                    end
                    semilogx(abs(freqMelhorResultado),'r');
                    title('Espectro de Frequência do Melhor Sinal Filtrado')
                    xlabel("Frequência em Hertz");
                    ylabel("Amplitude");
                    xlim([0 inf]);
                    ylim([0 1000]);
                    grid on;
                end
                
                if(selecaoPlotar < 0 || selecaoPlotar > 4)
                    disp(".");
                    disp("Seleção inválida...");
                    disp(".");
                    pause(2);
                end
                
                opcaoMenu = 0;
            
            case 7
                opcaoMenu = -1;
                close all;
                clear;
                clc;
                disp("Saindo...");
                break;

            otherwise
                
                disp(".");
                disp("Opção inválida");
                disp(".");
                pause(2);
                opcaoMenu = 0;

        end %end switch
        
    end %end verifica se há sinais para trabalhar
   
    clc;
end

%% load audio
% load("Projeto_AnaliseSistemas-main\src\variaveisDeTeste.mat")
