# Inspired on: https://unix.stackexchange.com/questions/520597/how-to-reduce-the-size-of-a-video-to-a-target-size

function ffmpeg_compress($file_path, $target_size_mb, $output_path) {
    $target_size = $target_size_mb * 1000 * 1000 * 8   # Target size in bits
    $length = (ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $file_path)
    $length_round_up = [math]::Ceiling($length)
    $total_bitrate = [math]::Floor($target_size / $length_round_up)
    $audio_bitrate = 128 * 1000  # 128k bit rate
    $video_bitrate = $total_bitrate - $audio_bitrate
    ffmpeg -i $file_path -b:v $video_bitrate -maxrate:v $video_bitrate -bufsize:v ($target_size / 20) -b:a $audio_bitrate $output_path
}

function multiple_videos($dir_path, $target_size_mb) {
    New-Item -ItemType Directory -Force -Path "$dir_path\compressed"   # Create a directory named "compressed" inside dir_path
    $compressed_path = Join-Path $dir_path 'compressed'  # Store "compressed" directory's path

    # Iterate dir_path
    Get-ChildItem $dir_path | ForEach-Object {
        $file_path = $_.FullName   # Store the current file's path
        if ($_.PSIsContainer -eq $false) {   # Check if the current file_path is a file
            $file_without_extension = [System.IO.Path]::GetFileNameWithoutExtension($_.Name) # Store the file name without the extension
            $output_path = Join-Path $compressed_path "$file_without_extension-compressed.mp4"
            ffmpeg_compress $file_path $target_size_mb $output_path
        }
    }
}

Write-Host "Enter the directory's path:"
$dir_path = Read-Host
$dir_path = $dir_path.Trim('"')  # Remove the quotes from the path

do {
    try {
        Write-Host "`nEnter the compression target size (MB):"
        [int]$target_size_mb = Read-Host
        $valid_input = $true
    }
    catch {
        Write-Host "Invalid input. Please enter a number."
        $valid_input = $false
    }
} while ($valid_input -eq $false)

multiple_videos $dir_path $target_size_mb