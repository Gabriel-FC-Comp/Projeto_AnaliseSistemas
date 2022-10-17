# Linear Systems Analysis Project

Project made in Matlab for a program that records 2 audios from the user's computer's microphone and manipulates it accordingly.

Right now, the program does:
- Records 2 separate audios using audiorecorder(), record() and stop();
- Transforms audio into double vector using getaudiodata();
- Sums both vectors by simply doing Z = X + Y;
- Transforms the sum of both vectors (Z) back into audio;
- Plays any of the three audios.
