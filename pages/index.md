---
layout: page
---

<div class="wrapper">
    {% assign default_paths = site.pages | map: "path" %}
    {% assign page_paths = site.header_pages | default: default_paths %}

  <div class="trigger">
  	<ul>
    {% for path in page_paths %}
      {% assign my_page = site.pages | where: "path", path | first %}
      <li><a class="page-link" href="{{ my_page.url | relative_url }}">{{ path | escape }}</a></li>
    {% endfor %}
	</ul>
  </div>
</div>