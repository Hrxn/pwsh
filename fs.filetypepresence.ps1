[CmdletBinding(PositionalBinding = $false)]
param
(
	[Parameter()][switch] $Recurse,
	[Parameter(Position = 0)][string] $Path = $PWD
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

[Console]::WriteLine('────────────────────────────────────────────────────────────────')
[Console]::WriteLine('── The following File Types / File Extensions have been found ──')
[Console]::WriteLine('────────────────────────────────────────────────────────────────')
foreach ($Type in $Exts) {
	[Console]::WriteLine('    ' + $Type)
}
[Console]::WriteLine('────────────────────────────────────────────────────────────────')
[Console]::WriteLine("Total Files: $Size")
[Console]::WriteLine('───────────────────────────────')

