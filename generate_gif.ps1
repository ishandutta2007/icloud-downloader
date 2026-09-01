Add-Type -AssemblyName System.Drawing

$csharpCode = @"
using System;
using System.IO;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;
using System.Collections.Generic;

public class SocialPreviewGenerator
{
    public static void Generate(string outputPath)
    {
        int width = 800;
        int height = 400;
        int totalFrames = 20;
        int delayHundredths = 9; // 90ms per frame

        GifEncoder encoder = new GifEncoder(width, height, delayHundredths);

        for (int f = 0; f < totalFrames; f++)
        {
            using (Bitmap bmp = new Bitmap(width, height, PixelFormat.Format32bppArgb))
            using (Graphics g = Graphics.FromImage(bmp))
            {
                g.SmoothingMode = SmoothingMode.AntiAlias;
                g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;
                g.InterpolationMode = InterpolationMode.HighQualityBicubic;

                // 1. Background Gradient
                using (LinearGradientBrush bgBrush = new LinearGradientBrush(
                    new Point(0, 0),
                    new Point(width, height),
                    Color.FromArgb(11, 15, 25),
                    Color.FromArgb(17, 24, 39)))
                {
                    g.FillRectangle(bgBrush, 0, 0, width, height);
                }

                // 2. Subtle Grid
                using (Pen gridPen = new Pen(Color.FromArgb(25, 51, 65, 85), 1))
                {
                    for (int x = 40; x < width; x += 50)
                        g.DrawLine(gridPen, x, 0, x, height);
                    for (int y = 40; y < height; y += 50)
                        g.DrawLine(gridPen, 0, y, width, y);
                }

                // 3. Glowing Ambient Orbs
                using (SolidBrush orb1 = new SolidBrush(Color.FromArgb(24, 56, 189, 248)))
                {
                    g.FillEllipse(orb1, 30, 70, 200, 200);
                }
                using (SolidBrush orb2 = new SolidBrush(Color.FromArgb(20, 168, 85, 247)))
                {
                    g.FillEllipse(orb2, 580, 160, 200, 200);
                }

                // 4. Accent Border
                using (Pen borderPen = new Pen(Color.FromArgb(60, 56, 189, 248), 1.5f))
                {
                    g.DrawRectangle(borderPen, 2, 2, width - 4, height - 4);
                }

                // 5. Left Hero Graphic: iCloud Animated Sync & Download
                float centerX = 135f;
                float centerY = 180f;
                double phase = ((double)f / totalFrames) * 2.0 * Math.PI;
                float cloudFloatY = (float)(Math.Sin(phase) * 6.0);

                // Dashed Glow Orbit
                using (Pen ringPen = new Pen(Color.FromArgb(80, 129, 140, 248), 1.2f))
                {
                    ringPen.DashStyle = DashStyle.Dash;
                    g.DrawEllipse(ringPen, centerX - 60, centerY - 60, 120, 120);
                }

                // Orbiting Particles
                float p1X = centerX + (float)(Math.Cos(phase) * 60.0);
                float p1Y = centerY + (float)(Math.Sin(phase) * 60.0);
                using (SolidBrush p1Brush = new SolidBrush(Color.FromArgb(56, 189, 248)))
                {
                    g.FillEllipse(p1Brush, p1X - 4f, p1Y - 4f, 8f, 8f);
                }

                float p2X = centerX + (float)(Math.Cos(phase + Math.PI) * 60.0);
                float p2Y = centerY + (float)(Math.Sin(phase + Math.PI) * 60.0);
                using (SolidBrush p2Brush = new SolidBrush(Color.FromArgb(192, 132, 252)))
                {
                    g.FillEllipse(p2Brush, p2X - 3f, p2Y - 3f, 6f, 6f);
                }

                // Cloud shape
                float cy = centerY - 14f + cloudFloatY;
                using (LinearGradientBrush cloudBrush = new LinearGradientBrush(
                    new PointF(centerX - 45f, cy),
                    new PointF(centerX + 45f, cy + 40f),
                    Color.FromArgb(255, 255, 255),
                    Color.FromArgb(147, 197, 253)))
                {
                    g.FillEllipse(cloudBrush, centerX - 42f, cy - 4f, 42f, 38f);
                    g.FillEllipse(cloudBrush, centerX - 18f, cy - 18f, 48f, 48f);
                    g.FillEllipse(cloudBrush, centerX + 10f, cy - 2f, 38f, 34f);
                    g.FillRectangle(cloudBrush, centerX - 28f, cy + 8f, 58f, 22f);
                }

                // Animated Download Arrow
                float arrowLoop = (float)((f % 10) / 9.0);
                float arrowY = cy + 4f + (arrowLoop * 26f);
                int arrowAlpha = (int)(255 * (1.0f - (arrowLoop * 0.35f)));
                using (Pen arrowPen = new Pen(Color.FromArgb(arrowAlpha, 2, 132, 199), 4f))
                {
                    arrowPen.StartCap = LineCap.Round;
                    arrowPen.EndCap = LineCap.Round;
                    g.DrawLine(arrowPen, centerX, arrowY - 12f, centerX, arrowY + 8f);
                    g.DrawLine(arrowPen, centerX - 8f, arrowY, centerX, arrowY + 8f);
                    g.DrawLine(arrowPen, centerX + 8f, arrowY, centerX, arrowY + 8f);
                }

                // Storage Tray
                using (Pen trayPen = new Pen(Color.FromArgb(200, 56, 189, 248), 2.5f))
                {
                    trayPen.StartCap = LineCap.Round;
                    trayPen.EndCap = LineCap.Round;
                    g.DrawLine(trayPen, centerX - 40f, centerY + 48f, centerX + 40f, centerY + 48f);
                    g.DrawLine(trayPen, centerX - 40f, centerY + 40f, centerX - 40f, centerY + 48f);
                    g.DrawLine(trayPen, centerX + 40f, centerY + 40f, centerX + 40f, centerY + 48f);
                }

                // 6. Right Side Content
                float rightX = 245f;

                // Category Tag
                using (SolidBrush tagBg = new SolidBrush(Color.FromArgb(30, 41, 59)))
                using (Pen tagBorder = new Pen(Color.FromArgb(120, 56, 189, 248), 1f))
                using (Font tagFont = new Font("Segoe UI", 9.5f, FontStyle.Bold))
                using (SolidBrush cyanBrush = new SolidBrush(Color.FromArgb(56, 189, 248)))
                {
                    g.FillRectangle(tagBg, rightX, 42, 160, 26);
                    g.DrawRectangle(tagBorder, rightX, 42, 160, 26);
                    g.DrawString("PYTHON CLI TOOL", tagFont, cyanBrush, rightX + 10, 46);
                }

                // Title: iCloud Downloader
                using (Font titleFont = new Font("Segoe UI", 28f, FontStyle.Bold))
                using (SolidBrush whiteBrush = new SolidBrush(Color.White))
                using (SolidBrush purpleBrush = new SolidBrush(Color.FromArgb(168, 85, 247)))
                {
                    g.DrawString("iCloud", titleFont, whiteBrush, rightX - 4, 74);
                    g.DrawString("Downloader", titleFont, purpleBrush, rightX + 116, 74);
                }

                // Subtitle
                using (Font subFont = new Font("Segoe UI", 12f, FontStyle.Regular))
                using (SolidBrush grayBrush = new SolidBrush(Color.FromArgb(148, 163, 184)))
                {
                    g.DrawString("Automated, fast & secure backup for Apple Photos & Albums", subFont, grayBrush, rightX, 126);
                }

                // Feature Badges
                using (Font badgeFont = new Font("Segoe UI", 9.5f, FontStyle.Bold))
                using (SolidBrush badgeBg = new SolidBrush(Color.FromArgb(24, 33, 47)))
                using (Pen badgeBorder = new Pen(Color.FromArgb(51, 65, 85), 1f))
                using (SolidBrush textLight = new SolidBrush(Color.FromArgb(226, 232, 240)))
                {
                    // Badge 1: 2FA Supported
                    g.FillRectangle(badgeBg, rightX, 162, 150, 32);
                    g.DrawRectangle(badgeBorder, rightX, 162, 150, 32);
                    using (SolidBrush d1 = new SolidBrush(Color.FromArgb(16, 185, 129)))
                        g.FillEllipse(d1, rightX + 12, 174, 8, 8);
                    g.DrawString("2FA Supported", badgeFont, textLight, rightX + 26, 168);

                    // Badge 2: Album Hierarchy
                    float b2X = rightX + 162;
                    g.FillRectangle(badgeBg, b2X, 162, 160, 32);
                    g.DrawRectangle(badgeBorder, b2X, 162, 160, 32);
                    using (SolidBrush d2 = new SolidBrush(Color.FromArgb(56, 189, 248)))
                        g.FillEllipse(d2, b2X + 12, 174, 8, 8);
                    g.DrawString("Album Hierarchy", badgeFont, textLight, b2X + 26, 168);

                    // Badge 3: Cross-Platform
                    float b3X = rightX + 334;
                    g.FillRectangle(badgeBg, b3X, 162, 185, 32);
                    g.DrawRectangle(badgeBorder, b3X, 162, 185, 32);
                    using (SolidBrush d3 = new SolidBrush(Color.FromArgb(192, 132, 252)))
                        g.FillEllipse(d3, b3X + 12, 174, 8, 8);
                    g.DrawString("Mac · Linux · Win · NAS", badgeFont, textLight, b3X + 26, 168);
                }

                // 7. Interactive Terminal Progress Box
                float termY = 212f;
                using (SolidBrush termBg = new SolidBrush(Color.FromArgb(15, 20, 30)))
                using (Pen termBorder = new Pen(Color.FromArgb(45, 55, 75), 1f))
                using (Font termFont = new Font("Consolas", 10f, FontStyle.Regular))
                {
                    g.FillRectangle(termBg, rightX, termY, 520, 125);
                    g.DrawRectangle(termBorder, rightX, termY, 520, 125);

                    // Window control dots
                    using (SolidBrush dr = new SolidBrush(Color.FromArgb(239, 68, 68)))
                        g.FillEllipse(dr, rightX + 12, termY + 10, 8, 8);
                    using (SolidBrush dy = new SolidBrush(Color.FromArgb(234, 179, 8)))
                        g.FillEllipse(dy, rightX + 26, termY + 10, 8, 8);
                    using (SolidBrush dg = new SolidBrush(Color.FromArgb(34, 197, 94)))
                        g.FillEllipse(dg, rightX + 40, termY + 10, 8, 8);

                    using (SolidBrush termHeader = new SolidBrush(Color.FromArgb(100, 116, 139)))
                    {
                        g.DrawString("bash - icloud_downloader", termFont, termHeader, rightX + 60, termY + 6);
                    }

                    // Command prompt
                    using (SolidBrush termCmd = new SolidBrush(Color.FromArgb(56, 189, 248)))
                    {
                        g.DrawString("$ python icloud_downloader.py --all-albums", termFont, termCmd, rightX + 12, termY + 32);
                    }

                    // Progress bar
                    int progressPercent = Math.Min(100, (int)(((f + 1) / (double)totalFrames) * 100));
                    int barTotalWidth = 280;
                    int barFillWidth = (int)((progressPercent / 100.0) * barTotalWidth);

                    using (SolidBrush barBg = new SolidBrush(Color.FromArgb(30, 41, 59)))
                    using (SolidBrush barFill = new SolidBrush(Color.FromArgb(16, 185, 129)))
                    {
                        g.FillRectangle(barBg, rightX + 12, termY + 62, barTotalWidth, 16);
                        if (barFillWidth > 0)
                            g.FillRectangle(barFill, rightX + 12, termY + 62, barFillWidth, 16);
                    }

                    int currentFileCount = (int)(progressPercent * 2.4);
                    using (SolidBrush termWhite = new SolidBrush(Color.FromArgb(226, 232, 240)))
                    {
                        g.DrawString(string.Format("{0}% [{1}/240 files]", progressPercent, currentFileCount), termFont, termWhite, rightX + 305, termY + 62);
                    }

                    // Status line
                    using (SolidBrush termStatus = new SolidBrush(Color.FromArgb(148, 163, 184)))
                    {
                        string currentFileName = string.Format("Downloading: IMG_{0:D4}.HEIC [Original 4K Live Photo]", 4800 + f * 3);
                        g.DrawString(currentFileName, termFont, termStatus, rightX + 12, termY + 92);
                    }
                }

                // 8. Footer Info
                using (Font footerFont = new Font("Segoe UI", 9.5f, FontStyle.Regular))
                using (SolidBrush footerBrush = new SolidBrush(Color.FromArgb(100, 116, 139)))
                {
                    g.DrawString("MIT License  ·  100% Free & Open Source  ·  Lossless Full-Resolution Downloads", footerFont, footerBrush, rightX, 355);
                }

                encoder.AddFrame(bmp);
            }
        }

        byte[] gifBytes = encoder.Finish();
        File.WriteAllBytes(outputPath, gifBytes);
        Console.WriteLine("Successfully created animated GIF ({0} bytes) at: {1}", gifBytes.Length, outputPath);
    }
}

