Get-ChildItem -Path 'data' | Where-Object -Property FullName -Like '*.csv' | ForEach-Object {
    $CSVFile = $_.FullName
    $SVGFile = $CSVFile -replace '.csv', '.svg'
    $SVGFile = $SVGFile.Replace(([IO.Path]::DirectorySeparatorChar + 'data' + [IO.Path]::DirectorySeparatorChar), ([IO.Path]::DirectorySeparatorChar + 'svg' + [IO.Path]::DirectorySeparatorChar))

    $MaximumValues = 365
    $LineHeight = 25

    $Values = Import-Csv -Delimiter ',' -Path $CSVFile -Header 'Date', 'Value' | Select-Object -Property 'Value' -Last $MaximumValues


    $Max = ($Values | Measure-Object -Property Value -Maximum).Maximum
    $Min = ($Values | Measure-Object -Property Value -Minimum).Minimum

    $MaxX = (($Values | Measure-Object -Property Value).Count) -1

    $MinFloor = [Math]::Floor($Min / $LineHeight) * $LineHeight
    $MaxFloor = ([Math]::Ceiling($Max / $LineHeight) * $LineHeight) + $LineHeight

    $ViewHeight = $MaxFloor - $MinFloor

    $x = 0
    $points = @()
    foreach ($Value in $Values)
        {
        #$y = $Max - ($Value.Value) + $MinFloor
        $y = -($Value.Value)
        $points += "$x,$y"
        $x++
        }

    $xml = New-Object System.XML.XMLDocument

    $svg = $xml.CreateElement('svg')
    $svg.SetAttribute("xmlns", "http://www.w3.org/2000/svg")
    $svg.SetAttribute("xmlns:xlink", "http://www.w3.org/1999/xlink")
    $svg.SetAttribute("version", "1.1")
    #$svg.SetAttribute("style", "border: 1px solid red; width: 40%; height: 60px")
    $svg.SetAttribute("style", "background-color: #e6e6e6; width: 365px;")
    $svg.SetAttribute("viewBox", "0 -$MaxFloor $MaximumValues $ViewHeight")
    $svg.SetAttribute("preserveAspectRatio", "none")

    $xml.AppendChild($svg)

    $polyline = $xml.CreateElement("polyline")
    $polyline.SetAttribute("fill", "none")
    $polyline.SetAttribute("stroke", "#ff8800")
    $polyline.SetAttribute("stroke-width", "3")
    $polyline.SetAttribute("points", ($points -join ' '))

    $svg.AppendChild($polyline)


    $liney = 0
    while($liney -le $MaxFloor) {

        $line = $xml.CreateElement("line")
        $line.SetAttribute("x1", "0")
        $line.SetAttribute("y1", -$liney)
        $line.SetAttribute("x2", $MaximumValues)
        $line.SetAttribute("y2", -$liney)
        $line.SetAttribute("style", "stroke:grey;stroke-width:1")

        $svg.AppendChild($line)

        $liney = $liney + $LineHeight
        }

    #$text = $xml.CreateElement("text")
    #$text.InnerText = $Value.Value
    #$text.SetAttribute("text-anchor", "end")
    #$text.SetAttribute("x", "80%")
    #$text.SetAttribute("y", "-270")
    #$text.SetAttribute("style", "font: 12px sans-serif; text-align: right;")

    #$svg.AppendChild($text)


    $xml.Save($SVGFile)
    }
