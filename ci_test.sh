#!/usr/bin/bash

VERSION="${1}"

set +e

export TEST_DOSEMU=/usr/bin/dosemu
export TEST_CMDDIR=/usr/share/dosemu/dosemu2-cmds-0.3
export NO_FAILFAST=1

export COPY_COMMAND_COM=/usr/share/comcom${VERSION}/comcom${VERSION}.exe
cat >&2 << EOF
=====================================================
=      Tests run on emulated CPU, KVM and VM86      =
=====================================================
EOF
python3 test/test_processor.py

cat >&2 << EOF2
=====================================================
=        Tests run on various flavours of DOS       =
=====================================================
EOF2
python3 test/test_dosemu.py PPDOSGITTestCase
mkdir comcom${VERSION}
for i in test_*.*.*.log ; do
  test -f $i && mv $i comcom${VERSION}/.
done

# Return non-zero if any logfiles were generated
for i in comcom${VERSION}/test_*.*.*.log ; do
  test -f $i || exit 0
done

exit 1
