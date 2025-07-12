#!/bin/sh

#要build的target名
project_path=$(cd `dirname $0`; pwd)
project_name="${project_path##*/}"
TARGET_NAME=${project_name}
echo "\033[31m target name = ${TARGET_NAME} \033[0m"
FRAMEWORK_NAME="${TARGET_NAME}.framework"
XCFRAMEWORK_NAME="${TARGET_NAME}.xcframework"
WORKSPACE_NAME="${TARGET_NAME}.xcworkspace"
# sdk 编译过程的输出文件路径
WRK_DIR=./build

if [[ $1 ]]
then
TARGET_NAME=$1
fi
currunt_dir=$(pwd)
UNIVERSAL_OUTPUT_FOLDER="${currunt_dir}/Products"
UNIVERSAL_OUTPUT_XCPATH="${UNIVERSAL_OUTPUT_FOLDER}/${XCFRAMEWORK_NAME}"

echo "\033[31m current path = ${currunt_dir} \033[0m"
echo "\033[31m framework path = ${UNIVERSAL_OUTPUT_XCPATH} \033[0m"

#创建输出目录，并删除之前的framework文件
mkdir -p "${UNIVERSAL_OUTPUT_FOLDER}"
rm -rf "${UNIVERSAL_OUTPUT_XCPATH}"

echo "\033[31m clean start \033[0m"
#分别编译模拟器和真机的Framework
xcodebuild -workspace "${WORKSPACE_NAME}" -scheme "${TARGET_NAME}" -sdk iphoneos -configuration "Release" clean
xcodebuild -workspace "${WORKSPACE_NAME}" -scheme "${TARGET_NAME}" -sdk iphonesimulator -configuration "Release" clean
xcodebuild -workspace "${WORKSPACE_NAME}" -scheme "${TARGET_NAME}" -destination 'platform=macOS,arch=x86_64,variant=Mac Catalyst' -configuration "Release" clean
echo "\033[31m clean finished \033[0m"

# 创建build
echo "\033[31m build start \033[0m"
echo "\033[31m build iPhoneOS \033[0m"
xcodebuild -workspace "${WORKSPACE_NAME}" -scheme "${TARGET_NAME}" -sdk iphoneos -configuration "Release" build

echo "\033[31m build iPhoneSimulator \033[0m"
xcodebuild -workspace "${WORKSPACE_NAME}" -scheme "${TARGET_NAME}" -sdk iphonesimulator -configuration "Release" build

echo "\033[31m build mac catalyst \033[0m"
xcodebuild -workspace "${WORKSPACE_NAME}" -scheme "${TARGET_NAME}" -destination 'platform=macOS,arch=x86_64,variant=Mac Catalyst' -configuration "Release" build

echo "\033[31m build finished \033[0m"

# 获取build目录
FULL_BUILD_PATH=$(xcodebuild -workspace "${WORKSPACE_NAME}" -scheme "${TARGET_NAME}" -showBuildSettings | grep " BUILD_DIR")
echo "\033[31m ${FULL_BUILD_PATH} \033[0m"
ARR=($FULL_BUILD_PATH)
echo "\033[31m ${ARR[0]}:${ARR[1]}:${ARR[2]} \033[0m"

BUILD_PATH=${ARR[2]}
echo "\033[31m BUILD_PATH=$BUILD_PATH \033[0m"

#合并framework，输出最终的framework到build目录

IPHONEOS_BUILD_PATH=${BUILD_PATH}"/Release-iphoneos/"${FRAMEWORK_NAME}
IPHONESIMULATOR_BUILD_PATH=${BUILD_PATH}"/Release-iphonesimulator/"${FRAMEWORK_NAME}
MAC_CATALYST_BUILD_PATH=${BUILD_PATH}"/Release-maccatalyst/"${FRAMEWORK_NAME}

# 合并xcFramework
echo "\033[31m start create-xcframework \033[0m"
xcodebuild -create-xcframework -framework ${IPHONEOS_BUILD_PATH} -framework ${IPHONESIMULATOR_BUILD_PATH} -framework ${MAC_CATALYST_BUILD_PATH} -output "${UNIVERSAL_OUTPUT_XCPATH}"
echo "\033[31m finish create-xcframework \033[0m"

echo "\033[31m clean start \033[0m"
xcodebuild -workspace "${WORKSPACE_NAME}" -scheme "${TARGET_NAME}" -sdk iphoneos -configuration "Release" clean
xcodebuild -workspace "${WORKSPACE_NAME}" -scheme "${TARGET_NAME}" -sdk iphonesimulator -configuration "Release" clean
xcodebuild -workspace "${WORKSPACE_NAME}" -scheme "${TARGET_NAME}" -destination 'platform=macOS,arch=x86_64,variant=Mac Catalyst' -configuration "Release" clean
echo "\033[31m clean finished \033[0m"