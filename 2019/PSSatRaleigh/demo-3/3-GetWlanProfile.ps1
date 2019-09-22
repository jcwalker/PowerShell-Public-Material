$signature = @'
[DllImport("wlanapi.dll", SetLastError = true)]
public static extern uint WlanGetProfile(
    [In] IntPtr clientHandle,
    [In, MarshalAs(UnmanagedType.LPStruct)] Guid interfaceGuid,
    [In, MarshalAs(UnmanagedType.LPWStr)] string profileName,
    [In] IntPtr pReserved,
    [Out, MarshalAs(UnmanagedType.LPWStr)] out string profileXml,
    [In, Out, Optional] ref uint flags,
    [Out, Optional] out uint pdwGrantedAccess
);

[DllImport("Wlanapi.dll")]
public static extern uint WlanOpenHandle(
    [In] uint dwClientVersion,
    [In, Out] IntPtr pReserved, //not in MSDN but required
    [Out] out uint pdwNegotiatedVersion,
    [Out] out IntPtr ClientHandle);
'@


Add-Type -MemberDefinition $signature -Namespace WiFi -Name ProfileManagement -PassThru


# lets open an handle
$handle = [intptr]::Zero
[WiFi.ProfileManagement]::WlanOpenHandle(2,[intptr]::Zero,[ref]2,[ref]$handle)

# get profile info
$guid = (Get-NetAdapter -Name Wi-Fi).InterfaceGuid
$result = $null

[WiFi.ProfileManagement]::WlanGetProfile($handle,$guid,'PSatRaleigh',[intptr]::zero,[ref]$result,[ref]4,[ref]$null)

