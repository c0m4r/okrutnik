#!/usr/bin/env bash

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

# Version
VERSION=2.1.0

# Toolset
TOOLSET="bandit black codespell mypy pylint pyright pylama ruff safety"

# Base dir
BASEDIR=$(dirname "$0")

# Okrutnik venv location
VENV="${BASEDIR}/.okrutnik_venv"

# Args
ARG1=$1
ARG2=$2

# Colors
ORANGE='\e[1;33m'
GREEN='\e[1;32m'
CYAN='\e[1;36m'
RED='\e[1;31m'
ENDCOLOR="\e[0m"

# Defaults
TOOLS_NUM=8
ITERATION=1
PASSED=0
FAILED=0

# --------------------------------------------
# Functions
# --------------------------------------------

# Print something
print() {
    echo -e "${ORANGE}${1}${ENDCOLOR}"
}

# Pass or fail check
pass() {
    if [[ $? -eq 0 ]]; then
        echo -e "-> ${GREEN}pass${ENDCOLOR}"
        PASSED=$(( $PASSED + 1 ))
    else
        echo -e "-> ${RED}your code sucks${ENDCOLOR}"
        FAILED=$(( $FAILED + 1))
    fi

    ITERATION=$(( $ITERATION + 1 ))
}

# Install tools
okrutnik_install() {
    okrutnik_which_python
    echo -e "${CYAN}Connecting to an intergalactic relay${ENDCOLOR} 📡"
    $PYTHON_BIN -m venv ${VENV}
    PATH="${VENV}/bin:${PATH}"
    source ${VENV}/bin/activate    
    okrutnik_which_pip
    ${PIP} install --upgrade pip setuptools wheel
    ${PIP} install --upgrade ${TOOLSET}
    echo -e "${CYAN}Receiving communication...${ENDCOLOR}"
    echo -e "-> ${GREEN}All your base are belong to us${ENDCOLOR} 👽"
}

okrutnik_uninstall() {
    if [[ "${VENV}" ]] && [[ -d ${VENV} ]]; then
        echo -n "${VENV} will be removed, "
        read -r -p "are you sure? (y/N): " response \
            && [[ $response == [yY] ]] \
            || exit 1
        rm -rv "${VENV}"
    else
        echo "Nothing to do. Already uninstalled."
    fi
}

# Pip finder function
okrutnik_which_pip() {
    if [[ -e ${VENV}/bin/pip3 ]]; then
        PIP="pip3"
    else
        PIP="pip"
    fi
}

# Python finder function
okrutnik_which_python() {
    if command -v python3 &>/dev/null ; then
        PYTHON_BIN="python3"
    elif command -v python &>/dev/null ; then
        PYTHON_BIN="python"
    elif which python3 &>/dev/null ; then
        PYTHON_BIN="python3"
    elif which python &>/dev/null ; then
        PYTHON_BIN="python"
    else
        echo "Python not found"
        exit 1
    fi
}

# --------------------------------------------
# Validation / args handling
# --------------------------------------------

echo -e "${ORANGE}Okrutnik v${VERSION} by c0m4r${ENDCOLOR}"

# Check args
if [[ "$ARG1" == "-h" ]] || [[ "$ARG1" == "--help" ]]; then
    echo "Usage: ./okrutnik.sh [options] <target>"
    echo ""
    echo "Before <target>:"
    echo " -s, --stop       Exit on failed linters or errors"    
    echo ""
    echo "Standalone:"
    echo " -h, --help       Print this help message"
    echo " --update         Update installed tools"
    echo " --uninstall      Remove installed tools"
    exit 0
elif [[ "$ARG1" == "--update" ]]; then
    okrutnik_install
    exit 0
elif [[ "$ARG1" == "--install" ]]; then
    okrutnik_install
    exit 0
elif [[ "$ARG1" == "--uninstall" ]]; then
    okrutnik_uninstall
    exit 0
elif [[ ! "$ARG1" ]]; then
    echo "Missing <target>"
    exit 1
else
    TARGET=$*
fi

# Check venv
if [[ -e ${VENV}/pyvenv.cfg ]]; then
    PATH="${VENV}/bin:${PATH}"
else
    okrutnik_install
fi

# --------------------------------------------
# Safety check
# --------------------------------------------

if [[ "$ARG1" == "--safety" ]]; then
    safety check
    exit $?
fi

# --------------------------------------------
# Linters
# --------------------------------------------

# Print Python version
okrutnik_which_python
${PYTHON_BIN} -V

# Switch exit on failed
if [[ "$ARG1" == "--stop" ]]; then
    TARGET=$(echo $@ | sed -e 's/\-\-stop\ //g;')
    set -e
fi

# Print targets
echo "Target(s): ${TARGET}"

# Ruff
print "ruff (${ITERATION}/${TOOLS_NUM})"
ruff -v $TARGET ; pass

# codespell
print "codespell (${ITERATION}/${TOOLS_NUM})"
codespell --skip "./*venv*" --skip "./lib/python*" $TARGET ; pass

# pylama
print "pylama (${ITERATION}/${TOOLS_NUM})"
pylama -v $TARGET ; pass

# mypy
print "mypy (${ITERATION}/${TOOLS_NUM})"
mypy --install-types --non-interactive --strict $TARGET ; pass

# pylint
print "pylint (${ITERATION}/${TOOLS_NUM})"
echo "W0718: (broad-exception-caught) is disabled"
pylint --disable W0718 $TARGET ; pass

# pyright
print "pyright (${ITERATION}/${TOOLS_NUM})"
pyright $TARGET ; pass

# bandit
print "bandit (${ITERATION}/${TOOLS_NUM})"
bandit --quiet $TARGET ; pass

# --------------------------------------------
# Formatter
# --------------------------------------------

# black
print "black (${ITERATION}/${TOOLS_NUM})"
black --diff --color $TARGET
black -q $TARGET ; pass

# --------------------------------------------
# Summary
# --------------------------------------------

PERCENT=$(echo $PASSED $TOOLS_NUM \
    | awk '{ quotient = $1 / $2 * 100 ; print int(quotient) }')

print "summary"
echo -e "-> ${PASSED}/${TOOLS_NUM} (${PERCENT}%)"

if [[ $PERCENT -lt 30 ]]; then
    echo -e "-> ${RED}do you even code?${ENDCOLOR} 😂"
elif [[ $PERCENT -lt 50 ]]; then
    echo -e "-> ${RED}damn, your code really sucks${ENDCOLOR} 🙄"
elif [[ $PERCENT -lt 70 ]]; then
    echo -e "-> ${RED}still sucks...${ENDCOLOR} 🙃"
elif [[ $PERCENT -lt 100 ]]; then
    echo -e "-> ${ORANGE}almost there${ENDCOLOR} 🤔"
else
    echo -e "-> ${GREEN}too easy${ENDCOLOR} 😎"
fi
