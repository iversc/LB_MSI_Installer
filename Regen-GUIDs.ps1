function GenGUID($varName)
{
    return $varName + '="{' + [guid]::NewGuid().guid + '}"'
}

function GenCustomChild($data)
{
    return $xml.CreateProcessingInstruction("define", $data)
}

function GenChild($Name)
{
    return (GenCustomChild (GenGuid $Name))
}

[xml]$xml = Get-Content lb450config.wxi

$progFilesDir = $xml.Include.define[0]
$ExampleFilesDir = $xml.Include.define[1]

$xml.RemoveChild($xml.Include) | Out-Null

$include = $xml.CreateElement("Include")

$include.AppendChild( (GenCustomChild $progFilesDir) ) | Out-Null
$include.AppendChild( (GenCustomChild $ExampleFilesDir) ) | Out-Null

$include.AppendChild( (GenChild "ProductCode") ) | Out-Null
$include.AppendChild( (GenChild "ProductUpgradeCode") ) | Out-Null
$include.AppendChild( (GenChild "LauncherComponentGUID") ) | Out-Null
$include.AppendChild( (GenChild "ProgramMenuComponentGUID") ) | Out-Null

$xml.AppendChild($include) | Out-Null

#$xml.Include.RemoveChild($xml.Include.define[0])



$fileName = (Get-Location).Path + "\lb450config.wxi"


$xml.Save($fileName)