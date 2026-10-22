# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Helpers shared by the hooks."""

import importlib
import pkgutil
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from types import ModuleType


def load_modules[T](package: ModuleType, protocol: type[T]) -> list[T]:
    """Import every module of the package, each of which must match the protocol."""
    modules: list[T] = []
    for info in pkgutil.iter_modules(package.__path__):
        module = importlib.import_module(f"{package.__name__}.{info.name}")
        # isinstance only checks the protocol's names exist, not their types.
        if not isinstance(module, protocol):
            message = f"{module.__name__} does not match {protocol.__name__}"
            raise TypeError(message)
        modules.append(module)
    return modules
