#!/usr/bin/env bash
# validate-animation-terms.sh
# Scans a codebase for common animation anti-patterns:
# - Layout animations using width/height instead of transform
# - Non-deterministic timing (setTimeout, Date.now) in video code
# - Missing prefers-reduced-motion fallbacks
# - Hardcoded magic numbers without comments
#
# Usage: ./scripts/validate-animation-terms.sh [directory]
#   Defaults to current directory if not specified.

set -euo pipefail

TARGET_DIR="${1:-.}"
HAS_ERRORS=0
HAS_WARNINGS=0

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "=== Animation Vocabulary Audit ==="
echo "Scanning: $TARGET_DIR"
echo ""

# ------------------------------------------------------------------
# Check 1: Layout thrashing — animating width/height
# ------------------------------------------------------------------
echo -e "${YELLOW}[1/5] Checking for layout-animated properties (width/height)...${NC}"
LAYOUT_PROPERTIES=$(grep -rn --include="*.css" --include="*.tsx" --include="*.jsx" \
  -E '(transition|animation).*(width|height|top|left|margin|padding)' \
  "$TARGET_DIR" 2>/dev/null || true)

if [ -n "$LAYOUT_PROPERTIES" ]; then
  echo -e "${YELLOW}  ⚠  Found potentially layout-thrashing property animations:${NC}"
  echo "$LAYOUT_PROPERTIES" | head -20 | sed 's/^/     /'
  echo -e "${YELLOW}  ⚠  Prefer transform (translate/scale/rotate) + opacity instead.${NC}"
  HAS_WARNINGS=1
else
  echo -e "${GREEN}  ✓ No layout-thrashing properties found.${NC}"
fi
echo ""

# ------------------------------------------------------------------
# Check 2: Non-deterministic timing in video code
# ------------------------------------------------------------------
echo -e "${YELLOW}[2/5] Checking for non-deterministic timing in video files...${NC}"

# Look for setTimeout/setInterval in Remotion files
BAD_TIMING=$(grep -rn --include="*.tsx" --include="*.ts" \
  -E '(setTimeout|setInterval|Date\.now\(\)|Math\.random\(\))' \
  "$TARGET_DIR" 2>/dev/null || true)

if [ -n "$BAD_TIMING" ]; then
  # Filter to only show matches that import from remotion or look like video code
  POTENTIAL_ISSUES=$(echo "$BAD_TIMING" | head -20)
  echo -e "${RED}  ✗ Non-deterministic time calls found:${NC}"
  echo "$POTENTIAL_ISSUES" | sed 's/^/     /'
  echo -e "${RED}  ✗ These will break deterministic rendering. Use useCurrentFrame() instead.${NC}"
  HAS_ERRORS=1
else
  echo -e "${GREEN}  ✓ No non-deterministic timing calls found.${NC}"
fi
echo ""

# ------------------------------------------------------------------
# Check 3: Missing prefers-reduced-motion
# ------------------------------------------------------------------
echo -e "${YELLOW}[3/5] Checking for prefers-reduced-motion support...${NC}"

HAS_REDUCED_MOTION=$(grep -rn --include="*.css" --include="*.tsx" --include="*.jsx" \
  "prefers-reduced-motion" "$TARGET_DIR" 2>/dev/null || true)

HAS_MOTION_FILES=$(find "$TARGET_DIR" \( -name "*.css" -o -name "*.tsx" -o -name "*.jsx" \) \
  -exec grep -l -E '(animation|transition|@keyframes|transform.*scale|framer-motion|reanimated)' {} \; \
  2>/dev/null | head -10 || true)

if [ -n "$HAS_MOTION_FILES" ]; then
  if [ -z "$HAS_REDUCED_MOTION" ]; then
    echo -e "${RED}  ✗ Animation files found but no prefers-reduced-motion found!${NC}"
    echo "     Files with animations:"
    echo "$HAS_MOTION_FILES" | sed 's/^/       /'
    echo -e "${RED}  ✗ Add @media (prefers-reduced-motion: reduce) for WCAG compliance.${NC}"
    HAS_ERRORS=1
  else
    echo -e "${GREEN}  ✓ prefers-reduced-motion found.${NC}"
  fi
else
  echo -e "${YELLOW}  - No animation files found to check.${NC}"
fi
echo ""

# ------------------------------------------------------------------
# Check 4: Magic numbers without comments
# ------------------------------------------------------------------
echo -e "${YELLOW}[4/5] Checking for magic animation numbers...${NC}"

# Look for common animation values without context
MAGIC_NUMBERS=$(grep -rn --include="*.tsx" --include="*.jsx" --include="*.css" \
  -E 'duration:\s*[0-9]{3,4}|transition.*[0-9]{3}ms' \
  "$TARGET_DIR" 2>/dev/null | head -30 || true)

if [ -n "$MAGIC_NUMBERS" ]; then
  echo -e "${YELLOW}  ⚠  Found magic animation numbers — consider adding comments:${NC}"
  echo "$MAGIC_NUMBERS" | head -10 | sed 's/^/     /'
  echo -e "${YELLOW}  ⚠  Add a comment explaining each duration (e.g., // 300ms = standard entrance).${NC}"
  HAS_WARNINGS=1
else
  echo -e "${GREEN}  ✓ No magic numbers found.${NC}"
fi
echo ""

# ------------------------------------------------------------------
# Check 5: Check for correct easing usage
# ------------------------------------------------------------------
echo -e "${YELLOW}[5/5] Checking for common easing mistakes...${NC}"

EASE_IN_ENTRANCE=$(grep -rn --include="*.css" --include="*.tsx" --include="*.jsx" \
  -E '(animation|transition).*(ease-in[^-])' \
  "$TARGET_DIR" 2>/dev/null | grep -vi "exit\|out\|leave" || true)

if [ -n "$EASE_IN_ENTRANCE" ]; then
  echo -e "${YELLOW}  ⚠  Possible ease-in used on entrance animation (may feel sluggish):${NC}"
  echo "$EASE_IN_ENTRANCE" | head -10 | sed 's/^/     /'
  echo -e "${YELLOW}  ⚠  Entrances should use ease-out (fast start). Use ease-in only for exits.${NC}"
  HAS_WARNINGS=1
else
  echo -e "${GREEN}  ✓ No obvious easing mistakes.${NC}"
fi
echo ""

# ------------------------------------------------------------------
# Summary
# ------------------------------------------------------------------
echo "=== Summary ==="
if [ $HAS_ERRORS -gt 0 ]; then
  echo -e "${RED}  ✗ $HAS_ERRORS error(s) found — must fix.${NC}"
fi
if [ $HAS_WARNINGS -gt 0 ]; then
  echo -e "${YELLOW}  ⚠  $HAS_WARNINGS warning(s) found — review recommended.${NC}"
fi
if [ $HAS_ERRORS -eq 0 ] && [ $HAS_WARNINGS -eq 0 ]; then
  echo -e "${GREEN}  ✓ All checks passed!${NC}"
fi

exit $HAS_ERRORS
