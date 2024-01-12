#!/usr/bin/env bash
set -e

# Okrutnik: a bash script that helps you write correct Python code
# Copyright (C) 2024 c0m4r
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# --------------------------------------------
# Vars
# --------------------------------------------

BASEDIR=$(dirname "$0")
VERSION=1.0.8

ARG=$1
ARG2=$2
PYENV=false

ORANGE='\e[1;33m'
GREEN='\e[1;32m'
ENDCOLOR="\e[0m"

# Check venv
if [ -e ${BASEDIR}/pyvenv.cfg ]; then
    PIP="${BASEDIR}/bin/pip"
    PATH="${BASEDIR}/bin:${PATH}"
elif [ -e ${BASEDIR}/venv/pyvenv.cfg ]; then
    PIP="${BASEDIR}/venv/bin/pip"
    PATH="${BASEDIR}/venv/bin:${PATH}"
elif [ -e ${BASEDIR}/.venv/pyvenv.cfg ]; then
    PIP="${BASEDIR}/.venv/bin/pip"
    PATH="${BASEDIR}/.venv/bin:${PATH}"
else
    PIP="pip"
fi

# --------------------------------------------
# Functions
# --------------------------------------------

init() {
    echo -e "${ORANGE}${1}${ENDCOLOR}"
}

pass() {
    echo -e "-> ${GREEN}pass${ENDCOLOR}"
    ITERATION=$(( $ITERATION + 1 ))
}

install() {
    echo ${PIP}
    ${PIP} install bandit black codespell mypy pylint pyright pylama ruff
}

# --------------------------------------------
# Validation / args handling
# --------------------------------------------

set +e

# Check args
if [[ "$ARG" == "--help" ]]; then
    init "Okrutnik v${VERSION}"
    echo "Usage: ./okrutnik.sh TARGET [--ignore]"
    exit 0
elif [[ "$ARG" == "--version" ]]; then
    init "Okrutnik v${VERSION}"
    exit 0
elif [[ "$ARG" == "--install" ]]; then
    install
    exit 0
elif [[ ! "$ARG" ]]; then
    echo "Missing TARGET"
    exit 1
elif [[ ! -e $ARG ]]; then
    echo "TARGET $ARG not found"
    exit 1
else
    TARGET=$1
fi

set -e

TOOLS_NUM=8
ITERATION=1

init "Okrutnik v${VERSION} by c0m4r"

# --------------------------------------------
# Linters
# --------------------------------------------

if [[ "$ARG2" == "--ignore" ]]; then
    set +e
fi

# ruff 0.1.12 bug workaround
# https://github.com/astral-sh/ruff/issues/9478
mkdir -p .ruff_cache/0.1.12

# Ruff
init "ruff (${ITERATION}/${TOOLS_NUM})"
ruff $TARGET ; pass

# codespell
init "codespell (${ITERATION}/${TOOLS_NUM})"
codespell --skip "./lib/python*" $TARGET ; pass

# pylama
init "pylama  (${ITERATION}/${TOOLS_NUM})"
pylama $TARGET
pylama --ignore C901 $TARGET ; pass

# mypy
init "mypy (${ITERATION}/${TOOLS_NUM})"
mypy --install-types --non-interactive --strict $TARGET ; pass

# pylint
init "pylint (${ITERATION}/${TOOLS_NUM})"
pylint --disable W0718 $TARGET ; pass

# pyright
init "pyright (${ITERATION}/${TOOLS_NUM})"
pyright $TARGET ; pass

# bandit
init "bandit (${ITERATION}/${TOOLS_NUM})"
bandit --quiet $TARGET ; pass

# --------------------------------------------
# Formatter
# --------------------------------------------

# black
init "black (${ITERATION}/${TOOLS_NUM})"
black --diff --color $TARGET
black -q $TARGET ; pass
