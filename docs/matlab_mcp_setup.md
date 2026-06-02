# MATLAB MCP Core Server Setup

Date: 2026-06-02

Project root: `D:\OneDrive\Papers\【项目模板_lite】`

## Official Source

- Official repository: <https://github.com/matlab/matlab-mcp-core-server>
- Release used: `v0.10.0`
- Release page: <https://github.com/matlab/matlab-mcp-core-server/releases/tag/v0.10.0>
- Windows asset: `matlab-mcp-core-server-win64.exe`
- Download URL: <https://github.com/matlab/matlab-mcp-core-server/releases/download/v0.10.0/matlab-mcp-core-server-win64.exe>
- GitHub release asset SHA-256 digest: `cc64a8303d80d88be33fc061659a951af3d01d454217cb4d98bea516a4254918`

Only the official MathWorks GitHub release asset was downloaded and used.

## Local Installation

Installed binary:

```text
cache/matlab-mcp-core-server/v0.10.0/matlab-mcp-core-server-win64.exe
```

The binary is inside `cache/`, which is already ignored by this template. MCP logs are configured under:

```text
cache/matlab-mcp-core-server/logs
```

No global MATLAB path was changed. I did not run `addpath`, `savepath`, `pathtool`, edit MATLAB startup files, or run `--setup-matlab`.

MATLAB found on the existing system PATH:

```text
C:\Program Files\MATLAB\R2025b\bin\matlab.exe
```

The local MCP server config pins the MATLAB root to:

```text
C:\Program Files\MATLAB\R2025b
```

## Project MCP Configuration

Workspace config added:

```text
.vscode/mcp.json
```

Config content:

```json
{
  "servers": {
    "matlab": {
      "type": "stdio",
      "command": "${workspaceFolder}\\cache\\matlab-mcp-core-server\\v0.10.0\\matlab-mcp-core-server-win64.exe",
      "args": [
        "--matlab-root=C:\\Program Files\\MATLAB\\R2025b",
        "--initial-working-folder=${workspaceFolder}",
        "--log-folder=${workspaceFolder}\\cache\\matlab-mcp-core-server\\logs",
        "--matlab-display-mode=nodesktop",
        "--disable-telemetry=true"
      ]
    }
  }
}
```

## Verification Results

Binary version check:

```text
github.com/matlab/matlab-mcp-core-server v0.10.0
```

The downloaded file hash matched the official GitHub release asset digest:

```text
SHA256 CC64A8303D80D88BE33FC061659A951AF3D01D454217CB4D98BEA516A4254918
```

MCP protocol initialization succeeded and reported:

```text
serverInfo.name: matlab-mcp-core-server
serverInfo.version: github.com/matlab/matlab-mcp-core-server v0.10.0
```

Tool listing succeeded. Available tools included:

```text
check_matlab_code
detect_matlab_toolboxes
evaluate_matlab_code
run_matlab_file
run_matlab_test_file
```

`detect_matlab_toolboxes` succeeded. It returned 122 non-empty lines of MATLAB and toolbox information. The first lines were:

```text
MATLAB version: 25.2.0.3177638 (R2025b) Update 5
OS: Microsoft Windows 11 Professional Version 10.0 (Build 26200)
MATLAB 25.2 (R2025b)
Simulink 25.2 (R2025b)
5G Toolbox 25.2 (R2025b)
```

The actual MCP output was localized on this machine and included installed products such as `Optimization Toolbox`, `Parallel Computing Toolbox`, `Statistics and Machine Learning Toolbox`, `MATPOWER 8.1`, `MIPS 1.5.2`, `MOST 1.3.1`, and `MP-Opt-Model 5.0`.

`evaluate_matlab_code` ran `disp(version); disp(pwd);` inside MATLAB and returned:

```text
25.2.0.3177638 (R2025b) Update 5
D:\OneDrive\Papers\【项目模板_lite】
```

This verifies that the MCP server can run `version` inside MATLAB and can use the project root as the MATLAB working folder.

## Notes

- A PowerShell-only manual MCP client could list tools and detect toolboxes, but it encoded the non-ASCII project path incorrectly when calling `evaluate_matlab_code` with `project_path`. The final verification used Python 3.12 as a temporary UTF-8 JSON-RPC client and succeeded with the original project path.
- The MCP server's JSON-RPC `shutdown` method returned unsupported in this release during manual testing, so the verification client sent the `exit` notification and then terminated the temporary server process.

## Command Log

Commands were executed from `D:\OneDrive\Papers\【项目模板_lite】` in PowerShell unless otherwise noted.

