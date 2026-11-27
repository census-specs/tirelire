#!/usr/bin/env bash
# Remplace l'icône par défaut de Capacitor par l'icône de Tirelire (icon-512.png).
set -euo pipefail
SRC="../icon-512.png"
RES="android/app/src/main/res"
declare -A SIZES=( [mdpi]=48 [hdpi]=72 [xhdpi]=96 [xxhdpi]=144 [xxxhdpi]=192 )
# On retire les icônes adaptatives par défaut pour utiliser nos PNG
rm -rf "$RES"/mipmap-anydpi-v26
for d in "${!SIZES[@]}"; do
  s=${SIZES[$d]}
  mkdir -p "$RES/mipmap-$d"
  convert "$SRC" -resize "${s}x${s}" "$RES/mipmap-$d/ic_launcher.png"
  cp "$RES/mipmap-$d/ic_launcher.png" "$RES/mipmap-$d/ic_launcher_round.png"
  cp "$RES/mipmap-$d/ic_launcher.png" "$RES/mipmap-$d/ic_launcher_foreground.png"
done
echo "Icônes Android remplacées."
