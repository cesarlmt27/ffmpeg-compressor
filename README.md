# ffmpeg-compressor
PowerShell script to compress multiple videos with [FFmpeg](https://www.ffmpeg.org/).


## How does it work?
The script compresses videos in a specified directory using FFmpeg with H.265 encoding. Here's a step-by-step explanation:

1. **Input directory**: The user provides the path to a directory containing video files.
2. **Target size**: The user specifies the desired size (in MB) for the compressed videos. If no size is specified, the script uses Constant Rate Factor (CRF) for compression.
3. **Compression process**:
    - **Two-Pass encoding**: If a target size is specified, the script calculates the video and audio bitrates to ensure the final size does not exceed the target. It then performs a Two-Pass encoding:
        - **First pass**: Analyzes the video and generates log files.
        - **Second pass**: Compresses the video using the calculated bitrates and the log files from the first pass.
        - **Log cleanup**: Removes the log files generated during the first pass.
    - **CRF encoding**: If no target size is specified, the script uses CRF for compression.
4. **Output directory**: The compressed videos are saved in a new directory named "compressed" within the input directory.
5. **Execution time**: The script records and displays the total time taken for the compression process.
6. **Completion**: The script pauses and waits for the user to press ENTER before exiting, allowing the user to read the completion message.


## Windows quick setup
- [FFmpeg installation](https://www.geeksforgeeks.org/how-to-install-ffmpeg-on-windows/).
- Download [`ffmpeg.ps1`](ffmpeg.ps1) and move it to FFmpeg's directory.
- Create a shortcut with the following content:
```powershell
powershell -ExecutionPolicy ByPass -File "C:\ffmpeg\ffmpeg.ps1"
```