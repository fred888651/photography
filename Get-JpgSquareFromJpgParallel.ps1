<#
.Synopsis

   PowerShell function for parallel batch processing of JPG images, including optional luminance sharpening in CIE LAB color space and conversion to 2400×2400 square format.
   
   Designed for photography professionals, who batch process large image collections etc.

   ImageMagick 16 bit required, static version recommended
   Powershell 7.x required

   Tested with 26155 x 39235 , 8688 × 5792 , 5792 x 8688 , 2400 x 1600 , 1600 x 2400, 1 x 2400 , 2400 x 1 , 12 x 12 pixels input JPG photos
   (For some reason 1x1 and 2x2 pixels images do not work. This is not considered critical for this project.)
   
   Keeps original size for images < 2400 pixels longest side
   For images > 2400 pixels longest side, they get scaled down.
   Overwrite already existing output files. Input files are ofcourse only read, never changed.

   Command lina arguments for:
   
   JPG quality, default 100%
   
   Number of CPU cores, default -2 cores
   
   Unsharp mask, with presets mild,normal,strong,veryStrong

   ChangeFactor, how much shoud ImageMagick allocate for each file. 
   5 mb file times factor 10 = 5*10 = 50 mb reserved for ImageMagick.
   Default = 10
   
   Output folder, default is same as input folder
   
   (For some reason 1x1 and 2x2 pixels images do not work, but that is maybe not so useful anyway...)
	
   Checks free physical memory, crafts every worker thread specifically to actual file size, checks free disk space, checks CPU load, 
   Writes warning if not satisfied, keeps running
   
   checks dependencies ImageMagick + powershell version + windows operating system
   Throws error and stop if not satisfied 

   Log file ends with a simple summary, number of files, sum of all files in MB, milliseconds for processing batch, MB/Sec and number of error/s.
   Debug pipeline display ImageMagick arguments in detail, if activated. 
   Advanced function with CmdLetBinding support, writes to verbose and debug pipeline.  
   
   Tested on windows 10 pro, windows server datacenter 2025
   (Linux/Mac OS - just remove calling win32 classes for memory, disk, cpu check and it should work? Not tested)

   TO-DO: Add two types of image stamps, graphical (PNG) and text string. Placed at image center bottom fifth. CmdLetBinding whatif support.
	
   License MIT 2.0
   
   November 18, 2026
   Fredrik Hedlund

.DESCRIPTION


.EXAMPLE

   Get-JpgSquareFromJpgParallel -InputDir "C:\some dir with JPG files" -verbose

.EXAMPLE

   Get-JpgSquareFromJpgParallel -InputDir "C:\some dir with JPG files" SharpenInLABColorSpace:$false -ThrottleLimit 14 -SharpeningStrength VeryStrong -Quality 90 -Verbose

.INPUTS

   Folder with JPG images

.OUTPUTS

   JPG files + log file

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

.COMPONENT

.ROLE

   Photography, social media, square format, Instagram

.FUNCTIONALITY

   Convert JPG image/s to square format, suitable for Instagram

