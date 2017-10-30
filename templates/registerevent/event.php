<?='<?xml version="1.0" encoding="utf-8"?>'?>


<eventset> 
	<event start="<?=htmlspecialchars($startdate)?>" end="<?if($enddate):?><?=htmlspecialchars($enddate)?><?else:?><?=htmlspecialchars($startdate)?><?endif;?>"> 
 
		<title><?if($title):?><?=htmlspecialchars($title)?><?else:?>FSFE event<?endif;?><?if($city):?> in <?=htmlspecialchars($city)?><?endif;?><?if($country):?>, <?=htmlspecialchars($country)?><?endif;?></title> 
 
		<body> 
			<p><?=$description?></p> 
		</body><?if($url):?> 
 
		<link><?=htmlspecialchars($url)?></link><?endif;?> 
 

		<tags>
			<tag content=""><?=htmlspecialchars($city)?></tag>
			<tag content=""><?=htmlspecialchars($country)?></tag>
			<tag>front-page</tag>
		</tags>

 
	</event> 
</eventset> 
