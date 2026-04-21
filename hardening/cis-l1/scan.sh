#!/bin/bash
# OpenSCAP CIS Level 1 audit script
# STATUS: PLACEHOLDER — validated in Phase 3
#
# Usage: sudo ./scan.sh
# Output: HTML report saved to /tmp/scap-report-YYYYMMDD-HHMM.html

set -euo pipefail

PROFILE="xccdf_org.ssgproject.content_profile_cis_level1_server"
DATASTREAM="/usr/share/xml/scap/ssg/content/ssg-ubuntu2404-ds.xml"
REPORT="/tmp/scap-report-$(date +%Y%m%d-%H%M).html"
RESULTS="/tmp/scap-results-$(date +%Y%m%d-%H%M).xml"

echo "[*] Running OpenSCAP CIS Level 1 audit..."
echo "[*] Profile: $PROFILE"
echo "[*] Report: $REPORT"

oscap xccdf eval \
  --profile "$PROFILE" \
  --report "$REPORT" \
  --results "$RESULTS" \
  "$DATASTREAM" || true

echo "[*] Done. Open $REPORT in a browser to review results."
echo "[*] Copy report to hardening/reports/ for record keeping."
