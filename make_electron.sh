start=`date +%s`

echo --- Init
mkdir -p sugarizer
mkdir -p dist

echo --- Deleting previous content...
cd sugarizer
rm -rf *
cd ..
rm -rf build

echo --- Copying content
rsync -av --exclude-from='exclude.electron' ../sugarizer/* sugarizer
rm -rf sugarizer/activities/Jappy.activity
rm -rf sugarizer/activities/TurtleBlocksJS.activity
cp etoys_remote.index.html sugarizer/activities/Etoys.activity/index.html
sed -i -e 's/class="offlinemode"//' sugarizer/activities/Scratch.activity/index.html
if [ "$1" != "full" -a "$2" != "full" ]; then
  echo --- Minimize
  cd sugarizer
  npm install grunt grunt-contrib-jshint grunt-contrib-nodeunit grunt-terser
  grunt -v
  rm -rf node_modules
  cd ..
fi
if [ "$1" == "mac" -o "$2" == "mac" ]; then
  cp package.json.mac sugarizer/package.json
elif [ "$1" == "win" -o "$2" == "win" ]; then
  cp package.json.win sugarizer/package.json
elif [ "$1" == "snap" -o "$2" == "snap" ]; then
  cp package.json.snap sugarizer/package.json
elif [ "$1" == "linux" -o "$2" == "linux" ]; then
  cp package.json.linux sugarizer/package.json
else
  echo ERROR: You should provide an ouput target: linux, snap or macwin
  exit
fi
sed -i -e "s/\({\"id\": \"org.sugarlabs.TurtleBlocksJS\",.*\},\)//" sugarizer/activities.json
sed -i -e "s/\({\"id\": \"org.somosazucar.JappyActivity\",.*\},\)//" sugarizer/activities.json
rm sugarizer/activities.json-e
rm -rf dist/*

echo --- Create package
date
cp entitlements.mac.plist sugarizer/res
cd sugarizer
mkdir build
mkdir build/icons
cp res/icon/electron/icon-512.png build/icons/512x512.png
npm install --save
npm install electron-builder --save-dev
npm run dist
cd ..
cp -r sugarizer/dist/* dist

end=`date +%s`
runtime=$((end-start))
hours=$((runtime / 3600))
minutes=$(( (runtime % 3600) / 60 ))
seconds=$(( (runtime % 3600) % 60 ))
echo "Runtime: $hours:$minutes:$seconds (hh:mm:ss)"
