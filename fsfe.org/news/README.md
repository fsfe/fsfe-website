# Adding news

===========

There are two ways to add news to the web pages:

## 1

Add an xml file with the following structure in the appropriate
directory.

```xml
<?xml version="1.0" encoding="UTF-8"?> (you can choose an other encoding)

<newsset>
  <news date="date">
    <title>Text</title>
    <body>
      Text
    </body>
    <link>link</link>
  </news>
</newsset>
```

Put this file in the directory /news/this_year/
There's a naming convention for these xml files:

```
  'news-'newsdate'-'counter'.'language_part'.xml'
```

(eg: the English version of the first news file on the 4th November of
2008 should be named news-20081104-01.en.xml and the file should go in
the /news/2008/ directory)

## 2

Add an xhtml file in the appropriate directory.

Write an ordinary xhtml file. Add the newsdate="date" attribute in the
xhtml tag. The first <p> element will be copied into the xml file.

(eg:

```xhtml
<?xml versio ...

<html newsdate="2008-10-07" link="link" >  (link attribute is optional)

<head>
	<title>This is the title of the news item</title>
</head>

<body>

<p>This is the paragraph that will be copied into the xml file. <p>

<p>This is a paragraph that will not be copied.</p>

....

</html>
```

The link in the generated xml file will default to the original
page. If you want it to link to another page then you can use the
link attribute in the html tag.

You can freely choose a name for this file and you should put it in the
/news/this_year/ directory or in the directory of the project it
belongs to (/projects/project_name/), so you can keep all pages of one
project together.

The xml files for these xhtml files are generated automatically. The
xml file will exist as long as the xhtml file exists. If you want to
change the xhtml file but keep the xml file unchanged, just remove the
newsdate attribute from the xhtml file. (eg: this can be a way to
announce a new project, it will generate an xml file that links to the
index page of the project, and it leaves the option open to change the
page afterwards and keep the original announcement).
