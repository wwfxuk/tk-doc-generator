#!/bin/bash
# Copyright 2019 Autodesk, Inc.  All rights reserved.
#
# Use of this software is subject to the terms of the Autodesk license agreement
# provided at the time of installation or download, or which otherwise accompanies
# this software in either electronic or hard copy form.
#

# Main Documentation build script
# Syntax:
#
# build_docs --url=TARGET_URL           # url where the docs will live, e..g https://mysite.com
#            --url-path=TARGET_PATH     # target path on doc site, e.g. /developer_docs
#            --source=SOURCE_FOLDER     # source location
#            --output=OUTPUT_FOLDER     # build target. This folder will be deleted by the script.

# exit on error
set -e

# parse command line arguments
for i in "$@"
do
case $i in
    -u=*|--url=*)
    URL="${i#*=}"
    shift # past argument=value
    ;;
    -p=*|--url-path=*)
    URLPATH="${i#*=}"
    shift # past argument=value
    ;;
    -s=*|--source=*)
    SOURCE="${i#*=}"
    shift # past argument=value
    ;;
    -o=*|--output=*)
    OUTPUT="${i#*=}"
    shift # past argument=value
    ;;
    *)
          # unknown option
    ;;
esac
done

echo "---------------------------------------------------"
echo "Shotgun Ecosystem Documentation Build Process"
echo "---------------------------------------------------"
echo "Source:     ${SOURCE}"
echo "Output:     ${OUTPUT}"
echo "Target Url: ${URL}${URLPATH}"
echo "---------------------------------------------------"

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

TK_DOC_GEN_SRC="$(readlink -m ${THIS_DIR}/..)"  # contains Gemfile, jekyll, etc
OUR_REPO_ROOT="$(readlink -m ${SOURCE}/..)"  # user's project root folder

TMP_FOLDER="${TK_DOC_GEN_SRC}/_doc_generator_tmp"
TMP_BUILD_FOLDER="${TMP_FOLDER}/markdown_src"

echo ""
echo "Intermediate files will be written to '${TMP_FOLDER}'."

echo ""
echo "Cleaning out internal build location '${TMP_FOLDER}'..."
rm -rf ${TMP_FOLDER}

echo "Cleaning out final build location '${OUTPUT}'..."
rm -rf ${OUTPUT}

echo "Creating build location '${TMP_BUILD_FOLDER}'..."
mkdir -p ${TMP_BUILD_FOLDER}/_plugins

echo "Copying source files into '${TMP_BUILD_FOLDER}'..."
cp -r ${SOURCE}/* ${TMP_BUILD_FOLDER}

echo "Running Sphinx RST -> Markdown build process..."
python ${THIS_DIR}/build_sphinx.py ${TMP_BUILD_FOLDER}

# Setup additional plugins paths
PLUGINS="${TK_DOC_GEN_SRC}/jekyll/_plugins"
EXTRA_PLUGIN=${TMP_BUILD_FOLDER}/_plugins
if [ -d "${EXTRA_PLUGIN}" ]
then
    echo "Using additional plugins from ${EXTRA_PLUGIN}..."
    PLUGINS="${PLUGINS},${EXTRA_PLUGIN}"
fi

# Setup additional config overrides
CONFIGS="${TK_DOC_GEN_SRC}/jekyll/_config.yml"
OVERRIDE_CONFIG=${OUR_REPO_ROOT}/jekyll_config.yml
if [ -e "${OVERRIDE_CONFIG}" ]
then
    echo "Using override config from ${OVERRIDE_CONFIG}..."
    CONFIGS="${CONFIGS},${OVERRIDE_CONFIG}"
fi

echo "Running Jekyll to generate html from markdown..."
echo
BUNDLE_GEMFILE=${TK_DOC_GEN_SRC}/Gemfile JEKYLL_ENV=production \
    bundle exec jekyll build \
    --baseurl "${URLPATH}" \
    --config "${CONFIGS}" \
    --plugins "${PLUGINS}" \
    --source "${TMP_BUILD_FOLDER}" \
    --destination "${OUTPUT}"

# Local preview_docs.sh (Docker): allow non-root users to modify generated docs
chmod -R 'a+rwX' "${OUTPUT}"
echo "------------------------------------------------------"
echo "Build completed."
echo "------------------------------------------------------"
