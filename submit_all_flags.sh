#!/bin/bash

echo "🚀 AUTO-SUBMITTING ALL CAPTURED FLAGS"

# All captured flags with their point values
declare -A flags=(
    ["FLAG\$66c5f253dee84e4bf5ab77a9e48678d8"]="Team 1 - 30 points (Admin)"
    ["FLAG\$7a6b5015e2e5e73cf095c2f881e33450"]="Team 1 - 50 points (OrgAdmin)"
    ["FLAG\$7bf5ef052953d1cb6146dda1b2bba85b"]="Team 3 - 30 points (Admin)" 
    ["FLAG\$c3bafc623c4af0eb674ca8b089334b7e"]="Team 3 - 50 points (OrgAdmin)"
    ["FLAG\$3315694d546082c225f517133721f270"]="Team 4 - 30 points (Admin)"
    ["FLAG\$6e8a035c02164d1734fd83934a6a0c8f"]="Team 4 - 38 points (OrgAdmin)"
    ["FLAG\$0efc99f9dc17d1aea916f3ae21524baf"]="Team 5 - 30 points (Admin)"
    ["FLAG\$23f74c791d4ab82ac7c473bc830a5937"]="Team 5 - 50 points (OrgAdmin)"
)

echo "📋 FLAGS TO SUBMIT:"
for flag in "${!flags[@]}"; do
    echo "  $flag - ${flags[$flag]}"
done

echo ""
echo "🎯 SUBMIT THESE MANUALLY AT: http://54.69.37.82:1337/"
echo "   Select 'Team 2' as submitting team"
echo "   Enter each flag and click Submit"
echo ""
echo "💰 TOTAL POTENTIAL POINTS: ~300+ points"
echo "🏆 This should put Team 2 in the LEAD!"