```powershell
Get-Location
```

```powershell
if (Get-Command rg -ErrorAction SilentlyContinue) { rg --files } else { Get-ChildItem -Recurse -File | ForEach-Object { $_.FullName } }
```

```powershell
Get-Content -Path C:\Users\wuhan\.codex\memories\MEMORY.md | Select-String -Pattern 'project-template-lite|MATLAB MCP|MCP|项目模板_lite|author-profile|cursor' -Context 2,2
```

```powershell
Get-ChildItem -Force
```

```powershell
if (Test-Path .gitignore) { Get-Content -Path .gitignore }
```

```powershell
if (Test-Path .vscode) { Get-ChildItem -Force .vscode; if (Test-Path .vscode\mcp.json) { Get-Content .vscode\mcp.json } }
```

```powershell
if (Test-Path .cursor) { Get-ChildItem -Recurse -Force .cursor | Select-Object FullName }
```

```powershell
Get-Content -Path README.md -TotalCount 220
```

```powershell
git status --short
```

```powershell
if (Get-Command rg -ErrorAction SilentlyContinue) { rg -n "mcp|MCP|vscode|cursor" -S . } else { Get-ChildItem -Recurse -File | Select-String -Pattern 'mcp|MCP|vscode|cursor' }
```

```powershell
Get-Command matlab -ErrorAction SilentlyContinue | Format-List *
```

```powershell
$release = Invoke-RestMethod -Uri 'https://api.github.com/repos/matlab/matlab-mcp-core-server/releases/latest'; $release | Select-Object tag_name,name,published_at,html_url; $release.assets | Select-Object name,browser_download_url,size,digest
```

```powershell
New-Item -ItemType Directory -Force -Path .\cache\matlab-mcp-core-server\v0.10.0 | Out-Null
```

```powershell
New-Item -ItemType Directory -Force -Path .\docs | Out-Null
```

```powershell
$assetUrl = 'https://github.com/matlab/matlab-mcp-core-server/releases/download/v0.10.0/matlab-mcp-core-server-win64.exe'; Invoke-WebRequest -Uri $assetUrl -OutFile '.\cache\matlab-mcp-core-server\v0.10.0\matlab-mcp-core-server-win64.exe'
```

```powershell
Get-Item '.\cache\matlab-mcp-core-server\v0.10.0\matlab-mcp-core-server-win64.exe' | Select-Object FullName,Length,LastWriteTime
```

```powershell
Get-FileHash '.\cache\matlab-mcp-core-server\v0.10.0\matlab-mcp-core-server-win64.exe' -Algorithm SHA256
```

```powershell
& '.\cache\matlab-mcp-core-server\v0.10.0\matlab-mcp-core-server-win64.exe' --version
```

```powershell
$release = Invoke-RestMethod -Uri 'https://api.github.com/repos/matlab/matlab-mcp-core-server/releases/latest'; $release.assets | Where-Object { $_.name -eq 'matlab-mcp-core-server-win64.exe' } | Select-Object name,browser_download_url,size,digest | Format-List
```

```powershell
New-Item -ItemType Directory -Force -Path .\.vscode | Out-Null
```

```powershell
& '.\cache\matlab-mcp-core-server\v0.10.0\matlab-mcp-core-server-win64.exe' --help
```

```powershell
Get-Content .\.vscode\mcp.json | ConvertFrom-Json | Out-Null; Write-Output 'mcp.json JSON parse OK'
```

