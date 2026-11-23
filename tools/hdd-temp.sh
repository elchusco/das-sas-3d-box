#!/usr/bin/env bash
# Temperature des disques du DAS (cote hote, root ou groupe disk).
#
#   tools/hdd-temp.sh [seuil_C]          (defaut 50)
#   DISKS="/dev/sdb /dev/sdc" tools/hdd-temp.sh
#
# Par defaut : tous les disques SAS vus par smartctl --scan. Code retour 1
# si un disque depasse le seuil (utilisable en cron / timer systemd).
# Limite ES.3 : 60 C de temperature boitier (manuel Seagate).
set -uo pipefail

seuil=${1:-50}
command -v smartctl >/dev/null || { echo "smartctl introuvable (smartmontools)" >&2; exit 2; }

if [[ -n ${DISKS:-} ]]; then
  read -ra disks <<<"$DISKS"
else
  mapfile -t disks < <(smartctl --scan | awk '$3 ~ /scsi|sat/ {print $1}')
fi
((${#disks[@]})) || { echo "aucun disque trouve" >&2; exit 2; }

alerte=0
printf '%-10s %-22s %6s\n' disque serie temp
for d in "${disks[@]}"; do
  info=$(smartctl -i -A "$d" 2>/dev/null)
  serie=$(awk -F': *' '/^Serial [Nn]umber/ {print $2; exit}' <<<"$info")
  # SAS : "Current Drive Temperature: 38 C" ; SATA : attribut 194
  temp=$(awk -F': *' '/^Current Drive Temperature/ {print $2+0; exit}' <<<"$info")
  [[ -z $temp ]] && temp=$(awk '$1==194 {print $10; exit}' <<<"$info")
  if [[ -z $temp ]]; then
    printf '%-10s %-22s %6s\n' "$d" "${serie:-?}" "?"
    continue
  fi
  flag=""
  ((temp >= seuil)) && { flag="  ALERTE (>= $seuil C)"; alerte=1; }
  printf '%-10s %-22s %4s C%s\n' "$d" "${serie:-?}" "$temp" "$flag"
done
exit $alerte
