# ClimateStrike placeholder

FSFE is participating in the Global #ClimateStrike on 20 September 2019.

This is the placeholder page. In order to activate it, add the following to the Apache2 config as last statements within the `*:443` VirtualHost:

```
    RewriteCond %{REQUEST_URI} !^/climate-strike.* [NC]
    RewriteCond %{REQUEST_URI} !^/robots.txt [NC]
    RewriteCond %{REQUEST_URI} !^/(freesoftware|graphics|look|scripts|cgi-bin|fonts|internal|about/legal).* [NC]
    RewriteRule .* /climate-strike [L,R=302]
```

## License

AGPL-3.0-or-later

Started by @comzeradd, improved by @max.mehl