#>
Function Get-JpgSquareFromJpgParallel{

	[CmdletBinding()]
	[OutputType([String])]

	PARAM
    (

        # Path to input folder
        [Parameter(Mandatory=$true)]
        [string]$InputDir,

        # Path to executable
        [Parameter(Mandatory=$false)]
        [string]$ImageMagickPath = (Get-Command magick.exe).source ,

        # Path to output folder
        [Parameter(Mandatory=$false)]
        [string]$OutDir = (Split-Path $InputDir) + "\" + "$($myInvocation.myCommand.name)",

        # Sharpen in LAB color space, or sRGB color space
        [Parameter(Mandatory=$false)]
        [boolean]$SharpenInLABColorSpace = $true,

        # 'Unsharp mask' sharpening settings
        [Parameter(Mandatory=$false)]
        [ValidateSet('Mild','Medium','Strong','VeryStrong')]
        [string]$SharpeningStrength = "Strong",

        # Jpg quality (default 100)
        [Parameter(Mandatory=$false)]
        [ValidateRange(70,100)]
        [uint16]$Quality = '100',

        # Leave 2 cores free as default, require 2 cores as minimum
        [Parameter(Mandatory=$false)]
		[ValidateScript(
			{

				$_ -ge 2 -AND
				$_ -le [Environment]::ProcessorCount

			}
		)]
        [uint16]$ThrottleLimit = [Math]::Max(1, [Environment]::ProcessorCount - 2) ,

        # Limit amount of physical memory available to ImageMagick
        # This can vary, depending on several factors, you can fine tune this, default change factor = 10
        # Ex. if input file is 20mb and CF = 10 --> ImageMagick gets max file size x change factor = 20 x 10 = 200mb to use in parallel job
        [Parameter(Mandatory=$false)]
        [uint16]$CF = 10

    )

    Begin
    {

		$error.clear()

		# Create output dir, if not exist
        If( !(Test-Path $OutDir -PathType Container) )
        { New-Item $OutDir -ItemType Directory -Force -Confirm:$false | Out-Null }

		# Log file
		Start-Transcript -Path "$($OutDir)\$($myInvocation.myCommand.name) $($(get-date).tostring("yyyy-MM-dd_HHmmss")).txt" -Force -Confirm:$false

        Function Get-DateTimeFQDN{ RETURN [string]"$((Get-Date).ToString("o")) $([System.Net.Dns]::GetHostByName($env:COMPUTERNAME).hostname)"; }

		Function Test-CpuLoadIsHigh{

			[CmdletBinding()]
			[OutputType([boolean])]

			PARAM
			(
				# Max cpu load
				[Parameter(Mandatory=$false)]
				[ValidateRange(50,100)]
				$MaxCpuLoad = 50,

				# Number of samples
				[Parameter(Mandatory=$false)]
				[ValidateRange(3,7)]
				[uint16]$Samples = 3

			)

			[System.Collections.ArrayList]$cpuLoad=@()

			For($i=1 ; $i -le $samples; $i++)
			{

				Try{

					$cpuLoad += (Get-CimInstance win32_processor -ErrorAction Stop).loadpercentage
					Write-Verbose "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) Current Cpu Load '$($CpuLoad[-1])' %"
					Start-Sleep -Milliseconds (Get-Random -min 50 -max 500)

				}
				Catch{

					Write-Error $_

				}

			}

			If( ($cpuLoad | Measure-Object -Average).average -ge $MaxCpuLoad )
			{

				Write-Warning "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) High Cpu Load: $($($cpuLoad | Measure-Object -Average).average)"
				$cpuLoad.clear();
				RETURN $true;

			}
			else
			{

				Write-Verbose "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) Cpu Load: $($($cpuLoad | Measure-Object -Average).average)"
				$cpuLoad.clear();
				RETURN $false;

			}
		} # Test-CpuLoadIsHigh


        # Throw exception if magick.exe not found
        If( !(Test-Path $ImageMagickPath -PathType Leaf) )
        {

            throw "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) Required executable 'magick.exe' not found in '$($ImageMagickPath)' ."

        }
        else
        {

            $imVersion = & $imageMagickPath -version
            Write-Debug "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) $imVersion"

        }

		If( !($isWindows) )
        {

			throw "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) Windows only supported ."

		}

        # Throw exception if powershell version < 7.x
        If(

            $PSVersionTable.PSVersion.Major -lt 7

        )
        {

            Write-Warning "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) Powershell version 7.x required ."
            RETURN

        }

        # Warn if low free disk space on drive for output folder
        If(

            (Get-CimInstance Win32_LogicalDisk | Where-Object{ $_.deviceID -eq (Split-Path $outDir -Qualifier) } ).freespace/1kb/1mb -lt [double]'30'

        )
        {

            Write-Warning "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) Free space on $($(Split-Path $outDir -Qualifier)) < 30 gb ."

        }

        # Warn if low free physical memory
        If(

            (Get-CimInstance win32_operatingSystem).freephysicalMemory/1024 -lt [double]'1'

        )
        {

            Write-Warning "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) Free physical memory < 1 gb ."

        }

        # Input path valid?
        If( !(Test-Path $InputDir -IsValid) )
        { throw "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) Path is not valid: '$($InputDir)' ." }

        # Input dir exists?
        If( !(Test-Path $InputDir -PathType Container) )
        { throw "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) Path not found: '$($InputDir)' ." }

        # Unsharp mask settings
        Switch( $SharpeningStrength ){

            { $_ -eq 'Mild'}
            { [string]$SS = "0x0.75+0.75+0.02" ; BREAK }

            { $_ -eq 'Medium'}
            { [string]$SS = "0x1.0+1.0+0.05" ; BREAK }

            { $_ -eq 'Strong'}
            { [string]$SS = "0x1.5+1.5+0.08" ; BREAK }

            { $_ -eq 'VeryStrong'}
            { [string]$SS = "0x2.0+2.0+0.1" ; BREAK }

        }

        Write-Verbose "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) Sharpening strength '$($SharpeningStrength)' --> Unsharp Mask '$($SS)' ."

    } # Begin
    Process
    {

        $files = Get-ChildItem $InputDir -File | Where-Object{

              $_.name -LIKE "*.JPG" -AND $_.length -gt 0

        } | Sort-Object creationTime


        If($files.count -eq 0)
        {

            Write-Warning "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) No files found in '$($inputDir)'. Sorry. Bye." ; RETURN

        }

        $sum_MB = 0.0

        $files | Sort-Object Length | ForEach-Object -Process{

            $sum_MB = $sum_MB + $_.length/1mb
            Write-Verbose "'$($_.name)' '$($_.length/1mb)' [mb] ."

        } #Foreach

        $sum_MB = [math]::round(( $sum_MB ),1)

        Write-Verbose "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) '$($files.count)' files in '$($inputDir)' == '$($sum_MB)' [mb] ."

        [string]$functionName = $myInvocation.myCommand.name

		$fqdn = [System.Net.Dns]::GetHostByName($env:COMPUTERNAME) # handle psscriptanalyzer scope warning

		if( (Test-CpuLoadIsHigh -MaxCpuLoad 50 -Samples 3) )
		{

			Write-Warning "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) High Cpu Load ."

		}
		else
		{

			Write-verbose "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) Low cpu load ."

		}

		$sw = [System.Diagnostics.Stopwatch]::StartNew()

		Write-verbose "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) Parallel image processing start . . ."

        $log = $files | Sort-Object creationTime | ForEach-Object -Parallel{

            Function Get-DateTimeFQDN{ RETURN [string]"$((Get-Date).ToString("o")) $($USING:fqdn)"; }

            [string]$InFile  = $_.fullname

            [double]$MemLim  = [math]::Ceiling( $USING:CF * $_.length/1mb )

				###############################################################################
				#
				# ImageMagick workaround:
				#
				# -strip removes problematic metadata from older camera JPEG files.
				# Known ImageMagick XML parser warning (1808) may occur with
				# legacy metadata. This is considered non-fatal for this workflow.
				# magick.exe: ParseError missing > @ warning/xml-tree.c/NewXMLTree/1808.
				#
				###############################################################################

                If( $USING:SharpenInLABColorSpace )
                {
                    [string]$OutFile = Join-Path $USING:OutDir ( ([System.IO.Path]::GetFileNameWithoutExtension($InFile)) + "_$($myInvocation.myCommand.name)_CIE-1976-LAB-ColorSpace_Sharpening$($USING:SharpeningStrength)_Q$($USING:Quality).JPG" )

					$MagickArgs = @(

                           "$InFile",
						   "-auto-orient",
                           "-strip",
                           "-limit",
                           "memory",
                           "$($MemLim)MiB",
                           "-resize",
                            "2400x2400>",
                           "-colorspace",
                           "Lab",
                           "-channel",
                           "R",
                           "-unsharp",
                            "$USING:SS",
                            "+channel",
                            "-colorspace",
                            "sRGB",
                            "-background",
                            "white",
                            "-gravity",
                            "center",
                            "-extent",
                            "2400x2400",
                            "-quality",
                            "$USING:Quality",
                            "$OutFile"
                       )

                }
                else
                {
                    [string]$OutFile = Join-Path $USING:OutDir ( ([System.IO.Path]::GetFileNameWithoutExtension($InFile)) + "_$($myInvocation.myCommand.name)_IEC-sRGB-ColorSpace_Sharpening$($USING:SharpeningStrength)_Q$($USING:Quality).JPG" )

					$MagickArgs = @(

                        "$InFile",
						"-auto-orient",
                        "-strip",
                        "-limit",
                        "memory",
                        "$($MemLim)MiB",
                        "-resize",
                        "2400x2400>",
                        "-unsharp",
                        "$($USING:SS)",
                        "-colorspace",
                        "sRGB",
                        "-background",
                        "white",
                        "-gravity",
                        "center",
                        "-extent",
                        "2400x2400",
                        "-quality",
                        "$USING:Quality",
                        "$outFile"

                    )

                }

                # Nice to have in log file, safe to remove
                If( (Get-CimInstance win32_operatingsystem).freephysicalmemory/1kb -le $MemLim )
                {

                    Write-Warning "$($(Get-DateTimeFQDN)) $($USING:functionName) Free physical memory =< '$($MemLim) [mb]' ."

                }


                Write-Verbose "$($(Get-DateTimeFQDN)) $($USING:functionName) '$($InFile)' start . . ."

                If( Test-Path $outFile -PathType Leaf )
                {

                    write-warning "'$($outfile)' will be overwritten ."

                }

				Write-Debug "$(Get-DateTimeFQDN) $($USING:functionName) $($ImageMagickPath) $($MagickArgs)"

				& $USING:ImageMagickPath @MagickArgs # *> $null

                if( !($LASTEXITCODE -eq 0) )
                {

                    Write-Error "$($(Get-DateTimeFQDN)) $($USING:functionName) '$($InFile)' ImageMagick exit code == '$($LASTEXITCODE)' ."

                }
                else
                {

                    Write-Verbose "$($(Get-DateTimeFQDN)) $($USING:functionName) '$($InFile)' done ."

                }

        } -ThrottleLimit $ThrottleLimit # foreach -parallel


    } # Process
    End
    {

        $mbPerSec = [math]::round(( $sum_MB /  $($sw.Elapsed.TotalMilliseconds/1000) ),1)

        if( !($null -eq $log) )
        {

            $log | Foreach-Object -Process{

				"$($_)"

			}

			$log.clear()

        }

		if( !($null -eq $files) )
        {

			$files.clear()

		}

		# WORKAROUND: Remove known ImageMagick XML parser warnings
		# associated with some legacy file metadata.
		# These warnings are considered non-fatal for this solution.

		For($i = $Error.Count - 1; $i -ge 0; $i--) {

			if( $Error[$i].ToString() -eq 'magick.exe: ParseError missing > @ warning/xml-tree.c/NewXMLTree/1808.' )
			{

				$Error.RemoveAt($i)
				write-debug "magick.exe: ParseError missing > @ warning/xml-tree.c/NewXMLTree/1808. Removed from PS error-variable ."

			}

		}

        Write-Verbose "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) '$($InputDir)' --> '$($OutDir)' ."
        Write-Verbose "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) '$($files.count)' files '$($sum_MB)' [mb] processed in $($sw.Elapsed.TotalMilliseconds) [ms] @ '$($mbPerSec)' [mb/sec] with '$($error.count)' error/s ."

        $sw.stop()
        Stop-Transcript

    } # End
} #EOF
