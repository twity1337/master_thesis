if ([System.Environment]::OSVersion.Version -eq [System.Version]"10.0.19045.0") { # check whether computer 1 or computer 2 is in use.. it's dirty, i know...
	$exePath = "$Env:ProgramFiles\WindowsApps\draw.io.draw.ioDiagrams_20.8.10.0_x64__1zh33159kp73c\app\draw.io.exe"
} else {
	$exePath = "$Env:ProgramFiles\draw.io\draw.io.exe"
}

Push-Location $PSScriptRoot

& $exePath . --crop -x -a -f pdf .

Pop-Location