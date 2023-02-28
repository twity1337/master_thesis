Push-Location $PSScriptRoot

Remove-Item *.pdf
& "$Env:ProgramFiles\WindowsApps\draw.io.draw.ioDiagrams_20.8.10.0_x64__1zh33159kp73c\app\draw.io.exe" . --crop -x -f pdf .

Pop-Location