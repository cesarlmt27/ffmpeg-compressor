# ffmpeg-compressor
Scripts to compress multiple videos with [FFmpeg](https://www.ffmpeg.org/).

## How does it work?
Given a directory's path, the program iterates among all the files inside the directory and uses [FFmpeg](https://www.ffmpeg.org/) to compress them, saving the output videos in a directory named "compressed". For the correct work of the program, all the files inside the directory should be a video.

## Windows quick setup
- [FFmpeg installation](https://www.geeksforgeeks.org/how-to-install-ffmpeg-on-windows/).
- Download [`ffmpeg.ps1`](ffmpeg.ps1) and move it to FFmpeg's directory.
- Create a shortcut with the following content:
```powershell
powershell -ExecutionPolicy ByPass -File "C:\ffmpeg\ffmpeg.ps1"
```