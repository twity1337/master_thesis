Push-Location $PSScriptRoot

Remove-Item *.pdf
& "$Env:ProgramFiles\draw.io\draw.io.exe" . --crop -x -f pdf .

Pop-Location