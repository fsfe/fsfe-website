/*
@licstart  The following is the entire license notice for the
JavaScript code in this page.

Copyright (C) 2020 Free Software Foundation Europe

The JavaScript code in this page is free software: you can
redistribute it and/or modify it under the terms of the GNU
General Public License (GNU GPL) as published by the Free Software
Foundation, either version 3 of the License.
The code is distributed WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the GNU GPL for more details.

As additional permission under GNU GPL version 3 section 7, you
may distribute non-source (e.g., minimized or compacted) forms of
that code without the copy of the GNU GPL normally required by
section 4, provided you include this license notice and a URL
through which recipients can access the Corresponding Source.

@licend  The above is the entire license notice
for the JavaScript code in this page.
*/
fetch(`strings.${document.documentElement.lang}.js`)
	.then((response) => {
		if (response.ok) {
			return document.documentElement.lang;
		} else {
			return "en";
		}
	})
	.then((language) => {
		const text_module = `./strings.${language}.js`;
		const importPromise = import(text_module);

		const searchString = new URLSearchParams(window.location.search).get("q");
		const locals = [document.documentElement.getAttribute("lang")];
		if (!locals.includes("en")) {
			locals.push("en");
		}
		const $target = document.querySelector("#search_results");

		importPromise.then((texts) => {
			if (searchString) {
				// Populate the field with any existing search string
				document.querySelector("#search").value = searchString;

				// Our index uses title as a key of the hashmap
				const pagesByURL = pages.reduce((acc, curr) => {
					acc[curr.url] = curr;
					return acc;
				}, {});

				index = lunr(function () {
					this.pipeline.remove(lunr.stopWordFilter);
					this.pipeline.remove(lunr.trimmer);
					this.field("title", { boost: 10 });
					this.field("tags", { boost: 5 });
					this.field("teaser");
					this.field("type");
					this.ref("url");

					pages.forEach(function (page) {
						this.add(page);
					}, this);
				});

				// Do the search and filter out results not from the current local or English
				let matches = index
					.search(searchString)
					.filter((p) =>
						locals.some((local) => p.ref.includes(local + ".html")),
					);

				function display_result(matches) {
					// workaround xsl XML tag parsing madness
					return (
						"<ul>" +
						matches
							.map((p) => {
								title = pagesByURL[p.ref].title;
								date = pagesByURL[p.ref].date;
								if (date) {
									return (
										"<li>" +
										'<a href="' +
										p.ref +
										'">' +
										title +
										"</a>" +
										" (" +
										date +
										")</li>"
									);
								} else {
									return '<li><a href="' + p.ref + '">' + title + " </a></li>";
								}
							})
							.join("") +
						"</ul>"
					);
				}

				if (matches.length > 0) {
					let [news, pages] = matches.reduce(
						([true_arr, false_arr], m) => {
							if (m.ref.includes("news") === false)
								// return true_arr and append m to false_arr
								return [true_arr, [...false_arr, m]];
							else return [[...true_arr, m], false_arr];
						},
						[[], []],
					);
					if (news.length > 0) {
						news = news.sort(
							(a, b) => pagesByURL[a.ref].date < pagesByURL[b.ref].date,
						);
						news = news.slice(0, 15);
						$target.innerHTML = texts.news_text + display_result(news);
					}
					if (pages.length > 0) {
						pages = pages.slice(0, 15);
						$target.innerHTML += texts.pages_text + display_result(pages);
					}
				} else {
					$target.innerHTML = texts.no_results_text;
				}
			} else {
				$target.innerHTML = texts.empty_query_text;
			}
		});
	});
