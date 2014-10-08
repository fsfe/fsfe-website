<?='<?xml version="1.0" encoding="utf-8"?>'?>
<eventset> 
	<event start="<?=htmlspecialchars($date)?>" end="<?=htmlspecialchars($date)?>"> 
 
		<title><?if($title):?><?=htmlspecialchars($title)?><?else:?>Fellowship event<?endif;?><?if($location):?> in <?=htmlspecialchars($location)?><?endif;?></title> 
 
		<body> 
			<p><?=$description?></p> 
		</body><?if($url):?> 
 
		<link><?=htmlspecialchars($url)?></link><?endif;?><?if($geodata):?> 
 
		<?=$geodata?><?endif;?> 
 
		<partnerset>
			<partner><?if(!$img_error):?> 
				<img>/graphics/partner/<?=htmlspecialchars($img_name)?></img><?endif;?> 
				<name><?=htmlspecialchars($groupname)?></name><?if($groupurl):?> 
				<link><?=htmlspecialchars($groupurl)?></link><?endif;?> 
			</partner>
		</partnerset>

		<contact>
			<name><?=htmlspecialchars($name)?></name>
			<email><?=htmlspecialchars($email)?></email>
		</contact>

		<tags> 
			<tag>2014</tag><?if($geo_country_code):?> 
			<tag><?=htmlspecialchars($geo_country_code)?></tag><?endif;?> 
		</tags> 
 
	</event> 
</eventset> 
