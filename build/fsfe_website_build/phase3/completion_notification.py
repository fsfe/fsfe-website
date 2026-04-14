# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later
"""Send notification on completion."""

import asyncio
import logging

from fsfe_website_build.globals import APP_NAME

logger = logging.getLogger(__name__)


def completion_notification() -> None:
    """Send a completion notification."""
    try:
        from desktop_notifier import DEFAULT_SOUND, DesktopNotifier  # noqa: PLC0415

        notifier = DesktopNotifier(app_name=APP_NAME)
        asyncio.run(
            notifier.send(
                title="Website Build Complete",
                message="Current build finished successfully.",
                sound=DEFAULT_SOUND,
            )
        )
    except ImportError:
        logger.warning("desktop-notifier is not available. Skipping playing sound.")
