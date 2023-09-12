<#
.SYNOPSIS
  Connect to Office 365 services via PowerShell

.DESCRIPTION
  This script will prompt for your Office 365 tenant credentials and connect you to any or all Office 365 services via remote PowerShell

.INPUTS
  None

.OUTPUTS
  None

.NOTES
  Version:        1.1.2
  Author:         Chris Goosen (Twitter: @chrisgoosen)
  Creation Date:  15 March 2022
  Credits:        ExchangeMFAModule handling by Michel de Rooij - eightwone.com, @mderooij
                  Bugfinder extraordinaire Greig Sheridan - greiginsydney.com, @greiginsydney
                  Various bugfixes: Andy Helsby - github.com/Absoblogginlutely

.LINK
  http://www.cgoosen.com

.EXAMPLE
  .\Connect-365.ps1
#>
$ErrorActionPreference = "Stop"
$ScriptVersion = "1.1.2"
#region XAML code
$XAML = @"
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Connect-365" Height="420" Width="550" ResizeMode="NoResize" WindowStartupLocation="CenterScreen">
    <Grid>
        <DockPanel>
            <Menu DockPanel.Dock="Top">
                <MenuItem Header="_File">
                    <MenuItem Name="Btn_Exit" Header="_Exit" />
                </MenuItem>

                <MenuItem Header="_Edit">
                    <MenuItem Command="Cut" />
                    <MenuItem Command="Copy" />
                    <MenuItem Command="Paste" />
                </MenuItem>

                <MenuItem Header="_Help">
                    <MenuItem Header="_About">
                        <MenuItem Name="Btn_About" Header="_Script Version 1.1"/>
                        </MenuItem>
                    <MenuItem Name="Btn_Help" Header="_Get Help" />
                </MenuItem>
            </Menu>
        </DockPanel>
        <TabControl Margin="0,20,0,0">
            <TabItem Name="Tab_Connection" Header="Connection Options" TabIndex="12">
                <Grid Background="White">
                    <StackPanel>
                        <StackPanel Height="32" HorizontalAlignment="Center" VerticalAlignment="Top" Width="538" Margin="0,0,0,0">
                            <Label Content="Office 365 Remote PowerShell" HorizontalAlignment="Center" VerticalAlignment="Top" Margin="0" Height="32" FontWeight="Bold"/>
                        </StackPanel>
                        <StackPanel Height="32" HorizontalAlignment="Center" VerticalAlignment="Top" Width="538" Margin="0,0,0,0" Orientation="Horizontal">
                            <Label Content="Username:" HorizontalAlignment="Left" Height="32" Margin="10,0,0,0" VerticalAlignment="Center" Width="70" FontSize="11" VerticalContentAlignment="Center"/>
                            <TextBox Name="Field_User" HorizontalAlignment="Left" Height="22" Margin="0,0,0,0" TextWrapping="Wrap" VerticalAlignment="Center" Width="438" VerticalContentAlignment="Center" FontSize="11" BorderThickness="1" TabIndex="1"/>
                        </StackPanel>
                        <StackPanel Height="32" HorizontalAlignment="Center" VerticalAlignment="Top" Width="538" Margin="0,0,0,0" Orientation="Horizontal">
                            <Label Content="Password:" HorizontalAlignment="Left" Height="32" Margin="10,0,0,0" VerticalAlignment="Center" Width="70" FontSize="11" VerticalContentAlignment="Center"/>
                            <PasswordBox Name="Field_Pwd" HorizontalAlignment="Left" Height="22" Margin="0,0,0,0" VerticalAlignment="Center" Width="438" VerticalContentAlignment="Center" FontSize="11" BorderThickness="1" TabIndex="2"/>
                        </StackPanel>
                        <StackPanel HorizontalAlignment="Center" VerticalAlignment="Top" Width="538" Margin="0,10,0,0">
                            <GroupBox Header="Services:" Width="508" Margin="10,0,0,0" FontSize="11" HorizontalAlignment="Left" VerticalAlignment="Top">
                                <Grid Height="60" Margin="0,10,0,0">
                                    <CheckBox Name="Box_EXO" TabIndex="3" HorizontalAlignment="Left" VerticalAlignment="Top">Exchange Online</CheckBox>
                                    <CheckBox Name="Box_AAD" TabIndex="4" HorizontalAlignment="Center" VerticalAlignment="Top">Azure AD</CheckBox>
                                    <CheckBox Name="Box_Com" TabIndex="5" HorizontalAlignment="Right" VerticalAlignment="Top">Compliance Center</CheckBox>
                                    <CheckBox Name="Box_SPO" TabIndex="6" HorizontalAlignment="Left" VerticalAlignment="Center">SharePoint Online</CheckBox>
                                    <CheckBox Name="Box_SfB" TabIndex="7" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="78,0,0,0">Skype for Business Online</CheckBox>
                                    <CheckBox Name="Box_Teams" TabIndex="8" HorizontalAlignment="Right" VerticalAlignment="Center" Margin="0,0,62,0">Teams</CheckBox>
                                    <CheckBox Name="Box_Intune" TabIndex="9" HorizontalAlignment="Left" VerticalAlignment="Bottom">Intune</CheckBox>
                                </Grid>
                            </GroupBox>
                            <GroupBox Header="Options:" Width="508" Margin="10,10,0,0" FontSize="11" HorizontalAlignment="Left" VerticalAlignment="Top">
                                <Grid Height="50" Margin="0,10,0,0">
                                  <CheckBox Name="Box_MFA" TabIndex="10" HorizontalAlignment="Left" VerticalAlignment="Top">Use MFA?</CheckBox>
                                  <CheckBox Name="Box_Clob" TabIndex="11" HorizontalAlignment="Center" VerticalAlignment="Top" IsEnabled="False" Margin="20,0,0,0">AllowClobber</CheckBox>
                                    <StackPanel HorizontalAlignment="Left" VerticalAlignment="Bottom" Orientation="Horizontal">
                                        <Label Content="Admin URL:" Width="70"></Label>
                                        <TextBox Name="Field_SPOUrl" Height="22" Width="425" Margin="0,0,0,0" TextWrapping="Wrap" IsEnabled="False" TabIndex="12"></TextBox>
                                    </StackPanel>
                                </Grid>
                            </GroupBox>
                        </StackPanel>
                        <StackPanel Height="45" Orientation="Horizontal" VerticalAlignment="Top" HorizontalAlignment="Center" Margin="0,10,0,0">
                            <Button Name="Btn_Ok" Content="Ok" Width="75" Height="25" VerticalAlignment="Top" HorizontalAlignment="Center" TabIndex="13" />
                            <Button Name="Btn_Cancel" Content="Cancel" Width="75" Height="25" VerticalAlignment="Top" HorizontalAlignment="Center" Margin="40,0,0,0" TabIndex="14" />
                        </StackPanel>
                    </StackPanel>
                </Grid>
            </TabItem>
            <TabItem Name="Tab_Prereq" Header="Prerequisite Checker" TabIndex="11">
                <Grid Background="White">
                    <StackPanel>
                        <StackPanel>
                            <Grid Margin="0,10,0,0">
                                <Label Content="Module" HorizontalAlignment="Left" FontSize="11" FontWeight="Bold"/>
                                <Label Content="Status" HorizontalAlignment="Center" FontSize="11" FontWeight="Bold"/>
                            </Grid>
                            <StackPanel>
                                <Label BorderBrush="Black" BorderThickness="0,0,0,1" VerticalAlignment="Top"/>
                            </StackPanel>
                        </StackPanel>
                        <StackPanel>
                            <Grid Margin="0,10,0,0">
                                <Label Content="Azure AD Version 2" HorizontalAlignment="Left" FontSize="11"/>
                                <TextBlock Name="Txt_AADStatus" HorizontalAlignment="Center" VerticalAlignment="Center" FontSize="11" />
                                <Button Name="Btn_AADMsg" Content="Download now.." Width="125" Height="25" HorizontalAlignment="Right" VerticalAlignment="Center" Margin="0,0,10,0" />
                            </Grid>
                        </StackPanel>
                        <StackPanel>
                            <Grid Margin="0,10,0,0">
                                <Label Content="SharePoint Online" HorizontalAlignment="Left" FontSize="11"/>
                                <TextBlock Name="Txt_SPOStatus" HorizontalAlignment="Center" VerticalAlignment="Center" FontSize="11" />
                                <Button Name="Btn_SPOMsg" Content="Download now.." Width="125" Height="25" HorizontalAlignment="Right" VerticalAlignment="Center" Margin="0,0,10,0" />
                            </Grid>
                        </StackPanel>
                        <StackPanel>
                            <Grid Margin="0,10,0,0">
                                <Label Content="Skype for Business Online" HorizontalAlignment="Left" FontSize="11"/>
                                <TextBlock Name="Txt_SfBStatus" HorizontalAlignment="Center" VerticalAlignment="Center" FontSize="11" />
                                <Button Name="Btn_SfBMsg" Content="Download now.." Width="125" Height="25" HorizontalAlignment="Right" VerticalAlignment="Center" Margin="0,0,10,0" />
                            </Grid>
                        </StackPanel>
                            <Grid Margin="0,10,0,0">
                                <Label Content="Exchange Online" HorizontalAlignment="Left" FontSize="11"/>
                                <TextBlock Name="Txt_EXOStatus" HorizontalAlignment="Center" VerticalAlignment="Center" FontSize="11" />
                            <Button Name="Btn_EXOMsg" Content="Download now.." Width="125" Height="25" HorizontalAlignment="Right" VerticalAlignment="Center" Margin="0,0,10,0" />
                        </Grid>
                        <StackPanel>
                          <Grid Margin="0,10,0,0">
                              <Label Content="Teams" HorizontalAlignment="Left" FontSize="11"/>
                              <TextBlock Name="Txt_TeamsStatus" HorizontalAlignment="Center" VerticalAlignment="Center" FontSize="11" />
                          <Button Name="Btn_TeamsMsg" Content="Download now.." Width="125" Height="25" HorizontalAlignment="Right" VerticalAlignment="Center" Margin="0,0,10,0" />
                    </Grid>
                        </StackPanel>
                        <StackPanel>
                          <Grid Margin="0,10,0,0">
                              <Label Content="Intune (MS Graph)" HorizontalAlignment="Left" FontSize="11"/>
                              <TextBlock Name="Txt_IntuneStatus" HorizontalAlignment="Center" VerticalAlignment="Center" FontSize="11" />
                          <Button Name="Btn_IntuneMsg" Content="Download now.." Width="125" Height="25" HorizontalAlignment="Right" VerticalAlignment="Center" Margin="0,0,10,0" />
                    </Grid>
                        </StackPanel>
                    </StackPanel>
                </Grid>
            </TabItem>
        </TabControl>
    </Grid>
