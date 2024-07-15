/*
 * SPDX-License-Identifier: CC-BY-SA-4.0
 * SPDX-FileCopyrightText: 2012 Cheery <https://stackoverflow.com/users/1164491/cheery>
 * SPDX-FileCopyrightText: 2020 Free Software Foundation Europe <https://fsfe.org>
 *
 * This script allows the dynamic clone of a table row using a button.
 * Reference implementation on /internal/rc.en.xhtml
 */

$(document).ready(function() {
  $('.AddNewRow').click(function(){
    var row = $(this).closest('tr').clone();
    row.find('input').val('');
    row.find('textarea').val('');
    $(this).closest('tr').parent().children('tr').last().after(row);
    $('input[type="button"]', row).removeClass('AddNewRow btn-primary').addClass('RemoveRow btn-danger').val('Delete');
  });

  $('table').on('click', '.RemoveRow', function(){
    $(this).closest('tr').remove();
  });
});
