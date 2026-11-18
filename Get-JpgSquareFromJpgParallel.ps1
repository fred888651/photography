<#
.Synopsis

   PowerShell function for parallel batch processing of JPG images, including optional luminance sharpening in CIE LAB color space and conversion to 2400×2400 square format.
   
   Designed for batch processing of large image collections.

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

   Memory limits are calculated individually for each file based on input size.
   Checks free physical memory, checks free disk space, checks CPU load, 
   Writes warning if not satisfied, keeps running.
   
   Checks dependencies ImageMagick + powershell version + windows operating system
   Throws error and stop if not satisfied. 

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

   Get-JpgSquareFromJpgParallel -InputDir "C:\some dir with JPG files" 

.EXAMPLE

   Get-JpgSquareFromJpgParallel -InputDir "C:\some dir with JPG files" SharpenInLABColorSpace:$false -ThrottleLimit 14 -SharpeningStrength VeryStrong -Quality 90 -Verbose -Debug

.INPUTS

   Folder with JPG images

.OUTPUTS

   JPG files + log file

   Example usage/output:

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
