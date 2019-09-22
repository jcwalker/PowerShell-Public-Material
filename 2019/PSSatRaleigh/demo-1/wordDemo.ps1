$path = '.\Doc1.docx'
$wordFilePath = (Get-Item -Path $path).FullName

$word = New-Object -ComObject word.application

$word.Visible = $true

$doc = $word.Documents.Open($wordFilePath)

