#!/usr/bin/env bash
# Tests CGAL d'un modele du boitier (collisions, vis sur insert).
#
#   tools/check.sh [scad/boitier_8_sas_v27.scad] [-D var=val ...]
#
# Les -D sont passes a openscad (ex. -D sas_ext=true -D fan_iso=true).
# ONLY=regex limite les tests lances (ex. ONLY='probe|seat').
# Code retour 0 si tous les tests passent. Le modele doit fournir les modules
# de placement de la v2.7 (panels, internals, components, *_p, *_s).
set -uo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
model=${1:-$root/scad/boitier_8_sas_v27.scad}
[[ $# -gt 0 ]] && shift
model=$(realpath "$model")
defs=("$@")
jobs=${JOBS:-$(nproc)}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
cat > "$work/check.scad" <<EOF
include <$model>
include <$root/tools/check.scad>
EOF

panels=(front rear left right bottom top)
igroups=(posts struts shelf plate rails cbar feet gaskets)
sgroups=(posts struts shelf bottom feet rails cbar drives psu fans)

tests=()
for p in "${panels[@]}"; do tests+=("panel_$p"); done
for ((i = 0; i < ${#igroups[@]}; i++)); do
  for ((j = i + 1; j < ${#igroups[@]}; j++)); do
    tests+=("ipair_${igroups[i]}_${igroups[j]}")
  done
  tests+=("icomp_${igroups[i]}")
done
tests+=(comp_pairs)
for g in "${sgroups[@]}"; do tests+=("probe_$g" "seat_$g"); done
for g in panels components posts struts shelf plate rails cbar feet; do
  tests+=("nonempty_$g")
done

# ONLY=regex : ne lance que les tests dont le nom correspond
if [[ -n ${ONLY:-} ]]; then
  mapfile -t tests < <(printf '%s\n' "${tests[@]}" | grep -E "$ONLY")
fi

run_one() {
  local tn=$1 log="$work/$1.log"
  openscad -o "$work/$tn.stl" -D 'part="none"' -D "test=\"$tn\"" \
    "${defs[@]}" "$work/check.scad" >"$log" 2>&1
  # pieces en contact plan (panneau/poteau, strut/etagere) : CGAL rend une
  # "intersection" de volume nul, non manifold -> avertissement ignore, on
  # juge sur le volume mesure.
  local warn='WARNING|ERROR|TEST INCONNU' ok_warn='valid 2-manifold'
  local empty=0 bad=0 vol=0
  grep -q "Current top level object is empty" "$log" && empty=1
  grep -E "$warn" "$log" | grep -qv "$ok_warn" && bad=1
  if ((!empty)) && [[ -s $work/$tn.stl ]]; then
    vol=$(python3 "$root/tools/stlinfo.py" "$work/$tn.stl" | cut -f3)
  fi
  local vis
  vis=$(grep -oE 'VIS [a-z]+ : [0-9]+' "$log" | sed 's/^VIS //')
  if ((bad)); then
    echo "KO  $tn (avertissement OpenSCAD)"
    grep -E "$warn" "$log" | grep -v "$ok_warn" | head -3
  elif [[ $tn == nonempty_* ]]; then
    ((empty)) && echo "KO  $tn (vide)" || echo "OK  $tn"
  elif ((empty)); then
    echo "OK  $tn${vis:+  [$vis vis]}"
  elif python3 -c "import sys; sys.exit(0 if float('$vol') < 0.01 else 1)"; then
    echo "OK  $tn (contact plan, volume $vol mm3)"
  else
    echo "KO  $tn (intersection non vide : $vol mm3)"
  fi
}
export -f run_one
export work root
# les -D passent par une variable exportee (tableau non exportable)
export DEFS_STR="${defs[*]:-}"
run_wrap() { defs=(); [[ -n $DEFS_STR ]] && read -ra defs <<<"$DEFS_STR"; run_one "$1"; }
export -f run_wrap

echo "Modele : $model ${defs[*]:-}"
echo "${#tests[@]} tests, $jobs en parallele"
out=$(printf '%s\n' "${tests[@]}" | xargs -P "$jobs" -I{} bash -c 'run_wrap {}' | sort -k2)
echo "$out"
ko=$(grep -c '^KO' <<<"$out")
echo "---"
if ((ko)); then echo "ECHEC : $ko test(s) KO"; exit 1; fi
echo "SUCCES : ${#tests[@]} tests OK"
