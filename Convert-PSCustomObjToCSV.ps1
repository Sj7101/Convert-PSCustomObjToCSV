function Export-PscustomObjectToCsv {
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject[]]$Data,

        [string]$OutputFile
    )

    # Check if data is provided
    if (-not $Data -or $Data.Count -eq 0) {
        Write-Error "No data provided to export."
        return
    }

    # Extract column names from the first object
    $properties = $Data[0].PSObject.Properties.Name

    # Convert each object to a custom object with the defined properties
    $formattedData = $Data | ForEach-Object {
        $obj = $_
        $formattedObj = [PSCustomObject]@{}
        foreach ($property in $properties) {
            $formattedObj | Add-Member -MemberType NoteProperty -Name $property -Value $obj.$property
        }
        $formattedObj
    }

    # Export to CSV
    $csvPath = Resolve-Path $OutputFile
    try {
        $formattedData | Export-Csv -Path $csvPath -NoTypeInformation
        Write-Host "Data exported to $csvPath." -ForegroundColor Green
    } catch {
        Write-Error "Failed to export data to CSV: $_"
    }
}

# Example usage
# Define sample data
$data = @(
    [PSCustomObject]@{Name = "Alice"; Age = 30; Location = "New York"}
    [PSCustomObject]@{Name = "Bob"; Age = 25; Location = "Los Angeles"}
    [PSCustomObject]@{Name = "Charlie"; Age = 35; Location = "Chicago"}
)

# Export to CSV
Export-PscustomObjectToCsv -Data $data -OutputFile "C:\Path\To\Your\Output.csv"
