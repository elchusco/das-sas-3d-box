# Add2PSU — démarrage automatique du DAS avec la tour

## Principe

Sans carte mère dans le DAS, le CX430 ne démarre jamais seul (PS_ON doit être
ponté à COM). Le module **Add2PSU** fait ce pont automatiquement quand il
détecte le 12 V d'une première alimentation :

```
[tour 5820]                          [DAS]
PSU Dell ── Molex 4p ──(⌀12 pass.)──> Add2PSU ── ATX 24p femelle <── CX430 24p
              (12 V présent = tour ON)   │ relais ferme PS_ON↔COM
                                        └────> CX430 démarre = DAS ON
```

- **ON** : allumer la 5820 → 12 V sur le Molex tour → relais du module →
  PS_ON du CX430 à la masse → DAS démarre
- **OFF** : arrêt de la 5820 → 12 V tombe → relais ouvert → CX430 s'arrête
- L'**interrupteur secteur du CX430** (face arrière, exposée par la découpe)
  reste l'interrupteur général : sur OFF, le DAS ne peut jamais démarrer.

## Référence recommandée

| | |
|---|---|
| Produit | **Add2PSU** — carte de synchronisation, relais solide, ATX 24p femelle + Molex 4p mâle |
| Réf Amazon.fr | **2 pcs Add2PSU ATX 24pin→Molex** — ASIN `B09R1LTX52` — **15,19 €** le lot (spare inclus), livraison 3,99 € |
| Alternative | DKEY DK-ADD2PSU — ASIN `B06XNQ2M61` (prix masqué « ajouter au panier ») |
| Dimensions | **70 × 30 mm**, hauteur ~15 mm (relais), 4 trous de fixation ⌀3 mm aux coins (entraxe ~64 × ~24 mm) |
| Photo | `add2psu_dkey_70x30mm.jpg` |

## Installation prévue dans le boîtier

- Position : **fond** du boîtier, zone sous le PSU (le PSU occupe x 66..216,
  y 216..356 — le module se fixe à côté, zone x 20..60, y 240..300).
- Fixation : 4 vis M3 × 6 via **inserts Ruthex M3×5.7** (⌀4.0, prof. 5.7).
- Perçages : 4 × ⌀3.2 (libre) — voir `atx_bridge_mount` dans le SCAD.
- Câblage : Molex entrant (2 fils 18 AWG depuis la tour, via passe-câble ⌀12
  du panneau arrière) + 24 broches court vers le CX430 (~10 cm de chute).

## Variantes acceptables

- **Relais 12 V + jumper DIY** (même effet, ~2 €) si le module est introuvable.
- **Pont fixe PS_ON↔COM** (`atx_bridge` imprimé) : le CX430 démarre dès que
  l'interrupteur secteur est ON, indépendamment de la tour — solution de
  secours simple, mais pas de synchro d'allumage.
