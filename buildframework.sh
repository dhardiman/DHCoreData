# For details refer to: https://github.com/jverkoey/iOS-Framework#walkthrough
set -e
set +u
# Avoid recursively calling this script.
if [[ $SF_MASTER_SCRIPT_RUNNING ]]
then
exit 0
fi
set -u
export SF_MASTER_SCRIPT_RUNNING=1

SF_TARGET_NAME=DHCoreData
SF_EXECUTABLE_PATH="lib${SF_TARGET_NAME}.a"
SF_WRAPPER_NAME="${SF_TARGET_NAME}.framework"

# The following conditionals come from
# https://github.com/kstenerud/iOS-Universal-Framework

if [[ "$SDK_NAME" =~ ([A-Za-z]+) ]]
then
SF_SDK_PLATFORM=${BASH_REMATCH[1]}
else
echo "Could not find platform name from SDK_NAME: $SDK_NAME"
exit 1
fi

if [[ "$SDK_NAME" =~ ([0-9]+.*$) ]]
then
SF_SDK_VERSION=${BASH_REMATCH[1]}
else
echo "Could not find sdk version from SDK_NAME: $SDK_NAME"
exit 1
fi

if [[ "$SF_SDK_PLATFORM" = "iphoneos" ]]
then
SF_OTHER_PLATFORM=iphonesimulator
else
SF_OTHER_PLATFORM=iphoneos
fi

if [[ "$BUILT_PRODUCTS_DIR" =~ (.*)$SF_SDK_PLATFORM$ ]]
then
SF_OTHER_BUILT_PRODUCTS_DIR="${BASH_REMATCH[1]}${SF_OTHER_PLATFORM}"
else
echo "Could not find platform name from build products directory: $BUILT_PRODUCTS_DIR"
exit 1
fi

PROJECT_DIRECTORY=$(dirname "${PROJECT_FILE_PATH}")
WORKSPACE="${PROJECT_DIRECTORY}/DHCoreDataStack.xcodeproj"
echo "============================= BUILDING ${WORKSPACE} OTHER ${SF_OTHER_PLATFORM} ============================"
# Build the other platform.
xcodebuild -project "${WORKSPACE}" -scheme "dhcdframework" -sdk ${SF_OTHER_PLATFORM}${SF_SDK_VERSION} BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}" SYMROOT="${SYMROOT}" $ACTION

FRAMEWORK_FOLDER="${BUILD_ROOT}/${SF_WRAPPER_NAME}"

# delete any existing framework
rm -rf "${FRAMEWORK_FOLDER}"

VERSIONS="${FRAMEWORK_FOLDER}/Versions"
A_FOLDER="${VERSIONS}/A/"
HEADERS="${A_FOLDER}/Headers"
mkdir -p "${A_FOLDER}"
mkdir -p "${HEADERS}"
mkdir -p "${SF_OTHER_BUILT_PRODUCTS_DIR}/${SF_WRAPPER_NAME}/Versions/A/"

# Smash the two static libraries into one fat binary and store it in the .framework
lipo -create "${BUILT_PRODUCTS_DIR}/${SF_EXECUTABLE_PATH}" "${SF_OTHER_BUILT_PRODUCTS_DIR}/${SF_EXECUTABLE_PATH}" -output "${A_FOLDER}/${SF_TARGET_NAME}"

find "${BUILT_PRODUCTS_DIR}/Headers" -type f -iname "*.h" | while read -r FILE
do
    mv "${FILE}" "${HEADERS}/$(basename ${FILE})"
done

cd "${FRAMEWORK_FOLDER}"
ln -s "Versions/A" "Versions/Current"
ln -s "Versions/A/Headers" "Headers"
ln -s "Versions/A/${SF_TARGET_NAME}" "${SF_TARGET_NAME}"

# Copy the binary to the other architecture folder to have a complete framework in both.
# cp -a "${BUILT_PRODUCTS_DIR}/${SF_WRAPPER_NAME}/Versions/A/${SF_TARGET_NAME}" "${SF_OTHER_BUILT_PRODUCTS_DIR}/${SF_WRAPPER_NAME}/Versions/A/${SF_TARGET_NAME}"
