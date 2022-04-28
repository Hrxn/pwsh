[CmdletBinding(PositionalBinding = $false)]
param
(
	[Parameter(Position = 0)][string] $Path = $PWD,
	[Parameter()][switch] $Recurse
)

if (($Path -eq '--help' -or $Path -eq '?') -or [String]::IsNullOrEmpty($Path)) {
	Write-Host "[fs.filetypepresence] Usage: fs.filetypepresence.ps1 [-Path] <PATH> [-Recurse]"
	exit 0
}

if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
	Write-Host "[fs.filetypepresence] The given path parameter ""$Path"" does not exist or is not a valid path!" -ForegroundColor DarkRed
	exit 1
}

$Path = Convert-Path -LiteralPath $Path
if ($Recurse) {
	$Full = Get-ChildItem -Path $Path -Recurse -Force -File
} 
else {
	$Full = Get-ChildItem -Path $Path -Force -File
}
$Size = ($Full | Measure-Object).Count
$Exts = [Collections.Generic.List[String]]::new()

foreach ($Item in $Full) {
	if (-not ($Exts.Contains($Item.Extension))) {
		$Exts.Add($Item.Extension)
	}
}

if ($Exts.Contains([String]::Empty)) {
	$Exts[$Exts.IndexOf([String]::Empty)] = '(No Extension)'
}

Write-Host '── The following File Types / File Extensions have been found ──'
Write-Host ''
foreach ($Type in $Exts) {
	Write-Host $Type
}
Write-Host ''
Write-Host '────────────────────────────────────────────────────────────────'
Write-Host "Total Files: $Size"
Write-Host '───────────────────────────────'

