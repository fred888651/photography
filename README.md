<#
.Synopsis

   November 18, 2026
   Fredrik Hedlund

   Convert JPG file to square 2400x2400 pixel image, with white borders, suitable for Instagram

   Version 0.0.1

   Runs asynchronous/parallel, powershell 7.x required
   (processes MANY photos at the same time, great for large batches, ex photographers with many photos)

   LAB color space or sRGB color space for sharpening. Default is LAB.

   Does not have a GUI. This is a command line batch tool. Its very fast compares to GUI applications.

   2400 pixels or more on longest side --> shrink to 2400 pixels
   Smaller than 2400 pixels --> do nothing

   ImageMagick 16 bit required, static version recommended

   Tested with 26155 x 39235 , 8688 × 5792 , 5792 x 8688 , 2400 x 1600 , 1600 x 2400, 1 x 2400 , 2400 x 1 , 12 x 12 pixels input JPG photos
   Works great, behaves as expected.

   (For some reason 1x1 and 2x2 pixels images do not work, but that is maybe not so useful anyway...)

   ImageMagick 7.1.2-35 Q16 x64 sometimes display warning then reading metadata (old DSLR? Canon Eos 5dmkII).
   This warning is ignored.

   Tested on windows 10 pro, windows server datacenter 2025
   (Should work with some replacement of win32 classes for memory/disk/cpu check.)

   PsScriptAnalyzer returns no error/warning

   License MIT 2.0

.DESCRIPTION

   Can sharpen photo using unsharp mask in LAB and sRGB color space (default LAB color space)

   JPG Quality can be set (default 100)

   Number of threads can be set (default -2 threads)

   Change factor can be set manually (default 10)
   Depending on exact type of image encoder settings, a lot more ram memory is consumed by ImageMagick for each image,
   A simple .TIFF with one high res image, and a few simple adjustment layers can grow 6-10 times
   Also, compression of .TIFF affects how much ram each image need
   Then a new image starts processing by ImageMagick, file size is multiplied with change factor in each thread

   Installed 16 bit version of ImageMagick (static) recommended, async/parallel can sometimes run into issues with dynamic ImageMagick version

   Runs in async/parallel mode, powershell 7.x required

.EXAMPLE

   Get-JpgSquareFromJpgParallel -InputDir "C:\some dir with JPG files" -verbose

.EXAMPLE

   Get-JpgSquareFromJpgParallel -InputDir "C:\some dir with JPG files" SharpenInLABColorSpace:$false -ThrottleLimit 14 -SharpeningStrength VeryStrong -Quality 90 -Verbose

.INPUTS

   Folder with JPG images

.OUTPUTS

   Output square JPG images, sharpened, to default or specified output folder
   Writes log file to same folder

   Example usage/output:

. .\Get-JpgSquareFromJpgParallel.ps1

Invoke-ScriptAnalyzer -Path .\Get-JpgSquareFromJpgParallel.ps1

Get-JpgSquareFromJpgParallel -InputDir 'C:\Test\TestSuite' -Verbose -Debug

Transcript started, output file is C:\Test\Get-JpgSquareFromJpgParallel\Get-JpgSquareFromJpgParallel 2026-11-18_165649.txt