```powershell
$exe = (Resolve-Path '.\cache\matlab-mcp-core-server\v0.10.0\matlab-mcp-core-server-win64.exe').Path; $project = (Get-Location).Path; $matlabRoot = 'C:\Program Files\MATLAB\R2025b'; $logFolder = Join-Path $project 'cache\matlab-mcp-core-server\logs'; New-Item -ItemType Directory -Force -Path $logFolder | Out-Null; $psi = [System.Diagnostics.ProcessStartInfo]::new(); $psi.FileName = $exe; $psi.ArgumentList.Add('--matlab-root=' + $matlabRoot); $psi.ArgumentList.Add('--initial-working-folder=' + $project); $psi.ArgumentList.Add('--log-folder=' + $logFolder); $psi.ArgumentList.Add('--disable-telemetry=true'); $psi.RedirectStandardInput = $true; $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true; $psi.UseShellExecute = $false; $p = [System.Diagnostics.Process]::Start($psi); function Send-Json($obj) { $line = $obj | ConvertTo-Json -Depth 20 -Compress; $p.StandardInput.WriteLine($line); $p.StandardInput.Flush(); Write-Output ("--> " + $line) }; function Read-UntilId([int]$targetId, [int]$timeoutSeconds) { $deadline = [DateTime]::UtcNow.AddSeconds($timeoutSeconds); while ([DateTime]::UtcNow -lt $deadline) { $line = $p.StandardOutput.ReadLine(); if ($null -eq $line) { throw "Server stdout closed while waiting for id $targetId" }; Write-Output ("<-- " + $line); $msg = $line | ConvertFrom-Json; if ($msg.id -eq $targetId) { return $msg } }; throw "Timed out waiting for MCP response id $targetId" }; Send-Json @{ jsonrpc='2.0'; id=1; method='initialize'; params=@{ protocolVersion='2025-03-26'; capabilities=@{}; clientInfo=@{ name='codex-setup-check'; version='1.0.0' } } }; $init = Read-UntilId 1 30; Send-Json @{ jsonrpc='2.0'; method='notifications/initialized'; params=@{} }; Send-Json @{ jsonrpc='2.0'; id=2; method='tools/list'; params=@{} }; $tools = Read-UntilId 2 30; $tools.result.tools | Select-Object name,description | Format-Table -AutoSize; try { Send-Json @{ jsonrpc='2.0'; id=99; method='shutdown'; params=@{} }; $null = Read-UntilId 99 10; Send-Json @{ jsonrpc='2.0'; method='exit'; params=@{} } } catch { Write-Output ("Shutdown warning: " + $_.Exception.Message) }; if (-not $p.WaitForExit(5000)) { $p.Kill() }; $stderr = $p.StandardError.ReadToEnd(); if ($stderr) { Write-Output 'STDERR:'; Write-Output $stderr }
```

```powershell
$exe = (Resolve-Path '.\cache\matlab-mcp-core-server\v0.10.0\matlab-mcp-core-server-win64.exe').Path; $project = (Get-Location).Path; $matlabRoot = 'C:\Program Files\MATLAB\R2025b'; $logFolder = Join-Path $project 'cache\matlab-mcp-core-server\logs'; New-Item -ItemType Directory -Force -Path $logFolder | Out-Null; $psi = [System.Diagnostics.ProcessStartInfo]::new(); $psi.FileName = $exe; $psi.Arguments = '--matlab-root="' + $matlabRoot + '" --initial-working-folder="' + $project + '" --log-folder="' + $logFolder + '" --disable-telemetry=true'; $psi.RedirectStandardInput = $true; $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true; $psi.UseShellExecute = $false; $p = [System.Diagnostics.Process]::Start($psi); function Send-Json($obj) { $line = $obj | ConvertTo-Json -Depth 30 -Compress; $p.StandardInput.WriteLine($line); $p.StandardInput.Flush(); Write-Host ("--> " + $line) }; function Read-UntilId([int]$targetId, [int]$timeoutSeconds) { $deadline = [DateTime]::UtcNow.AddSeconds($timeoutSeconds); while ([DateTime]::UtcNow -lt $deadline) { $line = $p.StandardOutput.ReadLine(); if ($null -eq $line) { throw "Server stdout closed while waiting for id $targetId" }; Write-Host ("<-- " + $line); $msg = $line | ConvertFrom-Json; if ($msg.id -eq $targetId) { return $msg } }; throw "Timed out waiting for MCP response id $targetId" }; try { Send-Json @{ jsonrpc='2.0'; id=1; method='initialize'; params=@{ protocolVersion='2025-03-26'; capabilities=@{}; clientInfo=@{ name='codex-setup-check'; version='1.0.0' } } }; $init = Read-UntilId 1 30; Send-Json @{ jsonrpc='2.0'; method='notifications/initialized'; params=@{} }; Send-Json @{ jsonrpc='2.0'; id=2; method='tools/list'; params=@{} }; $tools = Read-UntilId 2 30; $tools.result.tools | Select-Object name,inputSchema | ConvertTo-Json -Depth 20 } finally { try { Send-Json @{ jsonrpc='2.0'; id=99; method='shutdown'; params=@{} }; $null = Read-UntilId 99 10; Send-Json @{ jsonrpc='2.0'; method='exit'; params=@{} } } catch { Write-Host ("Shutdown warning: " + $_.Exception.Message) }; if ($p -and -not $p.HasExited) { if (-not $p.WaitForExit(5000)) { $p.Kill() } }; if ($p) { $stderr = $p.StandardError.ReadToEnd(); if ($stderr) { Write-Host 'STDERR:'; Write-Host $stderr } } }
```

