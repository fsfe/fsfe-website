/**
 * This is an implementation of the placeholder="" attribute as
 * implemented in WebKit.
 *
 * Suggested styling: input[_placeholder_on] { color:GrayText; }
 *
 * Written by Simon Pieters.
 * Modified by Andreas Tolf Tolfsen <ato@fsfe.org>.
 */

if (!HTMLInputElement.prototype.__lookupGetter__("placeholder")) {
  HTMLInputElement.prototype.__defineGetter__("placeholder", function() {
    return this.getAttribute("placeholder");
  });
  HTMLInputElement.prototype.__defineSetter__("placeholder", function(value) {
    this.setAttribute("placeholder", value);
  });

  function isTextField(elm) {
    if (!(elm instanceof HTMLInputElement))
      return false;
    return (elm.type != "checkbox" && 
            elm.type != "radio" &&
            elm.type != "button" &&
            elm.type != "submit" &&
            elm.type != "reset" &&
            elm.type != "add" &&
            elm.type != "remove" &&
            elm.type != "move-up" &&
            elm.type != "move-down" &&
            elm.type != "file" &&
            elm.type != "hidden" &&
            elm.type != "image" &&
            elm.type != "datetime" &&
            elm.type != "datetime-local" &&
            elm.type != "date" &&
            elm.type != "month" &&
            elm.type != "week" &&
            elm.type != "time" &&
            elm.type != "range");
  }
  
  function addPlaceholder(elm) {
    elm.setAttribute("_placeholder_on", elm.type);
    if (elm.type == "password")
      elm.type = "text";
    elm.value = "\uFEFF" + elm.placeholder;
  }
  
  function removePlaceholder(elm) {
    if (elm.getAttribute("_placeholder_on") == "password")
      elm.type = "password"
    elm.value = "";
    elm.removeAttribute("_placeholder_on");
  }

  function submitForm(form) {
    var elms = form.getElementsByTagName("*");
    for (var i = 0, length = elms.length; i < length; ++i) {
      var elm = elms[i];
      if (elm.getAttribute("_placeholder_on")) {
        elm.value = "";
      }
    }
  }

  // add placeholders on load
  window.addEventListener("DOMContentLoaded", function() {
    var elms = document.getElementsByTagName("*");
    for (var i = 0, length = elms.length; i < length; ++i) {
      var elm = elms[i];
      if (!isTextField(elm))
        continue;
      if (elm.value == "" &&
        elm.getAttribute("placeholder") != "" &&
        document.activeElement != elm) {
        addPlaceholder(elm);
      }
    }
  }, false);

  // remove placeholder when focused
  document.addEventListener("focus", function(e) {
    if (!isTextField(e.target))
      return;
    if (e.target.value == "\uFEFF" + e.target.placeholder) {
      removePlaceholder(e.target);
      e.target.focus(); // XXX remove this line when opera bug 286219 is fixed
    }
  }, true);

  // add placeholder when blurred
  document.addEventListener("blur", function(e) {
    if (!isTextField(e.target))
      return;
    if (e.target.value == "") {
      addPlaceholder(e.target);
    }
  }, true);

  // remove placeholder value when submitting form
  document.addEventListener("submit", function(e) {
    var form = e.target;
    submitForm(form);
  }, true);
}

