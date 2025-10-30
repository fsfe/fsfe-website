# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Phase 1 logic.

This phase should not touch the target directory.

It should only update the slurce directory with gitignored setup stuff.
All files should be updated conditioannly on it being changed.
This ensures proper build caching for stage 2.
"""
