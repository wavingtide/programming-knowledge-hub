# Scrapy

Scrapy is a fast high-level web crawling and web scraping framework.

Run `pip install scrapy` or `conda install -c conda-forge scrapy` to install it.

## Getting started
Run `scrapy startproject scrapy_playground`. The following file structure will be created.
``` shell
.
├── scrapy.cfg
└── scrapy_playground
    ├── __init__.py
    ├── items.py
    ├── middlewares.py
    ├── pipelines.py
    ├── settings.py
    └── spiders
        └── __init__.py
```

Spiders are classes that Scrapy uses to scrape information from a website. They must subclass `Spider` and define the initial request to make.

``` python
from pathlib import Path

import scrapy


class QuotesSpider(scrapy.Spider):
    name = "quote"

    def start_requests(self):
        urls = [
            'https://quotes.toscrape.com/page/1/',
            'https://quotes.toscrape.com/page/2/',
        ]
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)
    
    def parse(self, response):
        page = response.url.split("/")[-2]
        filename = f'quote-{page}.html'
        Path(filename).write_bytes(response.body)
        self.log(f'Saved file {filename}')
```

The spider can be run by running
``` shell
scrapy crawl quotes
```
