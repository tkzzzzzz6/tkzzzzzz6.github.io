[CmdletBinding()]
param(
    [ValidateSet('colab', 'colab-g4', 'colab-h100', 'colab-a100', 'colab-l4', 'colab-t4')]
    [string]$Session = 'colab',
    [switch]$NoOpen,
    [switch]$NoMount
)

$ErrorActionPreference = 'Stop'
$colabExecutable = (Get-Command colab -ErrorAction Stop).Source
$gpuBySession = @{
    'colab-g4' = 'G4'; 'colab-h100' = 'H100'; 'colab-a100' = 'A100'
    'colab-l4' = 'L4'; 'colab-t4' = 'T4'
}

function Invoke-ColabChecked {
    param([string[]]$Arguments)
    & $colabExecutable @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Colab command failed (exit $LASTEXITCODE): colab $($Arguments -join ' ')"
    }
}

Write-Host "[1/4] Finding session: $Session"
$sessionLines = @(Invoke-ColabChecked -Arguments @('sessions'))
$sessionListing = ($sessionLines -join "`n") -replace '\x1B\[[0-?]*[ -/]*[@-~]', ''
$sessionPattern = '(?m)^\[' + [regex]::Escape($Session) + '\]\s'
if ($sessionListing -notmatch $sessionPattern) {
    if (-not $gpuBySession.ContainsKey($Session)) {
        throw "The session '$Session' is not running. Create it first, or choose a GPU profile."
    }
    Write-Host "Creating $Session with $($gpuBySession[$Session]). This starts a billed runtime."
    Invoke-ColabChecked -Arguments @('new', '-s', $Session, '--gpu', $gpuBySession[$Session])
}

Write-Host '[2/4] Checking Google Drive'
$driveCheck = @(Invoke-ColabChecked -Arguments @(
    'exec', '-s', $Session, '--timeout', '60', '-f', (Join-Path $PSScriptRoot 'Check-Drive.py')
))
if (-not ($driveCheck | Where-Object { $_.ToString().Trim() -eq 'COLAB_DRIVE_READY=1' })) {
    if ($NoMount) {
        throw 'Drive is not mounted. Run this launcher interactively without -NoMount to authorize it.'
    }
    Write-Host 'Mounting Drive. If prompted, authorize the SAME Google account used by your other sessions.'
    Invoke-ColabChecked -Arguments @('drivemount', '-s', $Session, '/content/drive')
}

Write-Host '[3/4] Preparing /content/workspace'
$workspaceCheck = @(Invoke-ColabChecked -Arguments @(
    'exec', '-s', $Session, '--timeout', '180', '-f', (Join-Path $PSScriptRoot 'Initialize-Workspace.py')
))
$workspaceCheck | ForEach-Object { Write-Host $_ }
if (-not ($workspaceCheck | Where-Object { $_.ToString().Trim() -eq 'COLAB_WORKSPACE_READY=1' })) {
    throw 'Workspace initialization did not report success. VS Code was not opened.'
}
$workspaceIdLine = @($workspaceCheck | Where-Object { $_.ToString().Trim() -match '^COLAB_WORKSPACE_ID=[0-9a-f-]{36}$' })
if ($workspaceIdLine.Count -ne 1) { throw 'A valid workspace identity was not returned.' }
$workspaceId = $workspaceIdLine[0].ToString().Trim().Substring('COLAB_WORKSPACE_ID='.Length)
$localWorkspaceIdPath = Join-Path $PSScriptRoot 'workspace-id.txt'
if (Test-Path -LiteralPath $localWorkspaceIdPath) {
    $expectedWorkspaceId = [IO.File]::ReadAllText($localWorkspaceIdPath).Trim()
    if ($workspaceId -ne $expectedWorkspaceId) {
        throw 'This runtime mounted a different Drive workspace. Use the same Google account; VS Code was not opened.'
    }
} else {
    [IO.File]::WriteAllText($localWorkspaceIdPath,$workspaceId + "`n",[Text.UTF8Encoding]::new($false))
}

if ($NoOpen) {
    Write-Host '[4/4] Ready. VS Code launch skipped by -NoOpen.'
} else {
    Write-Host '[4/4] Opening the shared workspace in VS Code'
    $codeExecutable = (Get-Command code -ErrorAction Stop).Source
    & $codeExecutable --new-window --folder-uri "vscode-remote://ssh-remote+$Session/content/workspace"
    if ($LASTEXITCODE -ne 0) { throw 'VS Code could not be started.' }
}
