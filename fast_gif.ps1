Add-Type -AssemblyName System.Drawing

$width = 640
$height = 320
$totalFrames = 10
$frameDelay = 10
$outputGif = "C:\Users\ishan\Documents\Projects\icloud-downloader\assets\social-preview.gif"

# Palette colors (16 colors)
$palette = @(
    [System.Drawing.Color]::FromArgb(11, 15, 25),    # 0: BG Dark
    [System.Drawing.Color]::FromArgb(17, 24, 39),    # 1: Deep Navy
    [System.Drawing.Color]::FromArgb(30, 41, 59),    # 2: Slate Box
    [System.Drawing.Color]::FromArgb(51, 65, 85),    # 3: Slate Border
    [System.Drawing.Color]::FromArgb(56, 189, 248),  # 4: Cyan
    [System.Drawing.Color]::FromArgb(129, 140, 248), # 5: Indigo
    [System.Drawing.Color]::FromArgb(192, 132, 252), # 6: Purple
    [System.Drawing.Color]::FromArgb(255, 255, 255), # 7: White
    [System.Drawing.Color]::FromArgb(148, 163, 184), # 8: Light Gray Text
    [System.Drawing.Color]::FromArgb(16, 185, 129),  # 9: Green
    [System.Drawing.Color]::FromArgb(245, 158, 11),  # 10: Amber
    [System.Drawing.Color]::FromArgb(2, 132, 199),   # 11: Dark Cyan
    [System.Drawing.Color]::FromArgb(147, 197, 253), # 12: Light Blue Cloud
    [System.Drawing.Color]::FromArgb(226, 232, 240), # 13: Slate Light
    [System.Drawing.Color]::FromArgb(0, 0, 0),       # 14: Black
    [System.Drawing.Color]::FromArgb(20, 30, 45)     # 15: Dark Blue
)

$fullPalette = New-Object byte[] 768
for ($i = 0; $i -lt 16; $i++) {
    $fullPalette[$i*3] = $palette[$i].R
    $fullPalette[$i*3+1] = $palette[$i].G
    $fullPalette[$i*3+2] = $palette[$i].B
}

