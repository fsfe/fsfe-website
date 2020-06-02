/*
 * SPDX-FileCopyrightText: 2020 Max Mehl <https://mehl.mx>
 * SPDX-License-Identifier: GPL-3.0-or-later
*/

/*
  This file enables to only display members of a certain team and hide the rest.
  - selectTeam() shows the selected team and hides all the rest
  - selectAllTeams() shows all teams

  It can only be used in conjunction with the "filter" class applied to the
  whole people div.

  It is being used on /about/team currently
*/

function selectTeam(team) {
  let li_persons = document.querySelectorAll('div.filter div.person');

  for (i = 0; i < li_persons.length; i++) {
    persons = li_persons[i].getAttribute('teams');
    if (persons.indexOf(team) !== -1) {
      li_persons[i].style.display = "block";
    } else {
      li_persons[i].style.display = "none";
    }
  }
}

function selectAllTeams() {
  let li_persons = document.querySelectorAll('div.filter div.person');

  for (i = 0; i < li_persons.length; i++) {
    li_persons[i].style.display = "block";
  }
}