public class GifEncoder
{
    private MemoryStream _stream;
    private BinaryWriter _writer;
    private int _width;
    private int _height;
    private int _delay;
    private bool _firstFrame = true;

    public GifEncoder(int width, int height, int delay)
    {
        _width = width;
        _height = height;
        _delay = delay;
        _stream = new MemoryStream();
        _writer = new BinaryWriter(_stream);
    }

    public void AddFrame(Bitmap bmp)
    {
        byte[] paletteBytes = new byte[768];
        byte[] indexedPixels = QuantizeTo256(bmp, paletteBytes);

        if (_firstFrame)
        {
            // Header
            _writer.Write(new char[] { 'G', 'I', 'F', '8', '9', 'a' });

            // Logical Screen Descriptor
            _writer.Write((ushort)_width);
            _writer.Write((ushort)_height);
            _writer.Write((byte)0xF7); // Global Color Table Flag = 1, Color Res = 7, Sort = 0, Size = 7 (256 colors)
            _writer.Write((byte)0x00); // BG Color Index
            _writer.Write((byte)0x00); // Pixel Aspect Ratio

            // Global Color Table
            _writer.Write(paletteBytes);

            // Netscape 2.0 Loop Extension (Infinite Loop)
            _writer.Write((byte)0x21);
            _writer.Write((byte)0xFF);
            _writer.Write((byte)0x0B);
            _writer.Write(System.Text.Encoding.ASCII.GetBytes("NETSCAPE2.0"));
            _writer.Write((byte)0x03);
            _writer.Write((byte)0x01);
            _writer.Write((ushort)0);
            _writer.Write((byte)0x00);

            _firstFrame = false;
        }

        // Graphic Control Extension
        _writer.Write((byte)0x21);
        _writer.Write((byte)0xF9);
        _writer.Write((byte)0x04);
        _writer.Write((byte)0x04); // Disposal method: 1 (do not dispose)
        _writer.Write((ushort)_delay);
        _writer.Write((byte)0x00);
        _writer.Write((byte)0x00);

        // Image Descriptor
        _writer.Write((byte)0x2C);
        _writer.Write((ushort)0);
        _writer.Write((ushort)0);
        _writer.Write((ushort)_width);
        _writer.Write((ushort)_height);
        _writer.Write((byte)0x00); // No Local Color Table

        // LZW Compressed Data
        WriteLzwData(indexedPixels, 8);
    }

