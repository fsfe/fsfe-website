<?php
// This is the contents of the e-mail sent to a signup whos the e-mail was
// already found in the supporter database.

$subject = 'Благодарим за поддержку ЕФСПО';

$message = '
Спасибо за выражение поддержки ЕФСПО!

Однако с этого адреса электронной почты ранее уже подписались.

Подробности см. на странице
http://fsfe.org/support/portal.ru?'. $secret_from_db .'

Обратите внимание, что это персональный URL. По нему можно получить
подробности выраженной вами поддержки в любое время безо всякого
дополнительного пароля.

Спасибо!
';

?>
