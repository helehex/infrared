# x--------------------------------------------------------------------------x #
# | MIT License
# | Copyright (c) 2024 Helehex
# x--------------------------------------------------------------------------x #

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

TEST_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
FAILED_COUNT=0

source ${TEST_DIR}/build.sh

for test in ${TEST_DIR}/test_*.mojo; do
    echo -e "\n╓─── Testing: $(basename $test)"
    if mojo $test; then
        echo -e ${GREEN}╙─── Test Successful!${NC}
    else
        ((FAILED_COUNT+=1))
        echo -e ${RED}╙─── Test Failed!${NC}
    fi
done

echo

if [ "$FAILED_COUNT" -eq 0 ]; then
    echo -e "${GREEN}───╖\n   ║ All Successful!\n───╜${NC}"
else
    echo -e "${RED}───╖\n   ║ ${FAILED_COUNT} Failed!\n───╜${NC}"
fi