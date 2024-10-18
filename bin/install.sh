#!/usr/bin/env bash

# change directory to project root
ROOT="$(dirname $0)/.."
cd "${ROOT}"

# ignore warnings about py2 end of life
export PYTHONWARNINGS="ignore:DEPRECATION"
export PYTHONDONTWRITEBYTECODE=1

# check for python
if [[ ! -x "$(command -v python2)" ]]; then
  echo "python2 and/or python3 not found/installed"
  exit 1
fi

# remove any existing .venv activation script and re-create
deactivate 2>/dev/null
rm -rf .venv/bin/activate
pip -qq install virtualenv
virtualenv -qq .venv

CLOUDSDK_PYTHON=${ROOT}/.venv/bin/python

# this section installs the google cloud sdk which is required for connecting to datastore and emulating it locally
OS='darwin'
[[ $(uname -r | sed -n 's/.*\( *Microsoft *\).*/\1/ip') ]] ||
[[ $(uname -a | sed -n 's/.*\( *Linux *\).*/\1/ip') ]] && OS='linux'

if [[ ! -d "${ROOT}/.venv/google-cloud-sdk" ]]; then
  echo "Google Cloud SDK directory not found.  Downloading and installing google-cloud-sdk now."
  [[ $(uname -m) == 'arm64' ]] && ARCH='arm' || ARCH='x86_64'
  curl -# -L https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-426.0.0-${OS}-${ARCH}.tar.gz | tar xzf - -C ${ROOT}/.venv
  if [[ $OS = "darwin" ]]; then
    sed -i '' 's/"\$CLOUDSDK_PYTHON" \$CLOUDSDK_PYTHON_ARGS/"\$CLOUDSDK_PYTHON"/g' ${ROOT}/.venv/google-cloud-sdk/install.sh
  else
    sed -i 's/"\$CLOUDSDK_PYTHON" \$CLOUDSDK_PYTHON_ARGS/"\$CLOUDSDK_PYTHON"/g' ${ROOT}/.venv/google-cloud-sdk/install.sh
  fi
  ${ROOT}/.venv/google-cloud-sdk/install.sh --usage-reporting=false --path-update=false -q 1>/dev/null 2>&1
fi

# activate virtual environment (venv)
source .venv/bin/activate

# in order to run testst locally, we need simulate datastore which requires these google deps
echo "gcloud components install app-engine-python-extras..."
${ROOT}/.venv/google-cloud-sdk/bin/gcloud components install app-engine-python-extras -q 2> /dev/null
echo "gcloud components install cloud-datastore-emulator..."
${ROOT}/.venv/google-cloud-sdk/bin/gcloud components install cloud-datastore-emulator -q 2> /dev/null
echo "gcloud components install beta..."
${ROOT}/.venv/google-cloud-sdk/bin/gcloud components install beta -q 2> /dev/null

# install python deps
pip2 install -qq -r requirements.txt

echo "virtual environment created at ${ROOT}/.venv (Python 2.7; Google Cloud SDK 426.0.0) and activated"
