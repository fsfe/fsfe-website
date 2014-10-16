<?='<?xml version="1.0" encoding="utf-8"?>'?>


<eventset> 
	<event start="<?=htmlspecialchars($date)?>" end="<?=htmlspecialchars($date)?>"> 
 
		<title><?if($title):?><?=htmlspecialchars($title)?><?else:?>Fellowship event<?endif;?><?if($location):?> in <?=htmlspecialchars($location)?><?endif;?></title> 
 
		<body> 
			<p><?=$description?></p> 
		</body><?if($url):?> 
 
		<link><?=htmlspecialchars($url)?></link><?endif;?> 
 

		<tags>
			<tag><?=htmlspecialchars($city)?></tag>
			<tag><?=htmlspecialchars($country)?></tag>
		</tags>

 
	</event> 
</eventset> 
