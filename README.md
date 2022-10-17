# Linear Systems Analysis Project

Project made in Matlab for a program that records 2 audios from the user's computer's microphone and manipulates it accordingly.

Right now, the program does the following:
- Records 2 separate audios using audiorecorder(), record() and stop();
- Transforms audio into double vector using getaudiodata();
- Sums both vectors by simply doing Z = X + Y;
- Plots all three vectors;
- Transforms the sum of both vectors (Z) back into audio;
- Plays any of the three audios.

TODO:
- Determine what is the signal-noise relation;
- Tidy up plotting;
- Create moving average¹ using convolution;
later:
- Create spectrum frequency code to show it using Fourier;
- Scale spectrum accordingly.

----
¹: may be a wrong translation.
