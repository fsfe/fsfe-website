// Copyright (C) 2012 by Tobias Bengfort <tobias.bengfort@gmx.net>
// working for Free Software Foundation Europe
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
