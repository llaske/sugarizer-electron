date

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
if [ "$1" == "macwin" -o "$2" == "macwin" ]; then
  cp package.json.macwin sugarizer/package.json
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

if [ "$1" != "full" -a "$2" != "full" ]; then
  echo --- Minimize
  cd ../sugarizer
  grunt -v
  cd ../sugarizer-electron
  cp -r ../sugarizer/build/* sugarizer/
  rm -rf sugarizer/activities/Jappy.activity
  rm -rf sugarizer/activities/TurtleBlocksJS.activity
fi
cp etoys_remote.index.html sugarizer/activities/Etoys.activity/index.html

echo --- Create package
date
cd sugarizer
mkdir build
mkdir build/icons
cp res/icon/electron/icon-512.png build/icons/512x512.png
npm install --save
if [ "$1" == "macwin" -o "$2" == "macwin" ]; then
  # Hack: see https://github.com/electron-userland/electron-builder/issues/4629
  npm install electron-builder@21.2.0 --save-dev
else
  npm install electron-builder --save-dev
fi
#export DEBUG=electron-builder
npm run dist
cd ..
cp -r sugarizer/dist/* dist

date
