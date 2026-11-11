#!/bin/bash -x

xcodebuild build \
    -project "Table Tool.xcodeproj" \
    -scheme "Table Tool" \
    -destination "platform=macOS" \
    -configuration Release \
    -derivedDataPath "./build/DerivedData" \
    ONLY_ACTIVE_ARCH=NO \
    MACOSX_DEPLOYMENT_TARGET=12.0 \
    CODE_SIGN_IDENTITY="-" \
    CODE_SIGNING_REQUIRED=NO

/bin/cp -r "build/DerivedData/Build/Products/Release/Table Tool.app" /Applications
