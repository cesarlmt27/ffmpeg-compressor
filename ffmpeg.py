# Inspired on: https://unix.stackexchange.com/questions/520597/how-to-reduce-the-size-of-a-video-to-a-target-size

import subprocess
import math
import os

def ffmpeg_compress(file_path, target_size_mb, output_path):
    target_size = target_size_mb * 1000 * 1000 * 8   # Target size in bits
    res = subprocess.run(f'ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "{file_path}"', shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    length_round_up = math.ceil(float(res.stdout.strip()))
    total_bitrate = target_size / length_round_up
    audio_bitrate = 128 * 1000  # 128k bit rate
    video_bitrate = total_bitrate - audio_bitrate
    subprocess.run(f'ffmpeg -i "{file_path}" -b:v {video_bitrate} -maxrate:v {video_bitrate} -bufsize:v {target_size / 20} -b:a {audio_bitrate} "{output_path}"', shell=True, stdout=True, stderr=True)


def multiple_videos(dir_path, target_size_mb):
    os.mkdir(f"{dir_path}/compressed")   # Create a directory named "compressed" inside dir_path
    compressed_path = os.path.join(dir_path, 'compressed')  # Store "compressed" directory's path

    # Iterate dir_path
    for file_name in os.listdir(dir_path):
        file_path = os.path.join(dir_path, file_name)   # Store the current file's path
        if os.path.isfile(file_path):   # Check if the current file_path is a file
            file_without_extension = os.path.splitext(file_name)[0] # Store the file name without the extension
            output_path = os.path.join(compressed_path, f'{file_without_extension}-compressed.mp4')
            ffmpeg_compress(file_path, target_size_mb, output_path)


print("Enter the directory's path:")
dir_path = input()
dir_path = dir_path.strip('"')  # Remove the quotes from the path

print("\nEnter the compression target size (MB):")
target_size_mb = int(input())

multiple_videos(dir_path, target_size_mb)