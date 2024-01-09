# Okrutnik

Okrutnik ([/ɔkrutɲik/](https://www.youtube.com/watch?v=JaEWtfozcSk)) - a bash script that helps you write correct Python code.

It can also ruin your day by letting you know how much your code sucks.

So like... enjoy.

## Deps

[bandit](https://bandit.readthedocs.io/) | [black](https://github.com/psf/black) | [codespell](https://github.com/codespell-project/codespell) | [mypy](https://mypy.readthedocs.io/) | [pylama](https://github.com/klen/pylama) | [pylint](https://github.com/pylint-dev/pylint) | [pyright](https://github.com/microsoft/pyright) | [ruff](https://github.com/astral-sh/ruff)

## Installation

Just put it where your project is and install required modules:

```
./okrutnik.sh --install
```

## Usage

```
./okrutnik.sh TARGET
```

It will reformat your code by default, make a backup or comment out black

## Screenshot

<div align="center">

![image](https://github.com/c0m4r/okrutnik/assets/6292788/667464d6-bbf2-4011-bddb-e3234b66b758)

</div>
