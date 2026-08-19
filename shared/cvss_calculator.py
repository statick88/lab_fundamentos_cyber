#!/usr/bin/env python3
"""
cvss_calculator.py — Calculadora CVSS 3.1 base para laboratorio ABC-CYB-101.
Acepta un vector CVSS 3.1 como primer argumento y retorna el score base numérico.

Uso:
    python3 cvss_calculator.py "AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H"
    python3 cvss_calculator.py --file vector.txt

Formato de vector:
    AV:[N|A|L|P]/AC:[L|H]/PR:[N|L|H]/UI:[N|R]/S:[U|C]/C:[N|L|H]/I:[N|L|H]/A:[N|L|H]
"""

import sys
import re

# Pesos oficiales CVSS 3.1
WEIGHTS = {
    "AV": {"N": 0.85, "A": 0.62, "L": 0.55, "P": 0.20},
    "AC": {"L": 0.77, "H": 0.44},
    "PR": {"N": 0.85, "L": 0.62, "H": 0.27},
    "UI": {"N": 0.85, "R": 0.62},
    "S":  {"U": 0.00, "C": 1.00},
    "C":  {"N": 0.00, "L": 0.22, "H": 0.56},
    "I":  {"N": 0.00, "L": 0.22, "H": 0.56},
    "A":  {"N": 0.00, "L": 0.22, "H": 0.56},
}

def parse_vector(vector_str):
    pattern = re.compile(r'^(AV:[NALP])/AC:[LH]/PR:[NLH]/UI:[NR]/S:[UC]/C:[NLH]/I:[NLH]/A:[NLH]$')
    if not pattern.match(vector_str):
        raise ValueError(f"Vector CVSS inválido: {vector_str}")
    parts = {}
    for part in vector_str.split('/'):
        key, val = part.split(':')
        parts[key] = val
    return parts

def cvss_base_score(parts):
    av = WEIGHTS["AV"][parts["AV"]]
    ac = WEIGHTS["AC"][parts["AC"]]
    pr = WEIGHTS["PR"][parts["PR"]]
    ui = WEIGHTS["UI"][parts["UI"]]
    s = WEIGHTS["S"][parts["S"]]

    iss = 1 - ((1 - WEIGHTS["C"][parts["C"]]) * (1 - WEIGHTS["I"][parts["I"]]) * (1 - WEIGHTS["A"][parts["A"]]))

    if parts["S"] == "U":
        base = round(min(10, iss * ac), 1)
    else:
        scope = 1.08 * iss * ac
        impact = scope - 0.029 - 3.25 * (iss - 0.02) ** 15
        exploitability = 8.22 * av * ac * pr * ui
        base = round(min(10, 1.08 * (impact + exploitability)), 1)

    return float(base)

def main():
    if len(sys.argv) < 2:
        print("Uso: python3 cvss_calculator.py <vector>")
        print("Ejemplo: python3 cvss_calculator.py AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H")
        sys.exit(1)

    vector = sys.argv[1]
    if vector == "--file" and len(sys.argv) > 2:
        with open(sys.argv[2], "r") as f:
            vector = f.read().strip()

    try:
        parts = parse_vector(vector)
        score = cvss_base_score(parts)
        print(f"{score:.1f}")
    except Exception as e:
        print(f"ERROR: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