```powershell
$exe = (Resolve-Path '.\cache\matlab-mcp-core-server\v0.10.0\matlab-mcp-core-server-win64.exe').Path; $project = (Get-Location).Path; $matlabRoot = 'C:\Program Files\MATLAB\R2025b'; $logFolder = Join-Path $project 'cache\matlab-mcp-core-server\logs'; New-Item -ItemType Directory -Force -Path $logFolder | Out-Null; $psi = [System.Diagnostics.ProcessStartInfo]::new(); $psi.FileName = $exe; $psi.Arguments = '--matlab-root="' + $matlabRoot + '" --initial-working-folder="' + $project + '" --log-folder="' + $logFolder + '" --matlab-display-mode=nodesktop --disable-telemetry=true'; $psi.RedirectStandardInput = $true; $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true; $psi.UseShellExecute = $false; $p = [System.Diagnostics.Process]::Start($psi); function Send-Json($obj) { $line = $obj | ConvertTo-Json -Depth 30 -Compress; $p.StandardInput.WriteLine($line); $p.StandardInput.Flush(); Write-Host ("--> " + $line) }; function Read-UntilId([int]$targetId) { while ($true) { $line = $p.StandardOutput.ReadLine(); if ($null -eq $line) { throw "Server stdout closed while waiting for id $targetId" }; Write-Host ("<-- " + $line); $msg = $line | ConvertFrom-Json; if ($msg.id -eq $targetId) { return $msg } } }; try { Send-Json @{ jsonrpc='2.0'; id=1; method='initialize'; params=@{ protocolVersion='2025-03-26'; capabilities=@{}; clientInfo=@{ name='codex-setup-check'; version='1.0.0' } } }; $init = Read-UntilId 1; Send-Json @{ jsonrpc='2.0'; method='notifications/initialized'; params=@{} }; Send-Json @{ jsonrpc='2.0'; id=2; method='tools/call'; params=@{ name='detect_matlab_toolboxes'; arguments=@{} } }; $toolboxes = Read-UntilId 2; Write-Host 'DETECT_TOOLBOXES_RESULT_JSON:'; $toolboxes.result | ConvertTo-Json -Depth 30; Send-Json @{ jsonrpc='2.0'; id=3; method='tools/call'; params=@{ name='evaluate_matlab_code'; arguments=@{ code='version'; project_path=$project } } }; $versionResult = Read-UntilId 3; Write-Host 'VERSION_RESULT_JSON:'; $versionResult.result | ConvertTo-Json -Depth 30; Send-Json @{ jsonrpc='2.0'; method='exit'; params=@{} } } finally { if ($p -and -not $p.HasExited) { Start-Sleep -Seconds 2; if (-not $p.HasExited) { $p.Kill() } }; if ($p) { $stderr = $p.StandardError.ReadToEnd(); if ($stderr) { Write-Host 'STDERR:'; Write-Host $stderr } } }
```

```powershell
$exe = (Resolve-Path '.\cache\matlab-mcp-core-server\v0.10.0\matlab-mcp-core-server-win64.exe').Path; $project = (Get-Location).Path; $matlabRoot = 'C:\Program Files\MATLAB\R2025b'; $logFolder = Join-Path $project 'cache\matlab-mcp-core-server\logs'; New-Item -ItemType Directory -Force -Path $logFolder | Out-Null; $psi = [System.Diagnostics.ProcessStartInfo]::new(); $psi.FileName = $exe; $psi.Arguments = '--matlab-root="' + $matlabRoot + '" --initial-working-folder="' + $project + '" --log-folder="' + $logFolder + '" --matlab-display-mode=nodesktop --disable-telemetry=true'; $psi.RedirectStandardInput = $true; $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true; $psi.UseShellExecute = $false; $psi.StandardInputEncoding = [System.Text.Encoding]::UTF8; $psi.StandardOutputEncoding = [System.Text.Encoding]::UTF8; $psi.StandardErrorEncoding = [System.Text.Encoding]::UTF8; $p = [System.Diagnostics.Process]::Start($psi); function Send-Json($obj) { $line = $obj | ConvertTo-Json -Depth 30 -Compress; $p.StandardInput.WriteLine($line); $p.StandardInput.Flush(); Write-Host ("--> " + $line) }; function Read-UntilId([int]$targetId) { while ($true) { $line = $p.StandardOutput.ReadLine(); if ($null -eq $line) { throw "Server stdout closed while waiting for id $targetId" }; Write-Host ("<-- " + $line); $msg = $line | ConvertFrom-Json; if ($msg.id -eq $targetId) { return $msg } } }; try { Send-Json @{ jsonrpc='2.0'; id=1; method='initialize'; params=@{ protocolVersion='2025-03-26'; capabilities=@{}; clientInfo=@{ name='codex-setup-check'; version='1.0.0' } } }; $init = Read-UntilId 1; Send-Json @{ jsonrpc='2.0'; method='notifications/initialized'; params=@{} }; Send-Json @{ jsonrpc='2.0'; id=2; method='tools/call'; params=@{ name='evaluate_matlab_code'; arguments=@{ code='disp(version); disp(pwd);'; project_path=$project } } }; $versionResult = Read-UntilId 2; Write-Host 'VERSION_RESULT_JSON:'; $versionResult.result | ConvertTo-Json -Depth 30; Send-Json @{ jsonrpc='2.0'; method='exit'; params=@{} } } finally { if ($p -and -not $p.HasExited) { Start-Sleep -Seconds 2; if (-not $p.HasExited) { $p.Kill() } }; if ($p) { $stderr = $p.StandardError.ReadToEnd(); if ($stderr) { Write-Host 'STDERR:'; Write-Host $stderr } } }
```

