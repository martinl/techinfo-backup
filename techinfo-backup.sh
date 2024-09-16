# ID = from techinfo index.html url
ID=$1

mkdir $ID
cd $ID
rm lookupjson.js

wget https://www.subaru-repairinfo.com/scr/doc/serviceManual/$ID/contents/resources/lookupjson.js --load-cookies=../cookies.txt --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.6 Safari/605.1.15"

sed 's/var lookupjson = //' lookupjson.js > techinfo.json
cat techinfo.json | jq '.[].sicatid' | sort | uniq | cut -d \" -f 2 > sicatid.txt

for i in `cat sicatid.txt`; do
wget --mirror --convert-links --adjust-extension \
  --page-requisites --no-parent --progress=dot \
  --recursive --load-cookies=../cookies.txt --user-agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.6 Safari/605.1.15" https://www.subaru-repairinfo.com/scr/doc/serviceManual/$ID/contents/data/print/$i.html
done
