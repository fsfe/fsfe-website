 /*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2020 Free Software Foundation Europe <https://fsfe.org>
*/

/*
 * This script allows to build a carousel of pictures
 * It is being used on fsfe.org/index currently on "Or Community" section
*/

document.addEventListener('DOMContentLoaded', function () {
  var carousel = document.querySelector('.carousel');
  var slides = Array.prototype.slice.call(carousel.querySelectorAll('.slide'));
  var current = slides.findIndex(function (s) { return s.classList.contains('is-active'); });
  if (current === -1) current = 0;

  var autoplayId = null;
  var isPlaying = true;
  var AUTOPLAY_MS = 5000;

  // Helper: creates a <span class="visuallyhidden">text</span> without using innerHTML
  function hiddenSpan(text) {
    var span = document.createElement('span');
    span.className = 'visuallyhidden';
    span.textContent = text;
    return span;
  }

  // --- Live region: announces a slide change to screen readers ---
  var liveregion = document.createElement('div');
  liveregion.setAttribute('aria-live', 'polite');
  liveregion.setAttribute('aria-atomic', 'true');
  liveregion.className = 'liveregion visuallyhidden';
  carousel.appendChild(liveregion);

  function announce() {
    liveregion.textContent = 'Item ' + (current + 1) + ' of ' + slides.length;
  }

  // --- Show a specific slide ---
  function goTo(index, moveFocus) {
    slides[current].classList.remove('is-active');
    current = (index + slides.length) % slides.length;
    slides[current].classList.add('is-active');

    announce();

    var navButtons = carousel.querySelectorAll('.slidenav button');
    navButtons.forEach(function (btn, i) {
      btn.classList.toggle('current', i === current);
      var oldHint = btn.querySelector('.current-hint');
      if (oldHint) btn.removeChild(oldHint);
      if (i === current) {
        var hint = hiddenSpan(' (current item)');
        hint.classList.add('current-hint');
        btn.appendChild(hint);
      }
    });

    if (moveFocus) {
      slides[current].setAttribute('tabindex', '-1');
      slides[current].focus();
    }
  }

  function nextSlide() { goTo(current + 1, false); }
  function prevSlide() { goTo(current - 1, false); }

  // --- Autoplay, pausable ---
  function startAutoplay() {
    autoplayId = window.setInterval(nextSlide, AUTOPLAY_MS);
    isPlaying = true;
  }

  function stopAutoplay() {
    window.clearInterval(autoplayId);
    isPlaying = false;
  }

  // --- Previous / Next buttons ---
  var ctrls = document.createElement('ul');
  ctrls.className = 'controls';

  var prevLi = document.createElement('li');
  var prevBtn = document.createElement('button');
  prevBtn.type = 'button';
  prevBtn.className = 'btn-prev';
  prevBtn.appendChild(hiddenSpan('previous item'));
  prevBtn.appendChild(document.createTextNode('\u2190')); // ←
  prevBtn.addEventListener('click', function () {
    stopAutoplay();
    prevSlide();
  });
  prevLi.appendChild(prevBtn);

  var nextLi = document.createElement('li');
  var nextBtn = document.createElement('button');
  nextBtn.type = 'button';
  nextBtn.className = 'btn-next';
  nextBtn.appendChild(hiddenSpan('next item'));
  nextBtn.appendChild(document.createTextNode('\u2192')); // →
  nextBtn.addEventListener('click', function () {
    stopAutoplay();
    nextSlide();
  });
  nextLi.appendChild(nextBtn);

  ctrls.appendChild(prevLi);
  ctrls.appendChild(nextLi);
  carousel.appendChild(ctrls);

  // --- Autoplay pause/play button ---
  var pauseBtn = document.createElement('button');
  pauseBtn.type = 'button';
  pauseBtn.className = 'btn-pause';

  function renderPauseState() {
    while (pauseBtn.firstChild) pauseBtn.removeChild(pauseBtn.firstChild);
    if (isPlaying) {
      pauseBtn.appendChild(hiddenSpan('Pause'));
      pauseBtn.appendChild(document.createTextNode('\u23F8')); // ⏸
    } else {
      pauseBtn.appendChild(hiddenSpan('Play'));
      pauseBtn.appendChild(document.createTextNode('\u25B6')); // ▶
    }
  }

  pauseBtn.addEventListener('click', function () {
    if (isPlaying) {
      stopAutoplay();
    } else {
      startAutoplay();
    }
    renderPauseState();
  });
  carousel.appendChild(pauseBtn);
  renderPauseState();

  // --- Point-based navigation (one per item) ---
  var nav = document.createElement('ul');
  nav.className = 'slidenav';
  slides.forEach(function (slide, i) {
    var li = document.createElement('li');
    var btn = document.createElement('button');
    btn.type = 'button';
    btn.setAttribute('data-slide', String(i));
    btn.appendChild(hiddenSpan('Go to the item ' + (i + 1)));
    if (i === current) btn.classList.add('current');
    btn.addEventListener('click', function () {
      stopAutoplay();
      goTo(i, true);
    });
    li.appendChild(btn);
    nav.appendChild(li);
  });
  carousel.appendChild(nav);

  startAutoplay();
});