```powershell
python --version
```

```powershell
@'
import json
import os
import subprocess
import sys
import time

project = os.getcwd()
exe = os.path.join(project, 'cache', 'matlab-mcp-core-server', 'v0.10.0', 'matlab-mcp-core-server-win64.exe')
matlab_root = r'C:\Program Files\MATLAB\R2025b'
log_folder = os.path.join(project, 'cache', 'matlab-mcp-core-server', 'logs')
os.makedirs(log_folder, exist_ok=True)

args = [
    exe,
    f'--matlab-root={matlab_root}',
    f'--initial-working-folder={project}',
    f'--log-folder={log_folder}',
    '--matlab-display-mode=nodesktop',
    '--disable-telemetry=true',
]
proc = subprocess.Popen(args, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, encoding='utf-8')

def send(obj):
    line = json.dumps(obj, ensure_ascii=False, separators=(',', ':'))
    print('-->', line, flush=True)
    proc.stdin.write(line + '\n')
    proc.stdin.flush()

def read_until(target_id):
    while True:
        line = proc.stdout.readline()
        if not line:
            raise RuntimeError(f'server stdout closed while waiting for id {target_id}')
        line = line.rstrip('\n')
        print('<--', line, flush=True)
        msg = json.loads(line)
        if msg.get('id') == target_id:
            return msg

try:
    send({'jsonrpc':'2.0','id':1,'method':'initialize','params':{'protocolVersion':'2025-03-26','capabilities':{},'clientInfo':{'name':'codex-setup-check','version':'1.0.0'}}})
    init = read_until(1)
    send({'jsonrpc':'2.0','method':'notifications/initialized','params':{}})
    send({'jsonrpc':'2.0','id':2,'method':'tools/call','params':{'name':'detect_matlab_toolboxes','arguments':{}}})
    toolboxes = read_until(2)
    install_info = toolboxes.get('result', {}).get('structuredContent', {}).get('installation_info', '')
    toolbox_lines = [line for line in install_info.splitlines() if line.strip()]
    print('DETECT_TOOLBOXES_SUMMARY:', json.dumps({'line_count': len(toolbox_lines), 'first_lines': toolbox_lines[:8]}, ensure_ascii=False), flush=True)
    send({'jsonrpc':'2.0','id':3,'method':'tools/call','params':{'name':'evaluate_matlab_code','arguments':{'code':'disp(version); disp(pwd);','project_path':project}}})
    version_result = read_until(3)
    print('VERSION_RESULT_JSON:', json.dumps(version_result.get('result', {}), ensure_ascii=False), flush=True)
    send({'jsonrpc':'2.0','method':'exit','params':{}})
finally:
    time.sleep(2)
    if proc.poll() is None:
        proc.kill()
    stderr = proc.stderr.read()
    if stderr:
        print('STDERR:', stderr, flush=True)
'@ | python -
```

```powershell
Get-Process | Where-Object { $_.ProcessName -match 'matlab|matlab-mcp' } | Select-Object Id,ProcessName,Path
```

```powershell
git status --short
```

```powershell
$lines = Get-Content C:\Users\wuhan\.codex\memories\MEMORY.md; for ($i=0; $i -lt $lines.Count; $i++) { if ($lines[$i] -match 'project-template-lite|result/<case>/figures|author-profile|\.cursor/rules') { '{0}:{1}' -f ($i+1), $lines[$i] } }
```
