#!/usr/bin/env bash

# change directory to project root
ROOT="$(dirname $0)/.."
cd "${ROOT}"

# check for virtual environment (venv) and activate
[[ ! -f .venv/bin/activate ]] && echo "virtual environment not found" && exit 1
source .venv/bin/activate

# start app with python
python -m main
