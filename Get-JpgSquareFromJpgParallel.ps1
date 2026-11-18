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

   Example output (verbose pipeline)

   Get-JpgSquareFromJpgParallel -InputDir C:\share -Verbose
Transcript started, output file is C:\\Get-JpgSquareFromJpgParallel\Get-JpgSquareFromJpgParallel 2026-11-18_121113.txt
2026-11-18T12:11:13.6113742-08:00 BLACK Get-JpgSquareFromJpgParallel Version: ImageMagick 7.1.2-35 Q16 x64 5d1bcc5:20261031 https://imagemagick.org Copyright: (C) 1999 ImageMagick Studio LLC License: https://imagemagick.org/license/ Features: Channel-masks(64-bit) Cipher DPC OpenCL OpenMP(2.0)  Delegates (built-in): bzlib cairo freetype gslib heic jng jp2 jpeg jxl lcms lqr lzma openexr pangocairo png ps raqm raw rsvg tiff webp xml zip zlib zstd Compiler: Visual Studio 2026 (195136260) .
VERBOSE: Perform operation 'Enumerate CimInstances' with following parameters, ''className' = Win32_LogicalDisk,'namespaceName' = root\cimv2'.
VERBOSE: Operation 'Enumerate CimInstances' complete.
VERBOSE: Perform operation 'Enumerate CimInstances' with following parameters, ''className' = win32_operatingSystem,'namespaceName' = root\cimv2'.
VERBOSE: Operation 'Enumerate CimInstances' complete.
VERBOSE: 2026-11-18T12:11:13.6954147-08:00 BLACK Get-JpgSquareFromJpgParallel Sharpening strength 'Strong' --> Unsharp Mask '0x1.5+1.5+0.08' .
VERBOSE: Sharpen with unsharp mask in LAB color space: 'True' .
VERBOSE: 2026-11-18T12:11:13.6988269-08:00 BLACK Get-JpgSquareFromJpgParallel 'IMG_6211.jpg' '6.36170291900635' [mb] .
VERBOSE: 2026-11-18T12:11:13.6994929-08:00 BLACK Get-JpgSquareFromJpgParallel 'IMG_6213.jpg' '6.33262825012207' [mb] .
VERBOSE: 2026-11-18T12:11:13.7001009-08:00 BLACK Get-JpgSquareFromJpgParallel 'IMG_6221.jpg' '6.29126453399658' [mb] .
VERBOSE: 2026-11-18T12:11:13.7007032-08:00 BLACK Get-JpgSquareFromJpgParallel 'IMG_6246.jpg' '5.57845687866211' [mb] .
VERBOSE: 2026-11-18T12:11:13.7013009-08:00 BLACK Get-JpgSquareFromJpgParallel 'IMG_6260.jpg' '6.15327167510986' [mb] .
VERBOSE: 2026-11-18T12:11:13.7019870-08:00 BLACK Get-JpgSquareFromJpgParallel 'IMG_6268.jpg' '6.34022331237793' [mb] .
VERBOSE: 2026-11-18T12:11:13.7071304-08:00 BLACK Get-JpgSquareFromJpgParallel '1x2400.jpg' '0.00110054016113281' [mb] .
VERBOSE: 2026-11-18T12:11:13.7079392-08:00 BLACK Get-JpgSquareFromJpgParallel '1x2400 - Copy.jpg' '0.00214481353759766' [mb] .
VERBOSE: 2026-11-18T12:11:13.7085629-08:00 BLACK Get-JpgSquareFromJpgParallel 'Untitled.jpg' '0.00160408020019531' [mb] .
VERBOSE: 2026-11-18T12:11:13.7092026-08:00 BLACK Get-JpgSquareFromJpgParallel 'Untitled - Copy.jpg' '0.00264835357666016' [mb] .
VERBOSE: 2026-11-18T12:11:13.7098444-08:00 BLACK Get-JpgSquareFromJpgParallel '10' files in 'C:\share' == '37.1' [mb] .
VERBOSE: Perform operation 'Enumerate CimInstances' with following parameters, ''className' = win32_processor,'namespaceName' = root\cimv2'.
VERBOSE: Operation 'Enumerate CimInstances' complete.
VERBOSE: 2026-11-18T12:11:14.7809339-08:00 BLACK Test-CpuLoadIsHigh Current Cpu Load '0' %
VERBOSE: Perform operation 'Enumerate CimInstances' with following parameters, ''className' = win32_processor,'namespaceName' = root\cimv2'.
VERBOSE: Operation 'Enumerate CimInstances' complete.
VERBOSE: 2026-11-18T12:11:16.0228790-08:00 BLACK Test-CpuLoadIsHigh Current Cpu Load '1' %
VERBOSE: Perform operation 'Enumerate CimInstances' with following parameters, ''className' = win32_processor,'namespaceName' = root\cimv2'.
VERBOSE: Operation 'Enumerate CimInstances' complete.
VERBOSE: 2026-11-18T12:11:17.3391108-08:00 BLACK Test-CpuLoadIsHigh Current Cpu Load '1' %
VERBOSE: 2026-11-18T12:11:17.6390047-08:00 BLACK Test-CpuLoadIsHigh Cpu Load: 0.666666666666667
VERBOSE: 2026-11-18T12:11:17.6401448-08:00 BLACK Get-JpgSquareFromJpgParallel Low cpu load .
VERBOSE: 2026-11-18T12:11:17.6446532-08:00 BLACK Get-JpgSquareFromJpgParallel Parallel image processing start . . .
WARNING: 2026-11-18T12:11:17.7968415-08:00 System.Net.IPHostEntry Get-JpgSquareFromJpgParallel File already exist and will be overwritten 'C:\\Get-JpgSquareFromJpgParallel\IMG_6211__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' .
WARNING: 2026-11-18T12:11:17.8215993-08:00 System.Net.IPHostEntry Get-JpgSquareFromJpgParallel File already exist and will be overwritten 'C:\\Get-JpgSquareFromJpgParallel\IMG_6213__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' .
WARNING: 2026-11-18T12:11:17.8365985-08:00 System.Net.IPHostEntry Get-JpgSquareFromJpgParallel File already exist and will be overwritten 'C:\\Get-JpgSquareFromJpgParallel\IMG_6221__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' .
WARNING: 2026-11-18T12:11:17.8489010-08:00 System.Net.IPHostEntry Get-JpgSquareFromJpgParallel File already exist and will be overwritten 'C:\\Get-JpgSquareFromJpgParallel\IMG_6246__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' .
WARNING: 2026-11-18T12:11:17.8560106-08:00 System.Net.IPHostEntry Get-JpgSquareFromJpgParallel File already exist and will be overwritten 'C:\\Get-JpgSquareFromJpgParallel\IMG_6260__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' .
WARNING: 2026-11-18T12:11:21.7629404-08:00 System.Net.IPHostEntry Get-JpgSquareFromJpgParallel File already exist and will be overwritten 'C:\\Get-JpgSquareFromJpgParallel\1x2400__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' .
WARNING: 2026-11-18T12:11:21.7821818-08:00 System.Net.IPHostEntry Get-JpgSquareFromJpgParallel File already exist and will be overwritten 'C:\\Get-JpgSquareFromJpgParallel\IMG_6268__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' .
WARNING: 2026-11-18T12:11:21.8706989-08:00 System.Net.IPHostEntry Get-JpgSquareFromJpgParallel File already exist and will be overwritten 'C:\\Get-JpgSquareFromJpgParallel\1x2400 - Copy__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' .
WARNING: 2026-11-18T12:11:21.9666168-08:00 System.Net.IPHostEntry Get-JpgSquareFromJpgParallel File already exist and will be overwritten 'C:\\Get-JpgSquareFromJpgParallel\Untitled__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' .
WARNING: 2026-11-18T12:11:22.0730283-08:00 System.Net.IPHostEntry Get-JpgSquareFromJpgParallel File already exist and will be overwritten 'C:\\Get-JpgSquareFromJpgParallel\Untitled - Copy__CIE-1976-LAB-ColorSpace_SharpeningStrong_Q100.JPG' .
VERBOSE: 2026-11-18T12:11:23.4711868-08:00 BLACK Get-JpgSquareFromJpgParallel 'C:\share' --> 'C:\\Get-JpgSquareFromJpgParallel' .
VERBOSE: 2026-11-18T12:11:23.4737057-08:00 BLACK Get-JpgSquareFromJpgParallel '10' files '37.1' [mb] processed in 5829.4869 [ms] @ '6.4' [mb/sec] with '0' error/s .
Transcript stopped, output file is C:\Get-JpgSquareFromJpgParallel\Get-JpgSquareFromJpgParallel 2026-11-18_121113.txt

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

        # Leave 2 cores to operating system as default
        [Parameter(Mandatory=$false)]
        [uint16]$ThrottleLimit = [Math]::Max(1, [Environment]::ProcessorCount - 2) ,

        # Limit amount of physical memory available to ImageMagick
        # This can vary, depending on several factors, you can fine tune this, default change factor = 10
        # Ex. if input file is 20mb and CF = 10 --> ImageMagick gets max file size x change factor = 20 x 10 = 200mb to use in parallel job
        [Parameter(Mandatory=$false)]
        [uint16]$CF = 10

    )

    Begin
    {

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

        Start-Transcript -Path "$($OutDir)\$($myInvocation.myCommand.name) $($(get-date).tostring("yyyy-MM-dd_HHmmss")).txt" -Force -Confirm:$false

        # Throw exception if magick.exe not found
        If( !(Test-Path $ImageMagickPath -PathType Leaf) )
        {

            throw "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) Required executable 'magick.exe' not found in '$($ImageMagickPath)' ."

        }
        else
        {

            $imVersion = & magick -version
            "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) $imVersion ."

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

        # Create output dir, if not exist
        If( !(Test-Path $OutDir -PathType Container) )
        { New-Item $OutDir -ItemType Directory -Force -Confirm:$false | Out-Null }

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

        Write-Verbose "Sharpen with unsharp mask in LAB color space: '$($SharpenInLABColorSpace)' ."


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

        $files | Sort-Object creationTime | ForEach-Object -Process{

            $sum_MB = $sum_MB + $_.length/1mb
            Write-Verbose "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) '$($_.name)' '$($_.length/1mb)' [mb] ."

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

                If( $USING:SharpenInLABColorSpace )
                {
                    [string]$OutFile = Join-Path $USING:OutDir ( ([System.IO.Path]::GetFileNameWithoutExtension($InFile)) + "_$($myInvocation.myCommand.name)_CIE-1976-LAB-ColorSpace_Sharpening$($USING:SharpeningStrength)_Q$($USING:Quality).JPG" )
                    $MagickArgs = @(

                           "$InFile",
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
                If( (Get-CimInstance win32_operatingsystem).freephysicalmemory/1024 -le $MemLim )
                {

                    Write-Warning "$(Get-DateTimeFQDN) $($USING:functionName) Free physical memory =< '$($MemLim) [mb]' ."

                }


                Write-Verbose "$(Get-DateTimeFQDN) $($USING:functionName) '$($InFile)' start . . ."
                Write-Verbose "ImageMagick arguments: '$($MagickArgs)'"

                If( Test-Path $outFile -PathType Leaf )
                {

                    write-warning "$(Get-DateTimeFQDN) $($USING:functionName) File already exist and will be overwritten '$($outfile)' ."

                }

                & magick @MagickArgs *> $null

                # magick.exe: ParseError missing > @ warning/xml-tree.c/NewXMLTree/1808.
                # == ImageMagick bug with parsing metadata
                # Ignore 1808 warning

                if( !($LASTEXITCODE -eq 0) -AND !($LASTEXITCODE -match "1808.") )
                {

                    Write-Error "$(Get-DateTimeFQDN) $($USING:functionName) '$($InFile)' ImageMagick exit code == '$($LASTEXITCODE)' ."

                }
                else
                {

                    Write-Verbose "$(Get-DateTimeFQDN) $($USING:functionName) '$($InFile)' done ."

                }

        } -ThrottleLimit $ThrottleLimit #foreach -parallel


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

        Write-Verbose "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) '$($InputDir)' --> '$($OutDir)' ."
        Write-Verbose "$(Get-DateTimeFQDN) $($myInvocation.myCommand.name) '$($files.count)' files '$($sum_MB)' [mb] processed in $($sw.Elapsed.TotalMilliseconds) [ms] @ '$($mbPerSec)' [mb/sec] with '$($error.count)' error/s ."

        $sw.stop()
        Stop-Transcript

    } # End
} # Function