$frameBitmaps = @()
for ($f = 0; $f -lt $totalFrames; $f++) {
    $bmp = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias

    # Background
    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        (New-Object System.Drawing.Point(0, 0)),
        (New-Object System.Drawing.Point($width, $height)),
        [System.Drawing.Color]::FromArgb(11, 15, 25),
        [System.Drawing.Color]::FromArgb(17, 24, 39)
    )
    $g.FillRectangle($bgBrush, 0, 0, $width, $height)

    # Outer border
    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(56, 189, 248), 1.5)
    $g.DrawRectangle($borderPen, 2, 2, $width - 4, $height - 4)

    # 50px padding top/bottom ensures content is in y=50..270
    $cloudFloatY = [Math]::Sin(($f / $totalFrames) * 2 * [Math]::PI) * 4.0
    $arrowProgress = ($f % 5) / 4.0
    $arrowY = 146 + ($arrowProgress * 20)

    # Cloud glow & dashed boundary
    $glowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(25, 56, 189, 248))
    $g.FillEllipse($glowBrush, 55, 105, 110, 110)
    $circlePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(100, 129, 140, 248), 1.0)
    $circlePen.DashStyle = [System.Drawing.Drawing2D.DashStyle]::Dash
    $g.DrawEllipse($circlePen, 65, 115, 90, 90)

    # Orbiting particle
    $angle = ($f / $totalFrames) * 2 * [Math]::PI
    $partX = 110 + [Math]::Cos($angle) * 42
    $partY = 160 + [Math]::Sin($angle) * 42
    $partBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(56, 189, 248))
    $g.FillEllipse($partBrush, [float]($partX - 3), [float]($partY - 3), 6, 6)

    # Cloud shape
    $cy = 150 + $cloudFloatY
    $cloudBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        (New-Object System.Drawing.PointF(75, [float]$cy)),
        (New-Object System.Drawing.PointF(145, [float]($cy + 30))),
        [System.Drawing.Color]::FromArgb(255, 255, 255),
        [System.Drawing.Color]::FromArgb(147, 197, 253)
    )
    $g.FillEllipse($cloudBrush, 80, [float]($cy - 5), 35, 30)
    $g.FillEllipse($cloudBrush, 100, [float]($cy - 16), 38, 38)
    $g.FillEllipse($cloudBrush, 122, [float]($cy - 2), 30, 26)
    $g.FillRectangle($cloudBrush, 90, [float]($cy + 5), 45, 18)

    # Download arrow
    $arrowPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(2, 132, 199), 3.0)
    $arrowPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $arrowPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($arrowPen, 118, [float]($arrowY - 10), 118, [float]($arrowY + 8))
    $g.DrawLine($arrowPen, 111, [float]($arrowY + 1), 118, [float]($arrowY + 8))
    $g.DrawLine($arrowPen, 125, [float]($arrowY + 1), 118, [float]($arrowY + 8))

    # Tray
    $trayPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 56, 189, 248), 2.5)
    $trayPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $trayPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($trayPen, 85, 195, 150, 195)
    $g.DrawLine($trayPen, 85, 190, 85, 195)
    $g.DrawLine($trayPen, 150, 190, 150, 195)

    # Right Content Area
    $tagBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(30, 41, 59))
    $tagBorder = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(56, 189, 248), 1.0)
    $g.FillRectangle($tagBrush, 190, 68, 140, 20)
    $g.DrawRectangle($tagBorder, 190, 68, 140, 20)

    $tagFont = New-Object System.Drawing.Font("Segoe UI", 8.5, [System.Drawing.FontStyle]::Bold)
    $cyanBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(56, 189, 248))
    $g.DrawString("PYTHON CLI TOOL", $tagFont, $cyanBrush, 198, 71)

    # Title
    $titleFont = New-Object System.Drawing.Font("Segoe UI", 21, [System.Drawing.FontStyle]::Bold)
    $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $purpleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(129, 140, 248))
    $g.DrawString("iCloud", $titleFont, $whiteBrush, 188, 94)
    $g.DrawString("Downloader", $titleFont, $purpleBrush, 282, 94)

    # Subtitle
    $subFont = New-Object System.Drawing.Font("Segoe UI", 10.5, [System.Drawing.FontStyle]::Regular)
    $grayBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(148, 163, 184))
    $g.DrawString("Backup & export Apple Photos & Albums locally", $subFont, $grayBrush, 190, 135)

    # Badges
    $badgeBorder = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(51, 65, 85), 1.0)
    $badgeFont = New-Object System.Drawing.Font("Segoe UI", 8.5, [System.Drawing.FontStyle]::Bold)
    $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(226, 232, 240))

    # Badge 1
    $g.FillRectangle($tagBrush, 190, 180, 125, 28)
    $g.DrawRectangle($badgeBorder, 190, 180, 125, 28)
    $greenDot = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(16, 185, 129))
    $g.FillEllipse($greenDot, 198, 190, 8, 8)
    $g.DrawString("2FA Supported", $badgeFont, $textBrush, 212, 186)

    # Badge 2
    $g.FillRectangle($tagBrush, 325, 180, 135, 28)
    $g.DrawRectangle($badgeBorder, 325, 180, 135, 28)
    $cyanDot = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(56, 189, 248))
    $g.FillEllipse($cyanDot, 333, 190, 8, 8)
    $g.DrawString("Album Hierarchy", $badgeFont, $textBrush, 347, 186)

    # Badge 3
    $g.FillRectangle($tagBrush, 470, 180, 145, 28)
    $g.DrawRectangle($badgeBorder, 470, 180, 145, 28)
    $purpleDot = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(192, 132, 252))
    $g.FillEllipse($purpleDot, 478, 190, 8, 8)
    $g.DrawString("Mac · Linux · Win", $badgeFont, $textBrush, 492, 186)

    # Footer Line
    $g.DrawString("100% Free & Open Source  ·  Full Resolution Downloads", $tagFont, $cyanBrush, 190, 226)

    $g.Dispose()
    $frameBitmaps += $bmp
}

