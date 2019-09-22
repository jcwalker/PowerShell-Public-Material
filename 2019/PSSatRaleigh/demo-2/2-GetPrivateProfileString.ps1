# Get-PrivateProfileString.ps1
# https://www.leeholmes.com/blog/2009/01/19/powershell-pinvoke-walkthrough/

function Get-PrivateProfileString
{
    param
    (
        $file,
        $category,
        $key
    )

    $signature = @'
    [DllImport("kernel32.dll")]
    public static extern uint GetPrivateProfileString(
        string lpAppName,
        string lpKeyName,
        string lpDefault,
        StringBuilder lpReturnedString,
        uint nSize,
        string lpFileName);
'@

    $type = Add-Type -MemberDefinition $signature `
        -Name Win32Utils -Namespace GetPrivateProfileString `
        -Using System.Text -PassThru
    
    $builder = New-Object System.Text.StringBuilder 1024
    $type::GetPrivateProfileString($category,$key, "", $builder, $builder.Capacity, $file)
    
    $builder.ToString()
}

$filePath = Get-Item -Path '.\seceditExport.inf'

Get-PrivateProfileString -File $filePath.FullName -category 'Privilege Rights' -Key SeRemoteShutdownPrivilege
