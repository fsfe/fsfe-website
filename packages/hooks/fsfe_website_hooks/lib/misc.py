# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Helpers shared by the hooks."""

import importlib
import pkgutil
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from pathlib import Path
    from types import ModuleType


def is_utf8(content: bytes) -> bool:
    """Whether the bytes decode as UTF-8."""
    try:
        content.decode("utf-8")
    except UnicodeDecodeError:
        return False
    return True


def with_suffixes(files: list[Path], suffixes: set[str]) -> list[Path]:
    """Keep the files whose suffix is one of the suffixes."""
    return [file for file in files if file.suffix in suffixes]


def _load_modules[T](package: ModuleType, protocol: type[T]) -> list[T]:
    modules: list[T] = []
    # iter_modules yields names sorted, which orders the stages and their modules.
    for info in pkgutil.iter_modules(package.__path__):
        module = importlib.import_module(f"{package.__name__}.{info.name}")
        # isinstance only checks the protocol's names exist, not their types.
        if not isinstance(module, protocol):
            message = f"{module.__name__} does not match {protocol.__name__}"
            raise TypeError(message)
        modules.append(module)
    return modules


def load_stages[T](package: ModuleType, protocol: type[T]) -> list[list[T]]:
    """Import the modules of each stage subpackage, in name order.

    Every module must match the protocol.
    """
    return [
        _load_modules(
            importlib.import_module(f"{package.__name__}.{stage.name}"), protocol
        )
        for stage in pkgutil.iter_modules(package.__path__)
    ]
