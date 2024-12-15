# ffmpeg-compressor
Scripts to compress multiple videos with [FFmpeg](https://www.ffmpeg.org/).


## How does it work?
The script compresses videos in a specified directory using [FFmpeg](https://www.ffmpeg.org/) with H.264 video encoding and 1-pass target bitrate encoding. Here's a step-by-step explanation:

1. **Input directory**: The user provides the path to a directory containing video files.
2. **Target size**: The user specifies the desired size (in MB) for the compressed videos.
3. **Compression process**:
    - The script calculates the target size in bits.
    - It uses `ffprobe` to determine the duration of each video.
    - The total bitrate is calculated based on the target size and video duration.
    - The audio bitrate is set to 128 kbps, and the remaining bitrate is allocated to the video.
    - FFmpeg is used to compress each video with the calculated bitrates using H.264 video encoding and 1-pass target bitrate encoding.
4. **Output directory**: The compressed videos are saved in a new directory named "compressed" within the input directory.


## Windows quick setup
- [FFmpeg installation](https://www.geeksforgeeks.org/how-to-install-ffmpeg-on-windows/).
- Download [`ffmpeg.ps1`](ffmpeg.ps1) and move it to FFmpeg's directory.
- Create a shortcut with the following content:
```powershell
powershell -ExecutionPolicy ByPass -File "C:\ffmpeg\ffmpeg.ps1"
```