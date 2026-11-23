#!/usr/bin/env bash
# Export des STL et des rendus d'une version du boitier.
#
#   tools/build.sh [v27]          -> stl/v27/*.stl + renders/*_v27.png
#   STL_ONLY=1 / PNG_ONLY=1       -> une seule des deux etapes
#
# Verifie que chaque piece est manifold (CGAL "Simple: yes") et affiche
# bbox, volume plein et masse PETG (borne haute, 100 % de remplissage).
set -uo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
ver=${1:-v27}
model=$root/scad/boitier_8_sas_${ver}.scad
[[ -f $model ]] || { echo "modele introuvable : $model" >&2; exit 2; }
stl_dir=$root/stl/$ver
jobs=${JOBS:-$(nproc)}
petg=1.27   # g/cm3

# piece:quantite (0 = optionnelle, non comptee dans la masse)
parts=(front:1 rear:1 left:1 right:1 bottom:1 top:1 shelf:1 cage_plate:1
       strut:9 corner_post:2 corner_post_m:2 edge_rail_x:3 edge_rail_y:4
       cable_bar:1 box_foot:4 atx_bridge:1 fan_guard:0 fan_gasket:0)

fail=0
if [[ -z ${PNG_ONLY:-} ]]; then
  mkdir -p "$stl_dir"
  log=$(mktemp -d); trap 'rm -rf "$log"' EXIT
  printf '%s\n' "${parts[@]%%:*}" | xargs -P "$jobs" -I{} \
    sh -c 'openscad -o "$1/$2.stl" -D "part=\"$2\"" "$3" >"$4/$2.log" 2>&1' _ \
      "$stl_dir" {} "$model" "$log"
  for pq in "${parts[@]}"; do
    p=${pq%%:*}
    grep -qE 'Simple: +yes' "$log/$p.log" || { echo "KO  $p : non manifold ou erreur"; fail=1; }
  done
  args=()
  for pq in "${parts[@]}"; do args+=("$stl_dir/${pq%%:*}.stl:${pq##*:}"); done
  python3 "$root/tools/stlinfo.py" --table --density "$petg" "${args[@]}"
fi

if [[ -z ${STL_ONLY:-} ]]; then
  r() {  # nom, part, camera (vide = vue auto)
    xvfb-run -a openscad -o "$root/renders/${1}_${ver}.png" --imgsize 1100,850 \
      ${3:+--camera=$3} --autocenter --viewall -D "part=\"$2\"" "$model" >/dev/null 2>&1 \
      || { echo "rendu KO : $1"; fail=1; }
  }
  # sequentiel : xvfb-run -a n'aime pas les lancements simultanes
  r assembly assembly ""
  r exploded exploded ""
  r rear assembly "0,0,0,70,0,200,0"
  r cutaway cutaway "0,0,0,75,0,345,0"
  ls -1 "$root"/renders/*_"$ver".png
fi
exit $fail
