#!/bin/bash

set -eux

mkdir -p out/release
mkdir -p out/extracted

poepatcher/poepatcher \
	"PathOfExile.exe" \
	"PathOfExile_x64.exe" \
	"Bundles2/_.index.bin" \
	"Bundles2/_Preload.bundle.bin" \
	"Bundles2/Data.dat.7.bundle.bin" \
	"Bundles2/Data.dat.C.bundle.bin" \
	"Bundles2/Data.dat.D.bundle.bin" \
	"Bundles2/Data.dat.E.bundle.bin" \
	"Bundles2/Data/Traditional Chinese.dat.2.bundle.bin" \
	"Bundles2/Data/Traditional Chinese.dat.6.bundle.bin" \
	"Bundles2/Data/Traditional Chinese.dat.7.bundle.bin" \
	"Bundles2/Data/Traditional Chinese.dat.9.bundle.bin" \
	"Bundles2/Data/Traditional Chinese.dat.B.bundle.bin" 

venv/bin/python scripts/extract.py \
	"Metadata/StatDescriptions/stat_descriptions.txt"

datfiles=(BaseItemTypes ActiveSkills PassiveSkills SkillGems Words.dat)
venv/bin/python scripts/exporter.py dat json --files "${datfiles[@]}" -lang 'English' out/extracted/dat.en.json
venv/bin/python scripts/exporter.py dat json --files "${datfiles[@]}" -lang 'Traditional Chinese' out/extracted/dat.tc.json

venv/bin/python scripts/datrelease.py
venv/bin/python scripts/statparse.py out/extracted/stat_descriptions.txt > out/release/stat_descriptions.json
venv/bin/python scripts/charversion.py Content.ggpk.d/latest | tee out/release/version.txt
venv/bin/python scripts/fingerprint.py out/release/{bases.json,stat_descriptions.json,words.json,passives.json,version.txt} | tee out/release/fingerprint.txt
