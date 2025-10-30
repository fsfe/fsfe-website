# SPDX-FileCopyrightText: Free Software Foundation Europe e.V. <https://fsfe.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Lib functions used across the builder and external consumers.

All files here are held to a higher quality than the rest of the builder.
They should all be properly typehinted and commented.
It is considered safe to use them in subdirectory scripts, and CI scripts.

They are the only functions whose interface should not change.
"""