    public byte[] Finish()
    {
        _writer.Write((byte)0x3B); // GIF Trailer
        _writer.Flush();
        return _stream.ToArray();
    }

    private byte[] QuantizeTo256(Bitmap bmp, byte[] outPalette)
    {
        int totalPixels = _width * _height;
        byte[] indexed = new byte[totalPixels];

        // Standard 6x7x6 color cube + key theme colors
        List<Color> pal = new List<Color>();
        for (int r = 0; r < 6; r++)
        {
            for (int g = 0; g < 7; g++)
            {
                for (int b = 0; b < 6; b++)
                {
                    pal.Add(Color.FromArgb((r * 255) / 5, (g * 255) / 6, (b * 255) / 5));
                }
            }
        }
        pal.Add(Color.FromArgb(11, 15, 25));
        pal.Add(Color.FromArgb(17, 24, 39));
        pal.Add(Color.FromArgb(56, 189, 248));
        pal.Add(Color.FromArgb(129, 140, 248));

        while (pal.Count < 256)
        {
            pal.Add(Color.Black);
        }

        for (int i = 0; i < 256; i++)
        {
            outPalette[i * 3]     = pal[i].R;
            outPalette[i * 3 + 1] = pal[i].G;
            outPalette[i * 3 + 2] = pal[i].B;
        }

        BitmapData data = bmp.LockBits(
            new Rectangle(0, 0, _width, _height),
            ImageLockMode.ReadOnly,
            PixelFormat.Format32bppArgb
        );

        byte[] raw = new byte[totalPixels * 4];
        System.Runtime.InteropServices.Marshal.Copy(data.Scan0, raw, 0, raw.Length);
        bmp.UnlockBits(data);

        for (int i = 0; i < totalPixels; i++)
        {
            int b = raw[i * 4];
            int g = raw[i * 4 + 1];
            int r = raw[i * 4 + 2];

            int ri = (r * 5 + 127) / 255;
            int gi = (g * 6 + 127) / 255;
            int bi = (b * 5 + 127) / 255;
            if (ri > 5) ri = 5;
            if (gi > 6) gi = 6;
            if (bi > 5) bi = 5;

            int bestIdx = (ri * 42) + (gi * 6) + bi;
            if (bestIdx >= 252) bestIdx = 251;

            indexed[i] = (byte)bestIdx;
        }

        return indexed;
    }

