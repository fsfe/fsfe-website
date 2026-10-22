# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
"""Check that the passed files have the correct ratio for images."""

import io
import logging
import re
import textwrap
from typing import TYPE_CHECKING

import requests
from lxml import etree
from PIL import Image

if TYPE_CHECKING:
    import multiprocessing.pool
    from pathlib import Path

logger = logging.getLogger(__name__)

CHECK_TYPE = "critical"
ALLOWED_EXTENSIONS = {".xhtml", ".xml"}


def _check_image_ratio(image_bytes: bytes) -> bool:
    with Image.open(io.BytesIO(image_bytes)) as img:
        width, height = img.size

    ideal_ratio = 16 / 9
    actual_ratio = width / height

    tolerance = 0.005 * ideal_ratio
    return (ideal_ratio - tolerance) <= actual_ratio <= (ideal_ratio + tolerance)


def check(files: list[Path], pool: multiprocessing.pool.Pool) -> tuple[bool, str]:  # noqa: ARG001
    """Check for if images have the right ratio."""
    fileregex = re.compile(r"^fsfe.org/(news/|events/).*")
    failed_files: list[str] = []
    for file in [file for file in files if fileregex.match(str(file))]:
        for imageurl in etree.parse(file).xpath("//image/@url"):
            # the url may be to a remote or local image
            is_remote = imageurl.startswith(("http://", "https://"))
            image = b""
            if is_remote:
                response = requests.get(imageurl, timeout=10)
                if not response.ok:
                    message = "Failed to fetch image"
                    logger.error(message)
                    raise RuntimeError(message)
                image: bytes = response.content
            else:
                # we should not be committing news or events files
                # with images in repo anymore
                # and figuring out how to open paths correctly is
                # actually a little tricky
                # so not implementing this for now, and can be done later if needed
                message = "Image ratio check requires remote images"
                logger.error(message)
                raise RuntimeError(message)
            if not _check_image_ratio(image):
                failed_files.append(f"{file} has {imageurl=} with invalid ratio")

    return len(failed_files) == 0, (
        "\n".join(failed_files)
        + textwrap.dedent("""
          16:9 ratio for preview is mandatory for news items.

          More information on preview images:
          https://docs.fsfe.org/en/techdocs/mainpage/editing/bestpractices#preview-image""")
    )
