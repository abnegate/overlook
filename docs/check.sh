#!/bin/env sh

SWIFTC="$(which swift)"
SWIFTV="$(swift --version)"
OS="$(uname)"

if [ "$SWIFTC" == "" ]; then
  echo "❌ Unable to locate a swift installation."
  echo ""
  echo "Swift 5.5 is required to install overlook."
  echo "For more information on Swift, visit Swift.org"
  echo ""
  exit 1
fi

if [ "$OS" == "Darwin" ]; then
  XCBVERSION="$(xcodebuild -version)"

  case "$XCBVERSION" in
  *"Xcode 8"*) ;;
  *)
    echo "⚠️  It looks like your Command Line Tools version is incorrect."
    echo ""
    echo "Open Xcode and make sure the correct SDK is selected:"
    echo "👀  Xcode > Preferences > Locations > Command Line Tools"
    echo ""
    echo "Correct: Xcode 8.x (Any Build Number)"
    echo "Current: $XCBVERSION"
    echo ""
    help
    exit 1
    ;;
  esac
fi

case "$SWIFTV" in
"5."*)
   echo "✅  Compatible"
   exit 0
  ;;
*)
    echo "❌  Incompatible"
    echo "Reason: Swift 5.5+ is required."
    echo ""
    echo "'swift --version' output:"
    echo "$SWIFTV"
    echo ""
    echo "Output does not contain '5.5'."
    echo ""
    help
    exit 1
esac