    private void WriteLzwData(byte[] pixels, int dataSize)
    {
        _writer.Write((byte)dataSize);

        int clearCode = 1 << dataSize; // 256
        int eoiCode = clearCode + 1;   // 257
        int codeSize = dataSize + 1;   // 9
        int maxCode = 1 << codeSize;   // 512
        int nextCode = clearCode + 2;  // 258

        Dictionary<int, int> dict = new Dictionary<int, int>(5000);

        int curBitBuffer = 0;
        int curBitCount = 0;
        byte[] packet = new byte[255];
        int packetIdx = 0;

        Action<int, int> writeBits = delegate(int code, int length)
        {
            curBitBuffer |= (code << curBitCount);
            curBitCount += length;

            while (curBitCount >= 8)
            {
                packet[packetIdx++] = (byte)(curBitBuffer & 0xFF);
                curBitBuffer >>= 8;
                curBitCount -= 8;

                if (packetIdx == 254)
                {
                    _writer.Write((byte)254);
                    _writer.Write(packet, 0, 254);
                    packetIdx = 0;
                }
            }
        };

        writeBits(clearCode, codeSize);

        int prefix = pixels[0];

        for (int i = 1; i < pixels.Length; i++)
        {
            byte c = pixels[i];
            int key = (prefix << 8) | c;

            int existingCode = 0;
            if (dict.TryGetValue(key, out existingCode))
            {
                prefix = existingCode;
            }
            else
            {
                writeBits(prefix, codeSize);

                if (nextCode < 4096)
                {
                    dict[key] = nextCode++;
                    if (nextCode > maxCode && codeSize < 12)
                    {
                        codeSize++;
                        maxCode = 1 << codeSize;
                    }
                }
                else
                {
                    writeBits(clearCode, codeSize);
                    dict.Clear();
                    codeSize = dataSize + 1;
                    maxCode = 1 << codeSize;
                    nextCode = clearCode + 2;
                }

                prefix = c;
            }
        }

        writeBits(prefix, codeSize);
        writeBits(eoiCode, codeSize);

        if (curBitCount > 0)
        {
            packet[packetIdx++] = (byte)(curBitBuffer & 0xFF);
        }

        if (packetIdx > 0)
        {
            _writer.Write((byte)packetIdx);
            _writer.Write(packet, 0, packetIdx);
        }

        _writer.Write((byte)0x00);
    }
}
"@

Add-Type -TypeDefinition $csharpCode -ReferencedAssemblies System.Drawing

$outputPath = "C:\Users\ishan\Documents\Projects\icloud-downloader\assets\social-preview.gif"
[SocialPreviewGenerator]::Generate($outputPath)
