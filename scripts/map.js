// Copyright (C) 2012 by Tobias Bengfort <tobias.bengfort@gmx.net>

function map_init(mapID, lat, lng) {

	//create a map object
	var map = new L.Map(mapID);

	//create a base layer for tiles
	var osmLayer = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png');

	//add base layer to map
	map.addLayer(osmLayer);

	//set center of the map
	map.setView(new L.LatLng(lat, lng), 5);

	//set attribution
	map.attributionControl.addAttribution('map data under <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a> by <a href="http://openstreetmap.org/">OpenStreetMap</a>');

	// display place marker
	marker = new L.Marker(new L.LatLng(lat, lng));
	map.addLayer(marker);

};
