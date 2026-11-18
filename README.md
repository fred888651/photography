<#
.Synopsis

   November 17, 2026
   Fredrik Hedlund

   Convert JPG file to square 2400x2400 pixel image, with white borders, suitable for Instagram

   Runs asynchronous/parallel, powershell 7.x required
   (processes MANY photos at the same time, great for large batches, ex photographers with many photos)

   LAB color space or sRGB color space for sharpening. Default is LAB.

   Does not have a GUI. This is a command line batch tool. Its very fast compares to GUI applications.

   2400 pixels or more on longest side --> shrink to 2400 pixels
   Smaller than 2400 pixels --> do nothing

   ImageMagick 16 bit required, static version recommended

   Tested with 8688×5792 , 5792x8688 , 2400x1600 , 1600x2400, 1x2400 , 2400x1 , 12x12 pixels input JPG photos
   Works great, behaves as expected.

   (For some reason 1x1 and 2x2 pixels images do not work, but that is maybe not so useful anyway...)

   ImageMagick 7.1.2-35 Q16 x64 sometimes display warning then reading metadata (old DSLR? Canon Eos 5dmkII).
   This warning is ignored.

   Tested on windows 10 pro, windows server datacenter 2025
   Not tested on Linux/Apple. But should work? It has no fancy coding really.

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

   Get-GetJpgSquareFromJpgParallel -InputDir "C:\some dir with JPG files" -verbose

.EXAMPLE

   Get-GetJpgSquareFromJpgParallel -InputDir "C:\some dir with JPG files" SharpenInLABColorSpace:$false -ThrottleLimit 14 -SharpeningStrength VeryStrong -Quality 90 -Verbose

.INPUTS

   Folder with JPG images

.OUTPUTS

   Output square JPG images, sharpened, to default or specified output folder
   Writes log file to same folder

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
