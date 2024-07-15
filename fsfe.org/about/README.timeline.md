# Timeline SVG maintenance

The SVG file of the timeline isn't easy to maintain, mainly because of the 
appearing bubbles and the links when clicking on an event. This document shall 
help you in case you are the poor person having to do that (hi future Me!) ;)

Alert: I'm using a localised version of Inkscape so maybe some labels are 
different to your English version.


## Positioning of elements

Inkscape will help you with positioning the various elements correctly. Use the 
"Arrange" tool wisely. 

To set the events at the correct vertical line, dock it to the inner border of 
on of the four the greenish bars, then move it one large (Shift+Arrow) and one 
small (Arrow) to the outer side. Don't ask why, but this is how it was invented 
(shame on you, past Me!).


## Name scheme

The four bars are internally numbered, from 1 to 4 from left to right. This 
will become important when we come to naming the bubbles.

The only elements that need proper naming are the (invisible) bubbles. They 
consist of 5 digits: $bar_number $month(2) $year(2)

20815 means: 2nd bar (Policy), 08 2015


## Unhide all bubbles

If you open the file, the bubbles won't be visible and editable. You have to 
unhide them first. Mark the "bubbles" layer, go to "Object" in the menu bar and 
click "Unhide all". You now see all bubbles at once, overlapping each other.


## Hide bubbles

Click on a bubble and open the "object preferences" (Shift+Ctrl+O). Click on 
the "hide" checkbox to make it disappear. To change the visibility status of a 
hidden element, you can find it with the search function if you know its name 
(look at "name scheme" above). You have to check the "include hidden elements" 
box for that.


## Setting links

All items (layer "points") have a link to click on. Just right-click on the 
event and click "link preferences" and edit the "Href" attribute. Remember to 
set the Target to "_blank" to open a link in a new window when you click on it.


## Hover bubbles

When you hover over an event, it makes a bubble appear - and disappear as soon 
as you hover out. This is the trickiest (and most fiddly) part, and needs two 
things: a bubble with the correct name, and an event with the current function.

First, give the bubble a proper name, following the "name scheme" from above. 
This is tricky because sometimes it selects a single element of the bubble 
instead of the whole group (or something). Sometimes I had to make two double 
clicks in a row on a bubble to get the correct setting mask. If you copy an 
existing bubble, rename it first, then edit it's content! Much easier, trust 
me...

After that, go to the respective event for this bubble (I assume you have moved 
the bubble to a fitting position). Open the object preferences, click on 
"interactivity". If "onmouseover" and "onmouseout" are blank, try to 
double-click on the event again, and append a single click. For me this worked. 
For your new event, copy the two strings and just update the 5 digits with the 
name you gave the bubble. This name has to be unique! 

If there are two events from the same month and year in the same bar, append a 
"b" to it or something, and reflect this to the onmouseover/-out settings.

After that, just hide the bubble (again). Click on it, open the object's 
preferences and mark the hide checkbox.

Hint: If you can't get to the preferences again because you can just select the 
bubble's text or something, click the Esc button, or on a different element in 
the file. Helps sometimes.


## Publish on website

If you didn't change the page size of the document, you can just commit the new 
SVG file. Please remember to export the file to PNG and also commit that. This 
is important as a fallback for poor old-IE users and non-Javascript users.

If you changed the size of the page (because you added more years for example), 
you may have to edit the source code of the file to make internet browser show 
the whole document instead of blank nothing. 

Open the SVG file in a text editor and set following values:

  viewBox="0 0 $WIDTH $HEIGHT"

  width="100%"
  height="100%"

You can get the width and height from the document settings in Inkscape. The 
100% always stay the same. Of course, "$" will have to be removed.

In the same step you might also want to anonymise the 
"inkscape:export-filename" value since it might reveal your name or the folder 
naming scheme (FSFE's president might not want you to use 
/home/user/shittyFSFEworkCrap/ as the directory name).