</Window>
"@

#endregion

[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAMLGui = $XAML

$Reader=(New-Object System.Xml.XmlNodeReader $XAMLGui)
$MainWindow=[Windows.Markup.XamlReader]::Load( $Reader )
$XAMLGui.SelectNodes("//*[@Name]") | ForEach-Object {Set-Variable -Name "GUI$($_.Name)" -Value $MainWindow.FindName($_.Name)}

# Functions
Function Get-Options{
        If ($GUIBox_EXO.IsChecked -eq "True") {
            $Script:ConnectEXO = $true
            $OptionsArray++
    }
        If ($GUIBox_AAD.IsChecked -eq "True") {
            $Script:ConnectAAD = $true
            $OptionsArray ++
    }
        If ($GUIBox_Com.IsChecked -eq "True") {
            $Script:ConnectCom = $true
            $OptionsArray++
    }
        If ($GUIBox_SfB.IsChecked -eq "True") {
            $Script:ConnectSfB = $true
            $OptionsArray++
    }
        If ($GUIBox_SPO.IsChecked -eq "True") {
            $Script:ConnectSPO = $true
            $OptionsArray++
    }
        If ($GUIBox_Teams.IsChecked -eq "True") {
            $Script:ConnectTeams = $true
            $OptionsArray++
    }
        If ($GUIBox_Intune.IsChecked -eq "True") {
            $Script:ConnectIntune = $true
            $OptionsArray++
    }
        If ($GUIBox_MFA.IsChecked -eq "True") {
            $Script:UseMFA = $true
    }
        If ($GUIBox_Clob.IsChecked -eq "True") {
            $Script:Clob = $true
    }
}

Function Get-UserPwd{
        If (!$Username -or !$Pwd) {
            $MainWindow.Close()
            Close-Window "Please enter valid credentials..`nScript failed"
    }
        ElseIf ($OptionsArray -eq "0") {
            $MainWindow.Close()
            Close-Window "Please select a valid option..`nScript failed"
    }
}

Function Connect-EXO{
    If ($UseMFA) {
      $EXOSession = New-EXOPSSession -ConnectionUri https://outlook.office365.com/powershell-liveid/ -UserPrincipalName $UserName
    }
    Else {
      $EXOSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Credential -Authentication Basic -AllowRedirection
    }
    If ($Clob) {
      Import-PSSession $EXOSession -AllowClobber
    }
    Else {
      Import-PSSession $EXOSession
    }
}

Function Connect-AAD{
    If ($UseMFA) {
      Connect-AzureAD -AccountId $UserName
    }
    Else {
      Connect-AzureAD -Credential $Credential
    }
}

Function Connect-Com{
    If ($UseMFA) {
      $CCSession = New-EXOPSSession -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -UserPrincipalName $UserName
    }
    Else {
      $CCSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/ -Credential $Credential -Authentication Basic -AllowRedirection
    }
    If ($Clob) {
      Import-PSSession $CCSession -AllowClobber
    }
    Else {
      Import-PSSession $CCSession
    }
}

Function Connect-SfB{
    If ($UseMFA) {
      $SfBSession = New-CsOnlineSession -UserName $UserName
    }
    Else {
      $SfBSession = New-CsOnlineSession -Credential $Credential
    }
    If ($Clob) {
      Import-PSSession $SfBSession -AllowClobber
    }
    Else {
      Import-PSSession $SfBSession
    }
}

Function Connect-SPO{
    If ($UseMFA) {
      Connect-SPOService -Url $GUIField_SPOUrl.text
    }
    Else {
      Connect-SPOService -Url $GUIField_SPOUrl.text -Credential $Credential
    }
}

Function Connect-Teams{
    If ($UseMFA) {
      Connect-MicrosoftTeams -AccountId $UserName
    }
    Else {
      Connect-MicrosoftTeams -Credential $Credential
    }
}

Function Connect-Intune{
    If ($UseMFA) {
      Connect-MSGraph
    }
    Else {
      Connect-MSGraph -PSCredential $Credential
    }
}

Function Get-ModuleInfo-AAD{
      try {
          Import-Module -Name AzureAD
          return $true
      }
      catch {
          return $false
      }
}

Function Get-ModuleInfo-SfB{
      try {
          Import-Module -Name SkypeOnlineConnector
          return $true
      }
      catch {
          return $false
      }
}

Function Get-ModuleInfo-SPO{
    try {
        Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
        return $true
    }
    catch {
        return $false
    }
}

# ExchangeMFAModule handling by Michel de Rooij - eightwone.com, @mderooij
Function Get-ModuleInfo-EXO{
    try {
        $ExchangeMFAModule = 'Microsoft.Exchange.Management.ExoPowershellModule'
        $ModuleList = @(Get-ChildItem -Path "$($env:LOCALAPPDATA)\Apps\2.0" -Filter "$($ExchangeMFAModule).manifest" -Recurse ) | Sort-Object LastWriteTime -Desc | Select-Object -First 1
        If ( $ModuleList) {
          $ModuleName = Join-path -Path $ModuleList[0].Directory.FullName -ChildPath "$($ExchangeMFAModule).dll"
        }
        Import-Module -FullyQualifiedName $ModuleName -Force
        return $true
    }
    catch {
        return $false
    }
}

Function Get-ModuleInfo-Teams{
    try {
        Import-Module -Name MicrosoftTeams
        return $true
    }
    catch {
        return $false
    }
}

Function Get-ModuleInfo-Intune{
    try {
        Import-Module -Name Microsoft.Graph.Intune
        return $true
    }
    catch {
        return $false
    }
}


function Close-Window ($CloseReason) {
    Write-Host "$CloseReason" -ForegroundColor Red
    Exit
}

function Get-FailedMsg ($FailedReason) {
    Write-Host "$FailedReason. Connection failed, please check your credentials and try again.." -ForegroundColor Red
    Exit
}

function Get-PreReq-AAD{
    If (Get-ModuleInfo-AAD -eq "True") {
        $GUITxt_AADStatus.Text = "OK!"
        $GUITxt_AADStatus.Foreground = "Green"
        $GUIBtn_AADMsg.IsEnabled = $false
        $GUIBtn_AADMsg.Opacity = "0"
    }
    else {
        $GUITxt_AADStatus.Text = "Failed!"
        $GUITxt_AADStatus.Foreground = "Red"
        $GUIBtn_AADMsg.IsEnabled = $true
    }
}

function Get-PreReq-SfB{
    If (Get-ModuleInfo-SfB -eq "True") {
        $GUITxt_SfBStatus.Text = "OK!"
        $GUITxt_SfBStatus.Foreground = "Green"
        $GUIBtn_SfBMsg.IsEnabled = $false
        $GUIBtn_SfBMsg.Opacity = "0"
    }
    else {
        $GUITxt_SfBStatus.Text = "Failed!"
        $GUITxt_SfBStatus.Foreground = "Red"
        $GUIBtn_SfBMsg.IsEnabled = $true
    }
}

function Get-PreReq-SPO{
    If (Get-ModuleInfo-SPO -eq "True") {
        $GUITxt_SPOStatus.Text = "OK!"
        $GUITxt_SPOStatus.Foreground = "Green"
        $GUIBtn_SPOMsg.IsEnabled = $false
        $GUIBtn_SPOMsg.Opacity = "0"
    }
    else {
        $GUITxt_SPOStatus.Text = "Failed!"
        $GUITxt_SPOStatus.Foreground = "Red"
        $GUIBtn_SPOMsg.IsEnabled = $true
    }
}

function Get-PreReq-EXO{
    If (Get-ModuleInfo-EXO -eq "True") {
        $GUITxt_EXOStatus.Text = "OK!"
        $GUITxt_EXOStatus.Foreground = "Green"
        $GUIBtn_EXOMsg.IsEnabled = $false
        $GUIBtn_EXOMsg.Opacity = "0"
    }
    else {
        $GUITxt_EXOStatus.Text = "Failed!"
        $GUITxt_EXOStatus.Foreground = "Red"
        $GUIBtn_EXOMsg.IsEnabled = $true
    }
}

function Get-PreReq-Teams{
    If (Get-ModuleInfo-Teams -eq "True") {
        $GUITxt_TeamsStatus.Text = "OK!"
        $GUITxt_TeamsStatus.Foreground = "Green"
        $GUIBtn_TeamsMsg.IsEnabled = $false
        $GUIBtn_TeamsMsg.Opacity = "0"
    }
    else {
        $GUITxt_TeamsStatus.Text = "Failed!"
        $GUITxt_TeamsStatus.Foreground = "Red"
        $GUIBtn_TeamsMsg.IsEnabled = $true
    }
}

function Get-PreReq-Intune{
    If (Get-ModuleInfo-Intune -eq "True") {
        $GUITxt_IntuneStatus.Text = "OK!"
        $GUITxt_IntuneStatus.Foreground = "Green"
        $GUIBtn_IntuneMsg.IsEnabled = $false
        $GUIBtn_IntuneMsg.Opacity = "0"
    }
    else {
        $GUITxt_IntuneStatus.Text = "Failed!"
        $GUITxt_IntuneStatus.Foreground = "Red"
        $GUIBtn_IntuneMsg.IsEnabled = $true
    }
}
function Get-PreReq{
  Get-PreReq-AAD
  Get-PreReq-SfB
  Get-PreReq-SPO
  Get-PreReq-EXO
  Get-PreReq-Teams
  Get-PreReq-Intune
}

function Get-OKBtn{
  $Script:Username = $GUIField_User.Text
  $Pwd = $GUIField_Pwd.Password
  Get-Options
  Get-UserPwd
	$EncryptPwd = $Pwd | ConvertTo-SecureString -AsPlainText -Force
	$Script:Credential = New-Object System.Management.Automation.PSCredential($Username,$EncryptPwd)
  $Script:EndScript = 2
	$MainWindow.Close()
}

function Get-CancelBtn{
    $MainWindow.Close()
    $Script:EndScript = 1
	Close-Window 'Script cancelled'
}

# Event Handlers
$MainWindow.add_KeyDown({
    param
(
  [Parameter(Mandatory)][Object]$Sender,
  [Parameter(Mandatory)][Windows.Input.KeyEventArgs]$KeyPress
)
    if ($KeyPress.Key -eq "Enter"){
    Get-OKBtn
    }

    if ($KeyPress.Key -eq "Escape"){
    Get-CancelBtn
    }
})

$MainWindow.add_Closing({
    $Script:EndScript++
})

$GUIBtn_Cancel.add_Click({
    Get-CancelBtn
})

$GUIBtn_Ok.add_Click({
    Get-OKBtn
})

$GUITab_Prereq.add_Loaded({

})

$GUIBtn_AADMsg.add_Click({
    try {
        Start-Process -FilePath https://www.powershellgallery.com/packages/AzureAD
    }
    catch {
        $MainWindow.Close()
        Close-Window "An error occurred..`nExiting script"
    }
})

$GUIBtn_SfBMsg.add_Click({
    try {
        Start-Process -FilePath http://go.microsoft.com/fwlink/?LinkId=294688
    }
    catch {
        $MainWindow.Close()
        Close-Window "An error occurred..`nExiting script"
    }
})

$GUIBtn_SPOMsg.add_Click({
    try {
        Start-Process -FilePath http://go.microsoft.com/fwlink/p/?LinkId=255251
    }
    catch {
        $MainWindow.Close()
        Close-Window "An error occurred..`nExiting script"
    }
})

$GUIBtn_EXOMsg.add_Click({
    try {
        Start-Process -FilePath http://bit.ly/ExOPSModule
    }
    catch {
        $MainWindow.Close()
        Close-Window "An error occurred..`nExiting script"
    }
})

$GUIBtn_TeamsMsg.add_Click({
    try {
        Start-Process -FilePath https://www.powershellgallery.com/packages/MicrosoftTeams
    }
    catch {
        $MainWindow.Close()
        Close-Window "An error occurred..`nExiting script"
    }
})

$GUIBtn_IntuneMsg.add_Click({
    try {
        Start-Process -FilePath https://github.com/Microsoft/Intune-PowerShell-SDK
    }
    catch {
        $MainWindow.Close()
        Close-Window "An error occurred..`nExiting script"
    }
})

$GUIBox_EXO.add_Click({
    $GUIBox_Clob.IsEnabled = "True"
})

$GUIBox_Com.add_Click({
    $GUIBox_Clob.IsEnabled = "True"
})

$GUIBox_SfB.add_Click({
    $GUIBox_Clob.IsEnabled = "True"
})

$GUIBox_SPO.add_Checked({
    $GUIField_SPOUrl.IsEnabled = "True"
    $GUIField_SPOUrl.Text = "Enter your SharePoint Online Admin URL, e.g https://<tenant>-admin.sharepoint.com"
})

$GUIBox_SPO.add_UnChecked({
    $GUIField_SPOUrl.IsEnabled = "False"
    $GUIField_SPOUrl.Text = ""
})

$GUIField_SPOUrl.add_GotFocus({
    $GUIField_SPOUrl.Text = ""
})

$GUIBtn_Exit.add_Click({
    Get-CancelBtn
})

$GUIBtn_About.add_Click({
    Start-Process -FilePath http://cgoo.se/2ogotCK
})

$GUIBtn_Help.add_Click({
    Start-Process -FilePath http://cgoo.se/1srvTiS
})

# Script re-req checks
Write-Host "Starting script version $ScriptVersion..`nLooking for installed modules.." -ForegroundColor Green
Get-PreReq
Write-Host "Done!" -ForegroundColor Green

# Load GUI Window
$MainWindow.WindowStartupLocation = "CenterScreen"
$MainWindow.ShowDialog() | Out-Null

# Check if Window is closed
If ($EndScript -eq 1){
    Close-Window 'Script cancelled'
}

# Connect to Skype for Business Online if required
If ($ConnectSfB -eq "True"){
     Try {
         Connect-Sfb
     }
     Catch 	{
         Get-FailedMsg 'Skype for Business Online error'
     }
 }

# Connect to EXO if required
If ($ConnectEXO -eq "True"){
        Try {
            Connect-EXO
        }
        Catch 	{
            Get-FailedMsg 'Exchange Online error'
        }
}

# Connect to SharePoint Online if required
If ($ConnectSPO-eq "True"){
    Try {
        Connect-SPO
    }
    Catch 	{
        Get-FailedMsg 'SharePoint Online error'
    }
}

# Connect to Security & Compliance Center if required
If ($ConnectCom -eq "True"){
    Try {
        Start-Sleep -Seconds 2
        Connect-Com
    }
    Catch 	{
        Get-FailedMsg 'Security & Compliance Center error'
    }
}

# Connect to AAD if required
If ($ConnectAAD -eq "True"){
    Try {
        Connect-AAD
    }
    Catch 	{
        Get-FailedMsg 'Azure AD error'
    }
}

# Connect to Teams if required
If ($ConnectTeams -eq "True"){
    Try {
        Connect-Teams
    }
    Catch 	{
        Get-FailedMsg 'Teams error'
    }
}

# Connect to Intune if required
If ($ConnectIntune -eq "True"){
    Try {
        Connect-Intune
    }
    Catch 	{
        Get-FailedMsg 'Intune error'
    }
}

# Notifications/Information
Clear-Host
Write-Host "
Your username is: $UserName" -ForegroundColor Yellow -BackgroundColor Black
Write-Host "You are now connected to:" -ForegroundColor Yellow -BackgroundColor Black
If ($ConnectEXO -eq "True"){
    Write-Host "-Exchange Online" -ForegroundColor Yellow -BackgroundColor Black
}
If ($ConnectAAD -eq "True"){
    Write-Host "-Azure Active Directory" -ForegroundColor Yellow -BackgroundColor Black
}
If ($ConnectCom -eq "True"){
    Write-Host "-Office 365 Security & Compliance Center" -ForegroundColor Yellow -BackgroundColor Black
}
If ($ConnectSfB -eq "True"){
    Write-Host "-Skype for Business Online" -ForegroundColor Yellow -BackgroundColor Black
}
If ($ConnectSPO -eq "True"){
    Write-Host "-SharePoint Online" -ForegroundColor Yellow -BackgroundColor Black
}
If ($ConnectTeams -eq "True"){
    Write-Host "-Teams" -ForegroundColor Yellow -BackgroundColor Black
}
If ($ConnectIntune -eq "True"){
    Write-Host "-Intune API" -ForegroundColor Yellow -BackgroundColor Black
}

# SIG # Begin signature block
# MIIePQYJKoZIhvcNAQcCoIIeLjCCHioCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUg8hxCQxtC6rcf6s60HTvBupc
# ZbGgghhVMIIE/jCCA+agAwIBAgIQDUJK4L46iP9gQCHOFADw3TANBgkqhkiG9w0B
# AQsFADByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFz
# c3VyZWQgSUQgVGltZXN0YW1waW5nIENBMB4XDTIxMDEwMTAwMDAwMFoXDTMxMDEw
# NjAwMDAwMFowSDELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMu
# MSAwHgYDVQQDExdEaWdpQ2VydCBUaW1lc3RhbXAgMjAyMTCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBAMLmYYRnxYr1DQikRcpja1HXOhFCvQp1dU2UtAxQ
# tSYQ/h3Ib5FrDJbnGlxI70Tlv5thzRWRYlq4/2cLnGP9NmqB+in43Stwhd4CGPN4
# bbx9+cdtCT2+anaH6Yq9+IRdHnbJ5MZ2djpT0dHTWjaPxqPhLxs6t2HWc+xObTOK
# fF1FLUuxUOZBOjdWhtyTI433UCXoZObd048vV7WHIOsOjizVI9r0TXhG4wODMSlK
# XAwxikqMiMX3MFr5FK8VX2xDSQn9JiNT9o1j6BqrW7EdMMKbaYK02/xWVLwfoYer
# vnpbCiAvSwnJlaeNsvrWY4tOpXIc7p96AXP4Gdb+DUmEvQECAwEAAaOCAbgwggG0
# MA4GA1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsG
# AQUFBwMIMEEGA1UdIAQ6MDgwNgYJYIZIAYb9bAcBMCkwJwYIKwYBBQUHAgEWG2h0
# dHA6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzAfBgNVHSMEGDAWgBT0tuEgHf4prtLk
# YaWyoiWyyBc1bjAdBgNVHQ4EFgQUNkSGjqS6sGa+vCgtHUQ23eNqerwwcQYDVR0f
# BGowaDAyoDCgLoYsaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL3NoYTItYXNzdXJl
# ZC10cy5jcmwwMqAwoC6GLGh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9zaGEyLWFz
# c3VyZWQtdHMuY3JsMIGFBggrBgEFBQcBAQR5MHcwJAYIKwYBBQUHMAGGGGh0dHA6
# Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBPBggrBgEFBQcwAoZDaHR0cDovL2NhY2VydHMu
# ZGlnaWNlcnQuY29tL0RpZ2lDZXJ0U0hBMkFzc3VyZWRJRFRpbWVzdGFtcGluZ0NB
# LmNydDANBgkqhkiG9w0BAQsFAAOCAQEASBzctemaI7znGucgDo5nRv1CclF0CiNH
# o6uS0iXEcFm+FKDlJ4GlTRQVGQd58NEEw4bZO73+RAJmTe1ppA/2uHDPYuj1UUp4
# eTZ6J7fz51Kfk6ftQ55757TdQSKJ+4eiRgNO/PT+t2R3Y18jUmmDgvoaU+2QzI2h
# F3MN9PNlOXBL85zWenvaDLw9MtAby/Vh/HUIAHa8gQ74wOFcz8QRcucbZEnYIpp1
# FUL1LTI4gdr0YKK6tFL7XOBhJCVPst/JKahzQ1HavWPWH1ub9y4bTxMd90oNcX6X
# t/Q/hOvB46NJofrOp79Wz7pZdmGJX36ntI5nePk2mOHLKNpbh6aKLzCCBTEwggQZ
# oAMCAQICEAqhJdbWMht+QeQF2jaXwhUwDQYJKoZIhvcNAQELBQAwZTELMAkGA1UE
# BhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2lj
# ZXJ0LmNvbTEkMCIGA1UEAxMbRGlnaUNlcnQgQXNzdXJlZCBJRCBSb290IENBMB4X
# DTE2MDEwNzEyMDAwMFoXDTMxMDEwNzEyMDAwMFowcjELMAkGA1UEBhMCVVMxFTAT
# BgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEx
# MC8GA1UEAxMoRGlnaUNlcnQgU0hBMiBBc3N1cmVkIElEIFRpbWVzdGFtcGluZyBD
# QTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAL3QMu5LzY9/3am6gpnF
# OVQoV7YjSsQOB0UzURB90Pl9TWh+57ag9I2ziOSXv2MhkJi/E7xX08PhfgjWahQA
# OPcuHjvuzKb2Mln+X2U/4Jvr40ZHBhpVfgsnfsCi9aDg3iI/Dv9+lfvzo7oiPhis
# EeTwmQNtO4V8CdPuXciaC1TjqAlxa+DPIhAPdc9xck4Krd9AOly3UeGheRTGTSQj
# MF287DxgaqwvB8z98OpH2YhQXv1mblZhJymJhFHmgudGUP2UKiyn5HU+upgPhH+f
# MRTWrdXyZMt7HgXQhBlyF/EXBu89zdZN7wZC/aJTKk+FHcQdPK/P2qwQ9d2srOlW
# /5MCAwEAAaOCAc4wggHKMB0GA1UdDgQWBBT0tuEgHf4prtLkYaWyoiWyyBc1bjAf
# BgNVHSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzASBgNVHRMBAf8ECDAGAQH/
# AgEAMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAKBggrBgEFBQcDCDB5BggrBgEF
# BQcBAQRtMGswJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBD
# BggrBgEFBQcwAoY3aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
# QXNzdXJlZElEUm9vdENBLmNydDCBgQYDVR0fBHoweDA6oDigNoY0aHR0cDovL2Ny
# bDQuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNybDA6oDig
# NoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9v
# dENBLmNybDBQBgNVHSAESTBHMDgGCmCGSAGG/WwAAgQwKjAoBggrBgEFBQcCARYc
# aHR0cHM6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzALBglghkgBhv1sBwEwDQYJKoZI
# hvcNAQELBQADggEBAHGVEulRh1Zpze/d2nyqY3qzeM8GN0CE70uEv8rPAwL9xafD
# DiBCLK938ysfDCFaKrcFNB1qrpn4J6JmvwmqYN92pDqTD/iy0dh8GWLoXoIlHsS6
# HHssIeLWWywUNUMEaLLbdQLgcseY1jxk5R9IEBhfiThhTWJGJIdjjJFSLK8pieV4
# H9YLFKWA1xJHcLN11ZOFk362kmf7U2GJqPVrlsD0WGkNfMgBsbkodbeZY4UijGHK
# eZR+WfyMD+NvtQEmtmyl7odRIeRYYJu6DC0rbaLEfrvEJStHAgh8Sa4TtuF8QkIo
# xhhWz0E0tmZdtnR79VYzIi8iNrJLokqV2PWmjlIwggawMIIEmKADAgECAhAIrUCy
# YNKcTJ9ezam9k67ZMA0GCSqGSIb3DQEBDAUAMGIxCzAJBgNVBAYTAlVTMRUwEwYD
# VQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAf
# BgNVBAMTGERpZ2lDZXJ0IFRydXN0ZWQgUm9vdCBHNDAeFw0yMTA0MjkwMDAwMDBa
# Fw0zNjA0MjgyMzU5NTlaMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2Vy
# dCwgSW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25p
# bmcgUlNBNDA5NiBTSEEzODQgMjAyMSBDQTEwggIiMA0GCSqGSIb3DQEBAQUAA4IC
# DwAwggIKAoICAQDVtC9C0CiteLdd1TlZG7GIQvUzjOs9gZdwxbvEhSYwn6SOaNhc
# 9es0JAfhS0/TeEP0F9ce2vnS1WcaUk8OoVf8iJnBkcyBAz5NcCRks43iCH00fUyA
# VxJrQ5qZ8sU7H/Lvy0daE6ZMswEgJfMQ04uy+wjwiuCdCcBlp/qYgEk1hz1RGeiQ
# IXhFLqGfLOEYwhrMxe6TSXBCMo/7xuoc82VokaJNTIIRSFJo3hC9FFdd6BgTZcV/
# sk+FLEikVoQ11vkunKoAFdE3/hoGlMJ8yOobMubKwvSnowMOdKWvObarYBLj6Na5
# 9zHh3K3kGKDYwSNHR7OhD26jq22YBoMbt2pnLdK9RBqSEIGPsDsJ18ebMlrC/2pg
# VItJwZPt4bRc4G/rJvmM1bL5OBDm6s6R9b7T+2+TYTRcvJNFKIM2KmYoX7Bzzosm
# JQayg9Rc9hUZTO1i4F4z8ujo7AqnsAMrkbI2eb73rQgedaZlzLvjSFDzd5Ea/ttQ
# okbIYViY9XwCFjyDKK05huzUtw1T0PhH5nUwjewwk3YUpltLXXRhTT8SkXbev1jL
# chApQfDVxW0mdmgRQRNYmtwmKwH0iU1Z23jPgUo+QEdfyYFQc4UQIyFZYIpkVMHM
# IRroOBl8ZhzNeDhFMJlP/2NPTLuqDQhTQXxYPUez+rbsjDIJAsxsPAxWEQIDAQAB
# o4IBWTCCAVUwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQUaDfg67Y7+F8R
# hvv+YXsIiGX0TkIwHwYDVR0jBBgwFoAU7NfjgtJxXWRM3y5nP+e6mK4cD08wDgYD
# VR0PAQH/BAQDAgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMDMHcGCCsGAQUFBwEBBGsw
# aTAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEEGCCsGAQUF
# BzAChjVodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVk
# Um9vdEc0LmNydDBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsMy5kaWdpY2Vy
# dC5jb20vRGlnaUNlcnRUcnVzdGVkUm9vdEc0LmNybDAcBgNVHSAEFTATMAcGBWeB
# DAEDMAgGBmeBDAEEATANBgkqhkiG9w0BAQwFAAOCAgEAOiNEPY0Idu6PvDqZ01bg
# Ahql+Eg08yy25nRm95RysQDKr2wwJxMSnpBEn0v9nqN8JtU3vDpdSG2V1T9J9Ce7
# FoFFUP2cvbaF4HZ+N3HLIvdaqpDP9ZNq4+sg0dVQeYiaiorBtr2hSBh+3NiAGhEZ
# GM1hmYFW9snjdufE5BtfQ/g+lP92OT2e1JnPSt0o618moZVYSNUa/tcnP/2Q0XaG
# 3RywYFzzDaju4ImhvTnhOE7abrs2nfvlIVNaw8rpavGiPttDuDPITzgUkpn13c5U
# bdldAhQfQDN8A+KVssIhdXNSy0bYxDQcoqVLjc1vdjcshT8azibpGL6QB7BDf5WI
# IIJw8MzK7/0pNVwfiThV9zeKiwmhywvpMRr/LhlcOXHhvpynCgbWJme3kuZOX956
# rEnPLqR0kq3bPKSchh/jwVYbKyP/j7XqiHtwa+aguv06P0WmxOgWkVKLQcBIhEuW
# TatEQOON8BUozu3xGFYHKi8QxAwIZDwzj64ojDzLj4gLDb879M4ee47vtevLt/B3
# E+bnKD+sEq6lLyJsQfmCXBVmzGwOysWGw/YmMwwHS6DTBwJqakAwSEs0qFEgu60b
# hQjiWQ1tygVQK+pKHJ6l/aCnHwZ05/LWUpD9r4VIIflXO7ScA+2GRfS0YW6/aOIm
# YIbqyK+p/pQd52MbOoZWeE4wggdmMIIFTqADAgECAhAOAM2cJBZhlw9sbiKMIxPJ
# MA0GCSqGSIb3DQEBCwUAMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2Vy
# dCwgSW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25p
# bmcgUlNBNDA5NiBTSEEzODQgMjAyMSBDQTEwHhcNMjIwMzE1MDAwMDAwWhcNMjIx
# MjIyMjM1OTU5WjBrMQswCQYDVQQGEwJBVTEYMBYGA1UECBMPTmV3IFNvdXRoIFdh
# bGVzMRQwEgYDVQQHEwtNb3VudCBBbm5hbjEVMBMGA1UEChMMQ2hyaXMgR29vc2Vu
# MRUwEwYDVQQDEwxDaHJpcyBHb29zZW4wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAw
# ggIKAoICAQD1yYzva1FoEgUviqqjJAUrydlWkI37jNXdMZsZJODmu4R7mI4TOakO
# oK+37N2i9yHaTFfJDBuevywvpgmf/WrOxaPHJltTffrLZ/qr2r5QuwRbIli5ysW1
# mF3cBp7ZTtw3vEwRXBW6TPccviFOnU+Y7SNO5Tik81wClWmDb1YvM0CGaFDWS7Ga
# Ql+vIQq2bfLD1m5RDE+oXSroyoD980zkN6aj/m3pDmnJ4eMf3Y8GgvUUq6f4vFBt
# 8vsz4SPiK30AFKDgCZAFLhq8RPt6ScPibf+Dp4fL/dXTbf9xDqur7wea3ObUQcE+
# AXF3STc9N3x4NgFFiUJwrqYoGM+hIKfItqMaWSsOweZOCUJg6cYkEHMFRw3Wl704
# tkp10adV/1m8Veyl6HrXRwNgASByjZzfD1ccfLCSzVJx7JMwz4r+KL0QLqZsfBGw
# oLf/pJdRg0EjyzbquG1B5dAYaz9JD5q0elk7gmbqLtuEqdUi9EXuT3c+Trf6WTv7
# YKrRAPlCGXTeMUOqgPpzJZanY/7LP2OJo7leYdPBkc4xQ6Q3f2fMuShpjKqO52Ti
# Dl+aswC2m/gwYz7zuYcEMfMc8Mn4Vzee78dRIx3dbR8kyG3DOeB/OBO8k9VE+i8w
# 7D++8HN1Vn+NahIhLGZbEtmlmGLaCiVN5G9zWQv00YksWkmsYEoSAQIDAQABo4IC
# BjCCAgIwHwYDVR0jBBgwFoAUaDfg67Y7+F8Rhvv+YXsIiGX0TkIwHQYDVR0OBBYE
# FNAJbKdauzrdSeP+bT6eI5loaSQ8MA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAK
# BggrBgEFBQcDAzCBtQYDVR0fBIGtMIGqMFOgUaBPhk1odHRwOi8vY3JsMy5kaWdp
# Y2VydC5jb20vRGlnaUNlcnRUcnVzdGVkRzRDb2RlU2lnbmluZ1JTQTQwOTZTSEEz
# ODQyMDIxQ0ExLmNybDBToFGgT4ZNaHR0cDovL2NybDQuZGlnaWNlcnQuY29tL0Rp
# Z2lDZXJ0VHJ1c3RlZEc0Q29kZVNpZ25pbmdSU0E0MDk2U0hBMzg0MjAyMUNBMS5j
# cmwwPgYDVR0gBDcwNTAzBgZngQwBBAEwKTAnBggrBgEFBQcCARYbaHR0cDovL3d3
# dy5kaWdpY2VydC5jb20vQ1BTMIGUBggrBgEFBQcBAQSBhzCBhDAkBggrBgEFBQcw
# AYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMFwGCCsGAQUFBzAChlBodHRwOi8v
# Y2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRUcnVzdGVkRzRDb2RlU2lnbmlu
# Z1JTQTQwOTZTSEEzODQyMDIxQ0ExLmNydDAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3
# DQEBCwUAA4ICAQArqghPJoTWImFY9L+VmtCYHRnoC4mZOEeZEVt8FY9dX7ZfTpA/
# gTGrxBSbtg6Quno0p5Ie92uFJHFqUmQGUEqj/TaLFJ7f7F6qYsacqLQ0OWZPyuMy
# he0pbEl57LCqQE4hDSAFR6PRuONJMQ/BeRFlp9FQy3y60BCQ/FV20joDoS7wew4M
# POxyes7IWXo2H3Qprye+NTY3Qxv4+yhpsDbu2qz4PEnvBR6RtZdSF1RWBmHULIVN
# 9bVJIIqW9CRPM8pbH4iSwPpqKAFGH6PVgRuHcB0Lx1ebC/KPnxmHKF7JY+wbTyXW
# TqltBvX4BL5wqpw4iG8TDFFLHd/F1jfh600Pr82F2m75oCiFIIybSqdsm2OWvAia
# 5JOrZhrh90hveWkZllNSW18b/EMG9i0n0iPY0qGd5fQDpMYjbv291y305oMkWIU4
# p8oMsUJf2On2WLjSfrtzd+CJjJeRz+1fN+hbQkW8JspC+Lc4btWUEV/vAgAdL2hd
# byINnGaYsbPpgtsGPyh8aSf7N32IQWM0vWzIB5XcCpkEaDKQYpsWEqbalu4BbYfN
# QOAEKLTj0EPIPOurSnO7iSSrQ2AmYWnNRp7eRMMDV4S6VFclLPIypCjRjCq/Tmhf
# vWMUVXSX68MP6CehXO5I4Bv1PN/jYCvt46iJ8iVzdsVgrNG5iInAfC7fqDGCBVIw
# ggVOAgEBMH0waTELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMu
# MUEwPwYDVQQDEzhEaWdpQ2VydCBUcnVzdGVkIEc0IENvZGUgU2lnbmluZyBSU0E0
# MDk2IFNIQTM4NCAyMDIxIENBMQIQDgDNnCQWYZcPbG4ijCMTyTAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUFoSMVAStfxLgrsJLhzE2GmfoYYMwDQYJKoZIhvcNAQEBBQAEggIAtDxf
# zUKogMFqDB4nvajmYKIzG5finD2rzCFo+pJzPNKiGWGdvOagkb4Fv9NaLpyMK8vH
# hBI4QMTmeHthjYldsbZNN8pYMjAuA/9PifHA21LDM9xydJrf9RyTFVxkyMtATVnq
# n9Au3xtHKP1cEpgUE1WQ+KNkpsvYJXKPrU6Q9a+/Hn+yK/aDTBN6eyZvrAPyWDE5
# daEP4k/yXaaATe6pXkD2I2/+oMaQypUztfjMEU+kgJ0oZQ9h0xd099wTVaw9ht5s
# +KY/GnxCfkX/rlvRhLdgn7HO+cHy6ZKIiT9g3qgioAcB/3eGH9PoXF6sURQJIbtl
# sLsWnGjGSOLhFAtMdwNlyLQivJoI06rQBoc2dAq4ExtY7V1t4UYI0JwFPOi5anlj
# hxNagiKG+DaYWKwgJGKw+hi3aF31aW1uZg7U/ZHq/aiO4+0YQgMva1vTG8kr4izu
# CKT7mTZws+uZ1Uz4viaKRdqem/KPSDo+wNsdO1EP1xjte3fAO4Y4V5kaiwwWBnnI
# /WQBWFjfhPnFY6VlW4yIC44FcbYr2bk0d6H1FQ39rmv8N6TPwqRj6uKMBe3wD8c6
# GPoDmgiC8YsRwHlkmni6FtUdy+EoRe630VD/CdcIlCUz6SVRInU7010YHFaL3H4g
# yf9eYt4N6AQGf7QQTgmHJvQiBL9ORfDyH9gM5iyhggIwMIICLAYJKoZIhvcNAQkG
# MYICHTCCAhkCAQEwgYYwcjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0
# IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTExMC8GA1UEAxMoRGlnaUNl
# cnQgU0hBMiBBc3N1cmVkIElEIFRpbWVzdGFtcGluZyBDQQIQDUJK4L46iP9gQCHO
# FADw3TANBglghkgBZQMEAgEFAKBpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEw
# HAYJKoZIhvcNAQkFMQ8XDTIyMDMxNTIzMjczNVowLwYJKoZIhvcNAQkEMSIEIE2D
# D+rCaO38mDGlN6CrCX0eP2h1f8ZEJxyd6Hj/Qc57MA0GCSqGSIb3DQEBAQUABIIB
# AL031OB2KaAw53iVcWp0hlPqa4Q87t+ywLycDi4KGMsoYwR9PBpnAen3aozhK37b
# 2hEGD5SAU70iD4IenAGLbXr6sVHR6ekN2/EiPMziE8gNlZN7HtoLUqoc3uMWeYcS
# oJYIA7JYgsuVwY9rVUWH1zSxRi5WHRrPpI6k07/TPkeqYTI24Oz8KhphlMtpbMSa
# SKGX7b1tNKmvDmR86zY7Q5SoExcHVSipaqPD6OQPaa5p3NSOoY3NWSvaMP1JljjW
# O1PtzcSZf7MqtqwNrNCX4LFyK4OGXyBMXRFVKDOfk2RV2kCD3geMh+WsG/tO3xHI
# Z806ifJ+WiS4JOf7b1C22W0=
# SIG # End signature block
