[CmdletBinding(SupportsShouldProcess=$true)]
param(
[Parameter(Mandatory=$true)]
[string]$environment
)

## Script Version
$ScriptVersion = "00.00.01"

## BaseDirectory for all of our files
$BaseDirectory = $PSScriptRoot

# Save off the script name.
$scriptName = $MyInvocation.MyCommand.Name

# JSON configuration filename to use
$global:BaseConfig = "config.json"
$global:ConfigFile = [io.path]::combine($BaseDirectory, $BaseConfig)

# Does the file exist?
if ( -Not (Test-Path $ConfigFile -PathType Leaf)) {
    $outMsg = "The Base configuration file is missing. $ConfigFile"
	throw [System.IO.FileNotFoundException] $outMsg
}

# Load and parse the JSON configuration file
try {
	$global:Config = Get-Content "$ConfigFile" -Raw -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue | ConvertFrom-Json 


} catch {
	$outMsg="`nError Crunching up the config file.`n $ConfigFile `n`n$_.Exception.Message `n"
	throw [System.Data.DataException] $outMsg
}

# $Config now holds all of info from the config file. 
$_Info = ($Config._Info)
$_ConfigVersion = ($Config.basic._ConfigVersion)
$ConfigVersion = ($Config.basic.ConfigVersion)
$_ServerName = ($Config.basic._ServerName)
$ServerName = ($Config.$($environment).ServerName)

write-output "`nStarting $scriptName ($ScriptVersion) `n$($_ConfigVersion): $ConfigVersion`n"

## if the script is not run on the server defined for our environment then exit.
if ( $ServerName.CompareTo($env:COMPUTERNAME) ) {
	$outMsg="`nThe server name does not match the expected one. $ServerName $($env:COMPUTERNAME)"
	throw [System.Data.DataException] $outMsg
	}

## At this point We have our variables and know that we are on the correct server.

Write-Output "`n$($_ServerName) ($($environment)): $ServerName"

write-output "`nExiting...`n"

