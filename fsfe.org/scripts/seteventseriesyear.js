/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2020 Free Software Foundation Europe <https://fsfe.org>
*/
(function () {
    function applyYear() {
        var field = document.querySelector('input[name="eventseriesyear"]');
        if (!field) return;
        field.value = String(new Date().getFullYear());
    }

    if (document.readyState === 'interactive' || document.readyState === 'complete') {
        applyYear();
    } else {
        window.addEventListener('load', applyYear, { once: true });
    }
})();