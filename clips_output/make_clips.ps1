# Video generation script for Thiengtham clips
$ffmpeg = "C:\Users\Succubuz\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-8.1.3-full_build\bin\ffmpeg.exe"
$audio = "D:\web thiengtham\matrix-media-1782064438082-1bb83d60.mp3"
$outputDir = "D:\web thiengtham\clips_output"

# Room images
$rooms = @(
    "C:\Users\Succubuz\Desktop\667793_0.jpg",
    "C:\Users\Succubuz\Desktop\667794_0.jpg",
    "C:\Users\Succubuz\Desktop\667795_0.jpg",
    "C:\Users\Succubuz\Desktop\667796_0.jpg"
)

# Person overlay images (Thai AI-generated photos)
$persons = @(
    "C:\Users\Succubuz\Desktop\FB auto post All file\โปรไฟล์\Fashionable stroll near Metropolis building.png",
    "C:\Users\Succubuz\Desktop\FB auto post All file\โปรไฟล์\Glamorous evening at Iconsiam.png",
    "C:\Users\Succubuz\Desktop\FB auto post All file\โปรไฟล์\Cozy boudoir with evening elegance.png",
    "C:\Users\Succubuz\Desktop\FB auto post All file\โปรไฟล์\Chic stroll through a sunny plaza.png"
)

# Service names for each clip
$services = @("spc", "paint", "spc2", "paint2")

# Duration for each clip
$duration = 5

for ($i = 0; $i -lt 4; $i++) {
    $room = $rooms[$i]
    $person = $persons[$i]
    $service = $services[$i]
    $output = "$outputDir\clip_$($i+1)_$service.mp4"

    Write-Host "Creating clip $($i+1): $service"
    Write-Host "  Room: $room"
    Write-Host "  Person: $person"
    Write-Host "  Output: $output"

    # ffmpeg command:
    # - Loop room image for 5 seconds
    # - Overlay person image with slight fade-in
    # - Add audio
    # - Output as MP4
    & $ffmpeg -y -loop 1 -i $room -i $person -i $audio `
        -filter_complex `
        "[0:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,setsar=1[bg];`n
         [1:v]scale=540:-1[person];`n
         [bg][person]overlay=(W-w)/2:(H-h)/2:format=auto,fade=t=in:st=0:d=0.5:alpha=1[vid]" `
        -map "[vid]" -map 2:a `
        -c:v libx264 -preset fast -crf 23 `
        -c:a aac -b:a 128k `
        -t $duration `
        -pix_fmt yuv420p `
        $output 2>&1 | Out-Null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "  SUCCESS: $output"
    } else {
        Write-Host "  FAILED with exit code $LASTEXITCODE"
    }
}

Write-Host "`nAll done! Output files in: $outputDir"