@echo off
cd /d "c:\Users\anjan\Desktop\In progress\Kuber TImesheet"
echo ===== CHECKING PREREQUISITES ===== > deployment_output.txt 2>&1
node --version >> deployment_output.txt 2>&1
npm --version >> deployment_output.txt 2>&1
vercel --version >> deployment_output.txt 2>&1
echo. >> deployment_output.txt 2>&1
echo ===== DIRECTORY CONTENTS ===== >> deployment_output.txt 2>&1
dir /B >> deployment_output.txt 2>&1
echo. >> deployment_output.txt 2>&1
echo ===== FRONTEND CHECK ===== >> deployment_output.txt 2>&1
dir frontend >> deployment_output.txt 2>&1
echo. >> deployment_output.txt 2>&1
echo Deployment checks complete >> deployment_output.txt 2>&1
type deployment_output.txt