DEBUG: 2026-11-18T16:56:49.3578191-08:00 BLACK Get-JpgSquareFromJpgParallel Version: ImageMagick 7.1.2-35 Q16 x64 5d1bcc5:20261031 https://imagemagick.org Copyright: (C) 1999 ImageMagick Studio LLC License: https://imagemagick.org/license/ Features: Channel-masks(64-bit) Cipher DPC OpenCL OpenMP(2.0)  Delegates (built-in): bzlib cairo freetype gslib heic jng jp2 jpeg jxl lcms lqr lzma openexr pangocairo png ps raqm raw rsvg tiff webp xml zip zlib zstd Compiler: Visual Studio 2026 (195136260)
VERBOSE: Perform operation 'Enumerate CimInstances' with following parameters, ''className' = Win32_LogicalDisk,'namespaceName' = root\cimv2'.
VERBOSE: Operation 'Enumerate CimInstances' complete.
VERBOSE: Perform operation 'Enumerate CimInstances' with following parameters, ''className' = win32_operatingSystem,'namespaceName' = root\cimv2'.
VERBOSE: Operation 'Enumerate CimInstances' complete.
VERBOSE: 2026-11-18T16:56:49.4615143-08:00 BLACK Get-JpgSquareFromJpgParallel Sharpening strength 'Strong' --> Unsharp Mask '0x1.5+1.5+0.08' .
VERBOSE: '2x2.jpg' '0.000600814819335938' [mb] .
VERBOSE: '1x1.jpg' '0.000600814819335938' [mb] .
VERBOSE: '12x12.jpg' '0.000609397888183594' [mb] .
VERBOSE: '24x24.jpg' '0.000614166259765625' [mb] .
VERBOSE: '1x2400.jpg' '0.00110054016113281' [mb] .
VERBOSE: '11x2400.jpg' '0.00160408020019531' [mb] .
VERBOSE: '240x240.jpg' '0.00210189819335938' [mb] .
VERBOSE: '2400x1.jpg' '0.00214481353759766' [mb] .
VERBOSE: '2400x11.jpg' '0.00264835357666016' [mb] .
VERBOSE: 'IMG_6246.jpg' '5.57845687866211' [mb] .
VERBOSE: 'IMG_6260.jpg' '6.15327167510986' [mb] .
VERBOSE: 'IMG_6221.jpg' '6.29126453399658' [mb] .
VERBOSE: 'IMG_6213.jpg' '6.33262825012207' [mb] .
VERBOSE: 'IMG_6268.jpg' '6.34022331237793' [mb] .
VERBOSE: 'IMG_6211.jpg' '6.36170291900635' [mb] .
VERBOSE: 'IMGL0159.jpg' '7.5078239440918' [mb] .
VERBOSE: 'IMGL7653.jpg' '8.50332641601562' [mb] .
VERBOSE: 'IMGL7607.jpg' '10.6239471435547' [mb] .
VERBOSE: 'IMGL0162.jpg' '10.8961114883423' [mb] .
VERBOSE: 'IMGL0103.jpg' '10.9733877182007' [mb] .
VERBOSE: 'IMGL0058.jpg' '11.3516893386841' [mb] .
VERBOSE: 'IMGL7697.jpg' '12.1250076293945' [mb] .
VERBOSE: 'IMGL0003.jpg' '12.131443977356' [mb] .
VERBOSE: 'IMGL0012.jpg' '12.3368577957153' [mb] .
VERBOSE: 'IMGL7687.jpg' '12.8414764404297' [mb] .
VERBOSE: 'IMGL0186.jpg' '12.9018144607544' [mb] .
VERBOSE: 'IMGL7662.jpg' '12.9151496887207' [mb] .
VERBOSE: 'IMGL7588.jpg' '12.9337940216064' [mb] .
VERBOSE: 'IMGL0032.jpg' '12.9838399887085' [mb] .
VERBOSE: 'IMGL7796.jpg' '13.0118646621704' [mb] .
VERBOSE: 'IMGL0106.jpg' '13.2075395584106' [mb] .
VERBOSE: 'IMGL7777.jpg' '13.3499956130981' [mb] .
VERBOSE: 'IMGL0019.jpg' '13.5704851150513' [mb] .
VERBOSE: 'IMGL7617.jpg' '13.6086387634277' [mb] .
VERBOSE: 'IMGL7631.jpg' '13.6415853500366' [mb] .
VERBOSE: 'IMGL0067.jpg' '14.2316312789917' [mb] .
VERBOSE: 'IMGL7791.jpg' '14.6547966003418' [mb] .
VERBOSE: 'IMGL0040.jpg' '14.7958784103394' [mb] .
VERBOSE: 'IMGL0068.jpg' '15.4124212265015' [mb] .
VERBOSE: 'IMGL0046.jpg' '16.2570400238037' [mb] .
VERBOSE: 'IMGL7803.jpg' '16.9225654602051' [mb] .
VERBOSE: 'IMGL0085.jpg' '18.5942525863647' [mb] .
VERBOSE: 'IMGL7684.jpg' '20.9500169754028' [mb] .
VERBOSE: '26155x39235.jpg' '232.621317863464' [mb] .
VERBOSE: 2026-11-18T16:56:49.4885207-08:00 BLACK Get-JpgSquareFromJpgParallel '44' files in 'C:\Test\TestSuite' == '642.9' [mb] .
VERBOSE: Perform operation 'Enumerate CimInstances' with following parameters, ''className' = win32_processor,'namespaceName' = root\cimv2'.
VERBOSE: Operation 'Enumerate CimInstances' complete.
VERBOSE: 2026-11-18T16:56:50.5661602-08:00 BLACK Test-CpuLoadIsHigh Current Cpu Load '1' %
VERBOSE: Perform operation 'Enumerate CimInstances' with following parameters, ''className' = win32_processor,'namespaceName' = root\cimv2'.
VERBOSE: Operation 'Enumerate CimInstances' complete.
VERBOSE: 2026-11-18T16:56:51.9883152-08:00 BLACK Test-CpuLoadIsHigh Current Cpu Load '3' %
VERBOSE: Perform operation 'Enumerate CimInstances' with following parameters, ''className' = win32_processor,'namespaceName' = root\cimv2'.
VERBOSE: Operation 'Enumerate CimInstances' complete.
VERBOSE: 2026-11-18T16:56:53.4253967-08:00 BLACK Test-CpuLoadIsHigh Current Cpu Load '1' %
VERBOSE: 2026-11-18T16:56:53.5464257-08:00 BLACK Test-CpuLoadIsHigh Cpu Load: 1.66666666666667
VERBOSE: 2026-11-18T16:56:53.5477526-08:00 BLACK Get-JpgSquareFromJpgParallel Low cpu load .
VERBOSE: 2026-11-18T16:56:53.5511376-08:00 BLACK Get-JpgSquareFromJpgParallel Parallel image processing start . . .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMG_6213__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMG_6211__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMG_6221__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMG_6246__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMG_6260__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMG_6268__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
magick.exe: ParseError missing > @ warning/xml-tree.c/NewXMLTree/1808.
magick.exe: ParseError missing > @ warning/xml-tree.c/NewXMLTree/1808.
magick.exe: ParseError missing > @ warning/xml-tree.c/NewXMLTree/1808.
magick.exe: ParseError missing > @ warning/xml-tree.c/NewXMLTree/1808.
magick.exe: ParseError missing > @ warning/xml-tree.c/NewXMLTree/1808.
magick.exe: ParseError missing > @ warning/xml-tree.c/NewXMLTree/1808.
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\1x2400__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\2400x1__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\11x2400__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\2400x11__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL7803__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL7777__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL7791__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL7796__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL7687__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL7697__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL7588__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL7607__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL7617__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL7631__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL7653__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL7662__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL7684__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL0085__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL0103__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL0106__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL0159__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL0162__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL0186__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL0003__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL0012__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL0019__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL0032__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL0040__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL0046__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL0058__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL0067__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\IMGL0068__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\1x1__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\24x24__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\240x240__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\2x2__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\26155x39235__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
WARNING: 'C:\Test\Get-JpgSquareFromJpgParallel\12x12__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' will be overwritten .
DEBUG: magick.exe: ParseError missing > @ warning/xml-tree.c/NewXMLTree/1808. Removed from PS error-variable .
DEBUG: magick.exe: ParseError missing > @ warning/xml-tree.c/NewXMLTree/1808. Removed from PS error-variable .
DEBUG: magick.exe: ParseError missing > @ warning/xml-tree.c/NewXMLTree/1808. Removed from PS error-variable .
DEBUG: magick.exe: ParseError missing > @ warning/xml-tree.c/NewXMLTree/1808. Removed from PS error-variable .
DEBUG: magick.exe: ParseError missing > @ warning/xml-tree.c/NewXMLTree/1808. Removed from PS error-variable .
DEBUG: magick.exe: ParseError missing > @ warning/xml-tree.c/NewXMLTree/1808. Removed from PS error-variable .
VERBOSE: 2026-11-18T16:57:55.5873262-08:00 BLACK Get-JpgSquareFromJpgParallel 'C:\Test\TestSuite' --> 'C:\Test\Get-JpgSquareFromJpgParallel' .
VERBOSE: 2026-11-18T16:57:55.5899558-08:00 BLACK Get-JpgSquareFromJpgParallel '44' files '642.9' [mb] processed in 62039.2708 [ms] @ '10.4' [mb/sec] with '0' error/s .

Transcript stopped, output file is C:\Test\Get-JpgSquareFromJpgParallel\Get-JpgSquareFromJpgParallel 2026-11-18_165649.txt

.NOTES

   Use at your own risk...
   With great power, comes great responsibility...
   This tool is for advanced users.
   You should be comfortable using command line tools/large batch jobs.
   You should probably have at least a 8 core CPU and lots of memory.
   (But works great on older CPUs with 4 cores and 16 GB memory).

   GPU not required.

.COMPONENT

.ROLE

   Photography, social media, square format, Instagram

.FUNCTIONALITY

   Convert JPG image to square format, suitable for Instagram

#>
