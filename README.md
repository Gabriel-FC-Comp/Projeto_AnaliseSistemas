# Linear Systems Analysis Project

Project made in Matlab for a program that records 2 audios from the user's computer's microphone and manipulates it accordingly.

Right now, the program does the following:
- Records 2 separate audios using audiorecorder(), record() and stop();
- Transforms audio into double vector using getaudiodata();
- Sums both vectors by simply doing Z = X + Y;
- Plots all three vectors;
- Transforms the sum of both vectors (Z) back into audio;
- Plays any of the three audios;
- Shows on the log what is the SNR of the 2 audios;
- Creates moving average¹ using convolution;
- Uses moving average as a filter;
- Filters audio from the moving average and plots a graph afterwards;
- Plays this forth filtered audio.

----

TODO in the future:
- Create spectrum frequency code to show it using Fourier;
- Scale spectrum accordingly.

----
¹: may be a wrong translation.
