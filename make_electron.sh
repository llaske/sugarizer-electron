date

echo --- Deleting previous content...
cd sugarizer
rm -rf *
cd ..
rm -rf build
echo --- Copying content
rsync -av --exclude-from='exclude.electron' ../sugarizer/* sugarizer
cp package.json.snap sugarizer/package.json
#cp package.json.linux sugarizer/package.json
sed -i -e "s/\({\"id\": \"org.sugarlabs.TurtleBlocksJS\",.*\},\)//" sugarizer/activities.json
sed -i -e "s/\({\"id\": \"org.somosazucar.JappyActivity\",.*\},\)//" sugarizer/activities.json
rm sugarizer/activities.json-e
rm -rf dist/*

if [ "$1" != "full" -a "$2" != "full" -a "$3" != "full" ]; then
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
if [ "$1" != "docker" -a "$2" != "docker" -a "$3" != "docker" ]; then
  # --- Build locally 
  npm install --save
  npm install electron-builder --save-dev
  #export DEBUG=electron-builder
  npm run dist
  cd ..
  cp -r sugarizer/dist/* dist
else
  # --- Build using docker
  echo "mkdir /project" > npm_run_dist.sh
  echo "mkdir /project/sugarizer" >> npm_run_dist.sh
  echo "cd /project/sugarizer" >> npm_run_dist.sh
  echo "npm install" >> npm_run_dist.sh
  echo "npm install electron-builder --save-dev" >> npm_run_dist.sh
  echo "npm run dist" >> npm_run_dist.sh
  docker run --privileged=true -d --name sugarizer-builder -it sugarizer-electron:deploy /bin/bash 
  docker cp sugarizer sugarizer-builder:/project
  docker cp npm_run_dist.sh sugarizer-builder:/
  docker exec -t sugarizer-builder /bin/bash /npm_run_dist.sh
  docker cp sugarizer-builder:/project/sugarizer/build .
  docker stop sugarizer-builder 
  #docker rm sugarizer-builder 
fi

date
