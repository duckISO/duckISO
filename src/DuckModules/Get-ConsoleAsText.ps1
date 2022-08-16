#################################################################################################################
# Get-ConsoleAsText.ps1
#
# Credit: https://web.archive.org/web/20090801061902/http://blogs.msdn.com/powershell/archive/2009/01/10/capture-console-screen.aspx
#
# The script captures console screen buffer up to the current cursor position and returns it in plain text format.
#
# Returns: ASCII-encoded string.
#
# Example:
#
# $textFileName = "$env:temp\ConsoleBuffer.txt"
# .\Get-ConsoleAsText | out-file $textFileName -encoding ascii
# $null = [System.Diagnostics.Process]::Start("$textFileName")
#

# Check the host name and exit if the host is not the Windows PowerShell console host.
if ($host.Name -ne 'ConsoleHost')
{
  write-host -ForegroundColor Red "This script runs only in the console host. You cannot run this script in $($host.Name)."
  exit -1
}

# Initialize string builder.
$textBuilder = new-object system.text.stringbuilder

# Grab the console screen buffer contents using the Host console API.
$bufferWidth = $host.ui.rawui.BufferSize.Width
$bufferHeight = $host.ui.rawui.CursorPosition.Y
$rec = new-object System.Management.Automation.Host.Rectangle 0,0,($bufferWidth - 1),$bufferHeight
$buffer = $host.ui.rawui.GetBufferContents($rec)

# Iterate through the lines in the console buffer.
for($i = 0; $i -lt $bufferHeight; $i++)
{
  for($j = 0; $j -lt $bufferWidth; $j++)
  {
    $cell = $buffer[$i,$j]
    $null = $textBuilder.Append($cell.Character)
  }
  $null = $textBuilder.Append("`r`n")
}

return $textBuilder.ToString()