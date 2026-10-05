# Auto-organizer script for Diyasaru GIS Project
param(
    [string]$SourceFolder = "$env:USERPROFILE\Downloads"
)

$targetRoot = $PSScriptRoot

$mapping = @{
    "01_ArcGIS_Map_Documents"       = @(".mxd", ".mxt", ".qgz", ".qgs", ".aprx")
    "02_Vector_Layers_Shapefiles"   = @(".shp", ".shx", ".dbf", ".prj", ".cpg", ".sbn", ".sbx", ".kml", ".kmz", ".geojson")
    "03_Raster_Imagery_and_Scans"   = @(".tif", ".tiff", ".img", ".ecw", ".jp2", ".sid")
    "04_Tabular_Data_and_Attributes" = @(".xlsx", ".xls", ".csv", ".tsv")
    "05_Documentation_and_Reports"  = @(".pdf", ".docx", ".doc", ".txt")
    "06_Exported_Maps_and_Graphics"  = @(".png", ".jpg", ".jpeg")
}

Write-Host "Scanning $SourceFolder for Diyasaru files..." -ForegroundColor Cyan

$files = Get-ChildItem -Path $SourceFolder -File | Where-Object { $_.Name -like "*Diyasaru*" }

if ($files.Count -eq 0) {
    Write-Host "No files matching '*Diyasaru*' found in $SourceFolder." -ForegroundColor Yellow
    exit
}

foreach ($f in $files) {
    $ext = $f.Extension.ToLower()
    $moved = $false
    foreach ($folder in $mapping.Keys) {
        if ($mapping[$folder] -contains $ext) {
            $dest = Join-Path $targetRoot $folder
            Copy-Item -Path $f.FullName -Destination $dest -Force
            Write-Host "Organized: $($f.Name) -> $folder" -ForegroundColor Green
            $moved = $true
            break
        }
    }
    if (-not $moved) {
        $dest = Join-Path $targetRoot "05_Documentation_and_Reports"
        Copy-Item -Path $f.FullName -Destination $dest -Force
        Write-Host "Organized (Default): $($f.Name) -> 05_Documentation_and_Reports" -ForegroundColor Green
    }
}

Write-Host "Organization complete!" -ForegroundColor Cyan
