param()
$ErrorActionPreference = "Stop"

Set-Location "D:\SELVIN\aci_diocese"
Write-Host "Running flutter clean..."
flutter clean
Write-Host "Running flutter pub get..."
flutter pub get
Write-Host "Running build_runner..."
dart run build_runner build --delete-conflicting-outputs
Write-Host "Running flutter analyze..."
flutter analyze
Write-Host "Running flutter build apk --debug..."
flutter build apk --debug
Write-Host "Checking devices..."
flutter devices
Write-Host "Installing via flutter install..."
flutter install --use-application-binary build\app\outputs\flutter-apk\app-debug.apk
Write-Host "Build and Install completed."