# Quantize each frame fast using LockBits
$allPixelIndices = @()
for ($f = 0; $f -lt $totalFrames; $f++) {
    $bmp = $frameBitmaps[$f]
    $rect = New-Object System.Drawing.Rectangle(0, 0, $width, $height)
    $bmpData = $bmp.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadOnly, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $numBytes = $width * $height * 4
    $rgbValues = New-Object byte[] $numBytes
    [System.Runtime.InteropServices.Marshal]::Copy($bmpData.Scan0, $rgbValues, 0, $numBytes)
    $bmp.UnlockBits($bmpData)

    $pixels = New-Object byte[] ($width * $height)
    $p = 0
    for ($i = 0; $i -lt $numBytes; $i += 4) {
        $b = $rgbValues[$i]
        $gv = $rgbValues[$i+1]
        $r = $rgbValues[$i+2]

        $minD = 99999999
        $best = 0
        for ($k = 0; $k -lt 16; $k++) {
            $pal = $palette[$k]
            $dr = [int]$r - [int]$pal.R
            $dg = [int]$gv - [int]$pal.G
            $db = [int]$b - [int]$pal.B
            $d = ($dr * $dr) + ($dg * $dg) + ($db * $db)
            if ($d -lt $minD) {
                $minD = $d
                $best = $k
                if ($d -eq 0) { break }
            }
        }
        $pixels[$p++] = [byte]$best
    }
    $allPixelIndices += ,$pixels
}

# Encode to GIF Stream
$ms = New-Object System.IO.MemoryStream
$bw = New-Object System.IO.BinaryWriter($ms)

$bw.Write([System.Text.Encoding]::ASCII.GetBytes("GIF89a"))
$bw.Write([uint16]$width)
$bw.Write([uint16]$height)
$bw.Write([byte]0xF7)
$bw.Write([byte]0x00)
$bw.Write([byte]0x00)
$bw.Write($fullPalette, 0, 768)

# Netscape Loop Extension
$bw.Write([byte]0x21)
$bw.Write([byte]0xFF)
$bw.Write([byte]0x0B)
$bw.Write([System.Text.Encoding]::ASCII.GetBytes("NETSCAPE2.0"))
$bw.Write([byte]0x03)
$bw.Write([byte]0x01)
$bw.Write([uint16]0)
$bw.Write([byte]0x00)

for ($f = 0; $f -lt $totalFrames; $f++) {
    # Graphic Control Extension
    $bw.Write([byte]0x21)
    $bw.Write([byte]0xF9)
    $bw.Write([byte]0x04)
    $bw.Write([byte]0x00)
    $bw.Write([uint16]$frameDelay)
    $bw.Write([byte]0x00)
    $bw.Write([byte]0x00)

    # Image Descriptor
    $bw.Write([byte]0x2C)
    $bw.Write([uint16]0)
    $bw.Write([uint16]0)
    $bw.Write([uint16]$width)
    $bw.Write([uint16]$height)
    $bw.Write([byte]0x00)

    # Uncompressed / Simple Run LZW encoder
    $pixels = $allPixelIndices[$f]
    $minCodeSize = 8
    $bw.Write([byte]$minCodeSize)

    $clearCode = 256
    $endCode = 257

    $bitBuffer = 0
    $bitCount = 0
    $packet = New-Object byte[] 255
    $packetLen = 0

    $flushBits = {
        param([int]$code, [int]$bits)
        $script:bitBuffer = $script:bitBuffer -bor ($code -shl $script:bitCount)
        $script:bitCount += $bits
        while ($script:bitCount -ge 8) {
            $script:packet[$script:packetLen++] = [byte]($script:bitBuffer -band 0xFF)
            $script:bitBuffer = $script:bitBuffer -shr 8
            $script:bitCount -= 8
            if ($script:packetLen -eq 254) {
                $bw.Write([byte]254)
                $bw.Write($script:packet, 0, 254)
                $script:packetLen = 0
            }
        }
    }

    & $flushBits $clearCode 9
    for ($i = 0; $i -lt $pixels.Length; $i++) {
        & $flushBits ([int]$pixels[$i]) 9
        if ($i % 400 -eq 399) {
            & $flushBits $clearCode 9
        }
    }
    & $flushBits $endCode 9

    if ($bitCount -gt 0) {
        $packet[$packetLen++] = [byte]($bitBuffer -band 0xFF)
    }
    if ($packetLen -gt 0) {
        $bw.Write([byte]$packetLen)
        $bw.Write($packet, 0, $packetLen)
    }
    $bw.Write([byte]0x00)
}

$bw.Write([byte]0x3B)
$bw.Flush()

[System.IO.File]::WriteAllBytes($outputGif, $ms.ToArray())
$fileSize = (Get-Item $outputGif).Length
Write-Output "GIF Successfully Generated: $outputGif ($fileSize bytes)"