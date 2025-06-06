#!/bin/bash
list="list.txt"
output_dir="result"
mkdir -p "$output_dir"
while IFS= read -r domain || [ -n "$domain" ]; do
    url="http://$domain"
    echo "[+] Crawling & scanning $url dengan plugin sqldet..."
    safe_url=$(echo "$url" | sed 's|https\?://||g' | sed 's|/|_|g')
    xray webscan \
        --basic-crawler "$url" \
        --plugins sqldet \
        --html-output "$output_dir/${safe_url}_sqldet.html"

    if [ $? -eq 0 ]; then
        echo "[✓] Scan selesai untuk $url, menghapus dari list..."
        tail -n +2 "$list" > "$list.tmp" && mv "$list.tmp" "$list"
    else
        echo "[!] Gagal scan $url, menghentikan loop untuk keamanan."
        break
    fi
done < "$list"
