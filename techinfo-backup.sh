# ID = from techinfo index.html url
#ID=$1
DATE=$(date)

echo "$DATE startup" | tee -a progress.log

for ID in `cat service-manual-id-uniq-reverse.txt`; do

  DATE=$(date)

  echo "$DATE $ID start" | tee -a progress.log

  mkdir -p $ID
  cd $ID
  rm lookupjson.js

  wget --load-cookies=../cookies.txt \
       --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.6 Safari/605.1.15" \
       https://www.subaru-repairinfo.com/scr/doc/serviceManual/$ID/contents/resources/lookupjson.js

  sed 's/var lookupjson = //' lookupjson.js > techinfo.json
  cat techinfo.json | jq '.[].sicatid' | sort | uniq | cut -d \" -f 2 > sicatid.txt

  for i in `cat sicatid.txt`; do
    DATE=$(date)
    echo "$DATE $i cat start" | tee -a progress.log
    wget --mirror --convert-links --adjust-extension \
         --page-requisites --no-parent --progress=dot \
         --recursive --load-cookies=../cookies.txt \
         --keep-session-cookies --save-cookies=../cookies.txt \
         --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.6 Safari/605.1.15" \
         https://www.subaru-repairinfo.com/scr/doc/serviceManual/$ID/contents/data/print/$i.html
    DATE=$(date)
    echo "$DATE $i cat done" | tee -a progress.log
  done
  cd ..
  DU=$(du -sh $ID)
  DATE=$(date)
  echo "$DATE $DU done" | tee -a progress.log
  
done

DATE=$(date)
echo "$DATE all done" | tee -a progress.log
