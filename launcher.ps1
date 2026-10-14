# AI Council launcher - starts the Electron app.
# The Electron main process owns the local server lifecycle (start on boot,
# kill the process tree on quit), so this script only needs to launch Electron.
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$dataDir = Join-Path $env:LOCALAPPDATA 'AI-Council'
$trace = Join-Path $dataDir 'launcher.log'
$electron = Join-Path $root 'node_modules\electron\dist\electron.exe'

function Trace($msg) {
  "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  $msg" | Out-File -FilePath $trace -Append -Encoding ascii
}

function Show-Error($msg) {
  Trace "ERROR: $msg"
  try {
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show($msg, 'AI Council') | Out-Null
  } catch {}
}

try {
  New-Item -ItemType Directory -Force -Path $dataDir | Out-Null

  if (-not (Test-Path $electron)) {
    Trace "electron binary missing; ensuring dependencies"
    if (-not (Test-Path (Join-Path $root 'node_modules'))) {
      $inst = Start-Process -FilePath 'cmd.exe' -ArgumentList '/c npm install' -WorkingDirectory $root -WindowStyle Hidden -Wait -PassThru
      Trace "npm install exit: $($inst.ExitCode)"
    }
    # npm here gates postinstall scripts (allow-scripts), so the Electron binary
    # is often left un-extracted even after a successful install. Run the
    # installer directly - it pulls the binary from the local cache.
    if (-not (Test-Path $electron)) {
      Trace "running electron install.js"
      Start-Process -FilePath 'cmd.exe' -ArgumentList '/c node node_modules\electron\install.js' -WorkingDirectory $root -WindowStyle Hidden -Wait | Out-Null
    }
    if (-not (Test-Path $electron)) {
      Show-Error "Electron could not be installed. See: $trace"
      exit 1
    }
  }

  Trace "starting electron"
  # '.' resolves against WorkingDirectory, avoiding quoting problems with the
  # project path. electron.exe is a GUI app, so no console window appears.
  Start-Process -FilePath $electron -ArgumentList '.' -WorkingDirectory $root
  Trace "electron launched"
} catch {
  Show-Error $_.Exception.Message
  exit 1
}
