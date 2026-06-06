[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$InputDirectory,

    [Parameter(Mandatory = $true)]
    [string]$OutputDirectory
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-ExtensionName {
    param(
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$File
    )

    if ([string]::IsNullOrWhiteSpace($File.Extension)) {
        return 'no_extension'
    }

    return $File.Extension.ToLowerInvariant()
}

if (-not (Test-Path -LiteralPath $InputDirectory -PathType Container)) {
    throw "InputDirectory does not exist or is not a directory: $InputDirectory"
}

if (-not (Test-Path -LiteralPath $OutputDirectory -PathType Container)) {
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
}

$resolvedInputDirectory = (Resolve-Path -LiteralPath $InputDirectory).Path
$resolvedOutputDirectory = (Resolve-Path -LiteralPath $OutputDirectory).Path
$reportPath = Join-Path -Path $resolvedOutputDirectory -ChildPath 'report.txt'

$files = Get-ChildItem -LiteralPath $resolvedInputDirectory -File -Recurse -Force -ErrorAction SilentlyContinue

$reportLines = New-Object System.Collections.Generic.List[string]
$reportLines.Add('Top 10 largest file types by total size')
$reportLines.Add("InputDirectory: $resolvedInputDirectory")
$reportLines.Add('')

if (-not $files) {
    $reportLines.Add(('Extension'.PadRight(20) + 'Summary Value in Mb'))
    $reportLines.Add(('no_extension'.PadRight(20) + '0'))
    Set-Content -LiteralPath $reportPath -Value $reportLines -Encoding UTF8
    Write-Host "Report created: $reportPath"
    exit 0
}

$topExtensions = $files |
    Group-Object -Property { Get-ExtensionName -File $_ } |
    ForEach-Object {
        $totalBytes = ($_.Group | Measure-Object -Property Length -Sum).Sum
        if ($null -eq $totalBytes) {
            $totalBytes = 0
        }

        [PSCustomObject]@{
            Extension = $_.Name
            TotalBytes = [int64]$totalBytes
            TotalSizeMb = [math]::Round($totalBytes / 1MB, 2)
        }
    } |
    Sort-Object -Property TotalBytes -Descending |
    Select-Object -First 10

$reportLines.Add(('Extension'.PadRight(20) + 'Summary Value in Mb'))
foreach ($item in $topExtensions) {
    $reportLines.Add($item.Extension.PadRight(20) + $item.TotalSizeMb)
}

Set-Content -LiteralPath $reportPath -Value $reportLines -Encoding UTF8
Write-Host "Report created: $reportPath"
