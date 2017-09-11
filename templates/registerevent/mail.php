
--boundary 
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline 

 
 
Hi, 
 
You have registered an event on http://fsfe.org/community/tools/eventregistration

Below is the list of the information you gave.
	Name: <?=$name?> 
	Email: <?=$email?> 

	Location: <?=$city?>, <?=$country?>
 
You find all other information in the xml file attached. It will be uploaded
in the next 24 hours. If you like to withdraw your event or in case you like to change some information,
please contact contact@fsfe.org
 
Thanks,
your website
--boundary
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="wikievent.txt"

<?=$wiki?>
--boundary 
Content-Type: application/xml; charset=utf-8 
Content-Disposition: attachment; filename="event.xml" 

<?=$event?>
--boundary--

