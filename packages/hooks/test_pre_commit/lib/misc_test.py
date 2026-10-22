# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
import re
from itertools import chain
from pathlib import Path
from typing import TYPE_CHECKING

import pytest
from fsfe_website_hooks import checks, fixes
from fsfe_website_hooks.checks.stage0_encoding import check_encoding
from fsfe_website_hooks.fixes.stage0_encoding import convert_encoding
from fsfe_website_hooks.lib.misc import load_stages, with_suffixes
from fsfe_website_hooks.run_checks import Check
from fsfe_website_hooks.run_fixes import Fix

if TYPE_CHECKING:
    from types import ModuleType


@pytest.mark.parametrize(
    ("package", "protocol", "first_stage"),
    [(checks, Check, [check_encoding]), (fixes, Fix, [convert_encoding])],
)
def load_stages_test(
    package: ModuleType, protocol: type[Check | Fix], first_stage: list[ModuleType]
) -> None:
    stages = load_stages(package, protocol)
    assert stages[0] == first_stage
    assert all(stages)
    for module in chain.from_iterable(stages):
        for extension in module.ALLOWED_EXTENSIONS:
            assert re.fullmatch(r"\.[a-z]+", extension), module


def load_stages_protocol_mismatch_test() -> None:
    with pytest.raises(TypeError, match="does not match Check"):
        load_stages(fixes, Check)


def with_suffixes_test() -> None:
    files = [Path("a.xhtml"), Path("b.xsl"), Path("c.png")]
    assert with_suffixes(files, {".xhtml", ".xsl"}) == files[:2]
