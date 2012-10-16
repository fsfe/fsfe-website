// Copyright 2012, Free Software Foundation Europe
// Written by Paul Hänsch for the FSFE
// Contact: paul@fsfe.org

// This script handles the dynamic signup button on all pages on fsfe.org

// -- -- -- ... Code ... -- -- --

// The bare signup link on the page is non-javascript dependent and will link
// to a seperate signup page. If the browser supports js, we will replace this link
// with an ajax enabled in-place form.
function scriptifySignupLink() {
  var buttonID = "signuplink";
  var button = document.getElementById(buttonID);
  
  button.setAttribute(
    "href",
    "javascript:swapButtonForForm();"
  )
}

function swapButtonForForm() {
}

function swapFormForButton() {
}

function populateForm() {
}

function submitForm() {
}

function showFormAnswer() {
}

// function for triggering this script on pageload without interfering with other scripts
// code was copied from the Webblog:
// http://www.htmlgoodies.com/beyond/javascript/article.php/3724571/Using-Multiple-JavaScript-Onload-Functions.htm
// Original code by Simon Willison, simonwillison.net
function addLoadEvent(func) {
  var oldonload = window.onload;
  if (typeof window.onload != 'function') {
    window.onload = func;
  } else {
    window.onload = function() {
      if (oldonload) {
        oldonload();
      }
      func();
    }
  }
}
addLoadEvent(scriptifySignupLink);
//addLoadEvent(function() {
//  /* more code to run on page load */
//});
