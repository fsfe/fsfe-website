<?='<?xml version="1.0" encoding="utf-8"?>'?>

<eventset> 
	<event start="<?=htmlspecialchars($date)?>" end="<?=htmlspecialchars($date)?>"> 
 
		<title><?if($title):?><?=htmlspecialchars($title)?><?else:?>Fellowship event<?endif;?><?if($location):?> in <?=htmlspecialchars($location)?><?endif;?></title> 
 
		<body> 
			<p><?=$description?></p> 
		</body><?if($url):?> 
 
		<link><?=htmlspecialchars($url)?></link><?endif;?><?if($geodata):?> 
 
		<?=$geodata?><?endif;?> 
 

		<contact>
			<name><?=htmlspecialchars($name)?></name>
			<email><?=htmlspecialchars($email)?></email>
			<city><?=htmlspecialchars($city)?></city>
			<country><?=htmlspecialchars($country)?></country>
		</contact>

 
	</event> 
</eventset> 
