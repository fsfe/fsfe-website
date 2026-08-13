// This file contains JavaScript for the carousel in the community section on the frontpage

document.addEventListener('DOMContentLoaded', function () {
  var carousel = document.querySelector('.carousel');
  var slides = Array.prototype.slice.call(carousel.querySelectorAll('.slide'));
  var current = slides.findIndex(function (s) { return s.classList.contains('is-active'); });
  if (current === -1) current = 0;

  var autoplayId = null;
  var isPlaying = true;
  var AUTOPLAY_MS = 5000;

  // Helper: crea un <span class="visuallyhidden">texto</span> sin usar innerHTML
  function hiddenSpan(text) {
    var span = document.createElement('span');
    span.className = 'visuallyhidden';
    span.textContent = text;
    return span;
  }

  // --- Live region: anuncia el cambio de slide a lectores de pantalla ---
  var liveregion = document.createElement('div');
  liveregion.setAttribute('aria-live', 'polite');
  liveregion.setAttribute('aria-atomic', 'true');
  liveregion.className = 'liveregion visuallyhidden';
  carousel.appendChild(liveregion);

  function announce() {
    liveregion.textContent = 'Elemento ' + (current + 1) + ' de ' + slides.length;
  }

  // --- Mostrar un slide concreto ---
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
        var hint = hiddenSpan(' (elemento actual)');
        hint.classList.add('current-hint');
        btn.appendChild(hint);
      }
    });

    // El foco solo se mueve cuando el usuario elige un slide con los puntos de navegación,
    // nunca durante el avance automático ni con prev/next
    if (moveFocus) {
      slides[current].setAttribute('tabindex', '-1');
      slides[current].focus();
    }
  }

  function nextSlide() { goTo(current + 1, false); }
  function prevSlide() { goTo(current - 1, false); }

  // --- Autoplay, pausable (WCAG 2.2.2) ---
  function startAutoplay() {
    autoplayId = window.setInterval(nextSlide, AUTOPLAY_MS);
    isPlaying = true;
  }

  function stopAutoplay() {
    window.clearInterval(autoplayId);
    isPlaying = false;
  }

  // --- Botones anterior / siguiente ---
  var ctrls = document.createElement('ul');
  ctrls.className = 'controls';

  var prevLi = document.createElement('li');
  var prevBtn = document.createElement('button');
  prevBtn.type = 'button';
  prevBtn.className = 'btn-prev';
  prevBtn.appendChild(hiddenSpan('Elemento anterior'));
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
  nextBtn.appendChild(hiddenSpan('Elemento siguiente'));
  nextBtn.appendChild(document.createTextNode('\u2192')); // →
  nextBtn.addEventListener('click', function () {
    stopAutoplay();
    nextSlide();
  });
  nextLi.appendChild(nextBtn);

  ctrls.appendChild(prevLi);
  ctrls.appendChild(nextLi);
  carousel.appendChild(ctrls);

  // --- Botón de pausa/reproducción del autoplay ---
  var pauseBtn = document.createElement('button');
  pauseBtn.type = 'button';
  pauseBtn.className = 'btn-pause';

  function renderPauseState() {
    while (pauseBtn.firstChild) pauseBtn.removeChild(pauseBtn.firstChild);
    if (isPlaying) {
      pauseBtn.appendChild(hiddenSpan('Pausar'));
      pauseBtn.appendChild(document.createTextNode('\u23F8')); // ⏸
    } else {
      pauseBtn.appendChild(hiddenSpan('Reproducir'));
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

  // --- Navegación por puntos (una por cada elemento) ---
  var nav = document.createElement('ul');
  nav.className = 'slidenav';
  slides.forEach(function (slide, i) {
    var li = document.createElement('li');
    var btn = document.createElement('button');
    btn.type = 'button';
    btn.setAttribute('data-slide', String(i));
    btn.appendChild(hiddenSpan('Ir al elemento ' + (i + 1)));
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
