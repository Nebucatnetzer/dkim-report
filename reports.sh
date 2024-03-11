WORKDIR=$(pwd)
PORT=8080
mkdir -p "$WORKDIR"/xml
mkdir -p "$WORKDIR"/html

echo "converting reports to html"
dmarc-report-converter
echo "open filewall port"
sudo iptables -I INPUT -p tcp --dport $PORT -j ACCEPT
echo "serving reports"
cd "$WORKDIR/html" && python3 -m http.server $PORT
