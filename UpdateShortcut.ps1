param (
    [string]$ShortcutPath,
    [string]$NewTargetPath
)

# Create a WScript.Shell COM object
$shell = New-Object -ComObject WScript.Shell

# Create a shortcut object from the specified path
$shortcut = $shell.CreateShortcut($ShortcutPath)

# Update the target path of the shortcut
$shortcut.TargetPath = $NewTargetPath

# Save the changes
$shortcut.Save()
