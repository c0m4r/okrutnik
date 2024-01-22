# Okrutnik

![linux](https://img.shields.io/badge/Linux-bash-%23777BB4?logo=linux&logoColor=ffffff)
![Python](https://img.shields.io/badge/Python-lint/format-blue?logo=python&logoColor=ffffff)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![okrutnik](https://github.com/c0m4r/okrutnik/actions/workflows/okrutnik.yml/badge.svg)](https://github.com/c0m4r/okrutnik/actions/workflows/okrutnik.yml)
[![CodeFactor](https://www.codefactor.io/repository/github/c0m4r/okrutnik/badge)](https://www.codefactor.io/repository/github/c0m4r/okrutnik)

Okrutnik ([/ɔkrutɲik/](https://www.youtube.com/watch?v=JaEWtfozcSk)) - a bash script that helps you write correct Python code.

It can also ruin your day by letting you know how much your code sucks.

So like... enjoy.

<div align="center">

![o2](https://github.com/c0m4r/okrutnik/assets/6292788/11ef392b-1be8-4ff6-b6c9-2ab6603e7cc4)

</div>

## 📦 Deps

It uses a bundle of different linters and a code formatter:

[bandit](https://bandit.readthedocs.io/) 
| [black](https://github.com/psf/black) 
| [codespell](https://github.com/codespell-project/codespell) 
| [mypy](https://mypy.readthedocs.io/) 
| [pylama](https://github.com/klen/pylama) 
| [pylint](https://github.com/pylint-dev/pylint) 
| [pyright](https://github.com/microsoft/pyright) 
| [ruff](https://github.com/astral-sh/ruff)

## 💾 Installation

Download

```
wget https://raw.githubusercontent.com/c0m4r/okrutnik/main/okrutnik.sh
chmod +x okrutnik.sh
```

Just put it where your project is and install the required modules:

```
./okrutnik.sh --install
```

Include custom modules used in your project with `-r requirements.txt`:

```
./okrutnik.sh --install -r requirements.txt
```

Okrutnik will create a virtual Python environment in .okrutnik_venv for itself and store its tools in order to perform a scan.

You can `--update` or `--uninstall` them at any time.

## 🚀 Usage

```
./okrutnik.sh target.py
```

To stop on failed linters or errors:

```
./okrutnik.sh --stop target.py
```

**Be advised**: it will reformat your code by default. Make a backup or comment out black before use.

```
Usage: ./okrutnik.sh [options] <target>

Before <target>:
 -s, --stop       Exit on failed linters or errors

Standalone:
 -h, --help       Print this help message
 --update         Update installed tools
 --uninstall      Remove installed tools
 --safety         Run safety check
```

## 📜 License

> Okrutnik: a bash script that helps you write correct Python code\
> Copyright (C) 2024 c0m4r
>
> This program is free software: you can redistribute it and/or modify\
> it under the terms of the GNU General Public License as published by\
> the Free Software Foundation, either version 3 of the License, or\
> (at your option) any later version.
>
> This program is distributed in the hope that it will be useful,\
> but WITHOUT ANY WARRANTY; without even the implied warranty of\
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\
> GNU General Public License for more details.
>
> You should have received a copy of the GNU General Public License\
> along with this program.  If not, see <https://www.gnu.org/licenses/>.

## 💸 Funding

If you found this script helpful, please consider [making a donation](https://en.wosp.org.pl/fundacja/jak-wspierac-wosp/wesprzyj-online) to a charity on my behalf. Thank you.
