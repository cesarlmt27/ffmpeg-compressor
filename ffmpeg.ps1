# Based on: https://trac.ffmpeg.org/wiki/Encode/H.265
# Error solution: https://stackoverflow.com/questions/46231348/ffmpeg-what-does-non-monotonically-increasing-dts-mean

# Function to compress video using Constant Rate Factor (CRF)
function crf($file_path, $output_path) {
    ffmpeg -i $file_path -vcodec libx265 -crf 26 -preset slow $output_path
}

# Function to compress video using Two-Pass encoding
function two_pass($file_path, $output_path, $video_bitrate, $audio_bitrate) {
    # First pass
    ffmpeg -i $file_path -vcodec libx265 -b:v $video_bitrate -x265-params pass=1 -an -f matroska NUL
    # Second pass
    ffmpeg -i $file_path -vcodec libx265 -b:v $video_bitrate -x265-params pass=2 -b:a $audio_bitrate -preset slow $output_path
    # Remove log files generated by the first pass
    Remove-Item ./*.log
    Remove-Item ./*.cutree
}

# Function to calculate video and audio bitrates based on desired size
function calculate_bitrate($file_path, $desired_size_mb) {
    # Get the video's length in seconds
    $length = (ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $file_path)
    # Calculate total bitrate in Bit/s with a margin of safety
    $total_bitrate = (($desired_size_mb * 8388.608) / $length) * 1000 * 0.99
    # Set audio bitrate to 128 Bit/s
    $audio_bitrate = 128 * 1000
    # Calculate video bitrate
    $video_bitrate = $total_bitrate - $audio_bitrate
    return $video_bitrate, $audio_bitrate
}

# Function to compress multiple videos in a directory
function multiple_videos($dir_path, $desired_size_mb) {
    # Create a directory named "compressed" inside dir_path
    New-Item -ItemType Directory -Force -Path "$dir_path\compressed"
    # Store "compressed" directory's path
    $compressed_path = Join-Path $dir_path 'compressed'

    # Iterate through files in dir_path
    Get-ChildItem $dir_path | ForEach-Object {
        $file_path = $_.FullName   # Store the current file's path
        if ($_.PSIsContainer -eq $false) {   # Check if the current object is a file
            # Store the file name without the extension
            $file_without_extension = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
            # Set the output path for the compressed file
            $output_path = Join-Path $compressed_path "$file_without_extension-compressed.mp4"
            if ($desired_size_mb -ne "") {
                # Calculate bitrates and perform Two-Pass encoding
                $video_bitrate, $audio_bitrate = calculate_bitrate $file_path $desired_size_mb
                two_pass $file_path $output_path $video_bitrate $audio_bitrate
            } else {
                # Perform CRF encoding
                crf $file_path $output_path
            }
        } else {
            Write-Host "$file_path is a directory, skipping..."
        }
    }
}

# Prompt user for the directory's path
Write-Host "Enter the directory's path:"
$dir_path = Read-Host
$dir_path = $dir_path.Trim('"')  # Remove the quotes from the path

Set-Location $dir_path  # Change the working directory to the specified path

# Prompt user for the compression target size or use CRF
do {
    try {
        Write-Host "`nEnter the desired size (MB) for the videos, or press ENTER if you don't care about the videos' size:"
        [int]$desired_size_mb = Read-Host
        $valid_input = $true
    }
    catch {
        Write-Host "Invalid input. Please enter a number."
        $valid_input = $false
    }
} while ($valid_input -eq $false)

# Record start time
$start_time = Get-Date

# Compress videos in the specified directory
multiple_videos $dir_path $desired_size_mb

# Record end time
$end_time = Get-Date
# Calculate duration
$duration = $end_time - $start_time

# Output the duration of the compression process
Write-Host "Compression completed in $($duration.Hours) hours, $($duration.Minutes) minutes, and $($duration.Seconds) seconds."

# Pause to allow the user to read the message
Write-Host "Press ENTER to exit or close the window..."
do {
    $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
} while ($key.VirtualKeyCode -ne 13)  # 13 is the virtual key code for ENTER