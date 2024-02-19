WORKDIR=$(pwd)
PORT=8080
mkdir -p "$WORKDIR"/xml
mkdir -p "$WORKDIR"/html

extract-zips() {
    echo "extracting zipped reports"
    for i in "$WORKDIR"/xml/*.zip; do
        unzip "$i" -d "$WORKDIR/xml" && rm -r "$i"
    done
}
extract-tars() {
    echo "extracting tarred reports"
    for i in "$WORKDIR"/xml/*.tar.gz; do
        tar xzvf "$i" -C "$WORKDIR/xml" && rm -r "$i"
    done
}

# extract zips if they exist
# count_zips=$(ls -1 "$WORKDIR"/xml/*.zip 2>/dev/null | wc -l)
mapfile -t count_zips < <(find "$WORKDIR"/xml/ -maxdepth 1 -name "*.zip" -type f)
if [ "${#count_zips[@]}" -gt 0 ]; then
    extract-zips
fi
# extract tars if they exist
# count_tars=$(ls -1 "$WORKDIR"/xml/*.tar.gz 2>/dev/null | wc -l)
mapfile -t count_tars < <(find "$WORKDIR"/xml/ -maxdepth 1 -name "*.tar.gz" -type f)
if [ "${#count_tars[@]}" -gt 0 ]; then
    extract-tars
fi

echo "converting reports to html"
dmarc-report-converter
echo "open filewall port"
sudo iptables -I INPUT -p tcp --dport $PORT -j ACCEPT
echo "serving reports"
cd "$WORKDIR/html" && python3 -m http.server $PORT
