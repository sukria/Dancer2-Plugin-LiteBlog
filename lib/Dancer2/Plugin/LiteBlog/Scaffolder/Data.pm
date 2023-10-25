package Dancer2::Plugin::LiteBlog::Scaffolder::Data;
1;
__DATA__
--- public/css/liteblog.css
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 0;
    padding: 0;
}

/* Header Menu */
/* CSS for the mobile header */
#mobile-header {
    display: none;
    background-color: #2d2d2d;
    color: #ffffff;
    padding: 10px;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    z-index: 1000; /* Adjust z-index as needed */
    align-items: center; /* Center vertically */
    justify-content: center; /* Center horizontally */
    flex-direction: row; /* Default flex-direction */
}

#avatar-icon {
    display: inline-block;
    width: 30px; /* Adjust the size as needed */
    height: 30px;
    border-radius: 50%;
    overflow: hidden;
    margin-right: 10px;
}

#avatar-icon img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

/* CSS for the menu toggle button */
#menu-toggle {
    background: none;
    border: none;
    color: #eee;
    font-size: 20px;
    cursor: pointer;
    margin-right: 10px;
    flex: 1; /* Expand to fill available space */
    text-align: center; /* Center text horizontally */
}


/* Home Page Layout */

#hero {
    background-color: #2d2d2d;
    text-align: center;
    padding: 50px 0;
    padding-bottom: 1.5em;
}

#avatar {
    width: 150px;
    height: 150px;
    border-radius: 50%;
    margin-bottom: 20px;
}

h1 {
    color: #ffffff;
    margin: 0;
}

h3.site-baseline {
    margin: 0;
    margin-top: 1em;
    padding: 0;
    color: #777;
    font-weight: normal;
}

#activity-welcome {
    width: calc(66.66% - 20px); /* 2/3 of the width minus the margin */
    margin: 0 auto; /* Center the card horizontally */
}

#activities {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    justify-content: center;
    padding: 40px 20px;
}

.activity-card {
    background-color: #ffffff;
    width: calc(25% - 20px); /* Basic 3-grid layout, you can adjust as needed */
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    text-align: center;
    padding: 20px;
    border-radius: 5px;
    
}

/* make an element clickable with a zoom-in effect */
.clickable-div {
    /* Effect on mouse over */
    cursor: pointer; /* Add pointer cursor for clickability */
    transition: transform 0.2s, box-shadow 0.2s; /* Add transition for hover effect */
}

.clickable-div:hover {
    transform: scale(1.1); /* Apply a 10% zoom effect on hover */
    box-shadow: 0 8px 12px rgba(0, 0, 0, 0.2); /* Add a shadow effect on hover */
}

.activity-card pre {
    margin:0;
    padding: 0;
    text-align: left;
}

.activity-card img {
   /*
    max-width: 100%;
    height: auto;
    margin-bottom: 15px;
    */

    width: 100%;
    height: 160px; /* Fixed height of 60px */
    object-fit: cover; /* Maintain aspect ratio */
    object-position: center; /* Center the image horizontally and vertically */
}

.activity-card h2 {
    margin-top: 0;
}

.activity-card p {
    text-align: left;
}

/* Article Page */

section#article {
    margin: auto;
    min-width: 450px;
    max-width: 700px;
    background-color: #fff;
    padding: 20px;
    border-left: 2px solid #DDD;
    border-right: 2px solid #DDD;
    border-bottom: 2px solid #DDD;
}

.article-wrapper {
    width: 100%;
    max-width: 600px;
    margin: auto;
}

section#article h1, h2, h3, h4 {
    font-family: sohne, "Helvetica Neue", Helvetica, Arial, sans-serif;
}

#hero a {
    text-decoration: none;
} 

section#article h1 {
    color: #444;
    font-size: 42px;
    margin-bottom: 1em;
}

section#article {
    font-family: source-serif-pro, Georgia, Cambria, "Times New Roman", Times, serif;
    font-size: 18px;
}

/* Blog Cards */

/* Add these styles at the end of your existing CSS */

/* Blog Section */
#blog {
    background-color: #2d2d2d;
    color: #ffffff;
    padding: 40px 0;
}

.blog-header {
    text-align: center;
    margin-bottom: 20px;
}

.blog-header h2 {
    font-size: 24px;
    margin: 0;
}

.blog-cards {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    justify-content: center;
    padding: 20px;
}

.blog-card {
    position: relative; /* Needed for absolute positioning of the ribbon */
    background-color: #ffffff;
    width: calc(33.33% - 20px);
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    text-align: center;
    padding: 20px;
    border-radius: 5px;
    margin-bottom: 20px;
    color: #333;
    overflow: hidden; /* Hide overflowing ribbon */
    margin: 0;
    padding: 0;

    cursor: pointer; /* Add pointer cursor for clickability */
    transition: transform 0.2s, box-shadow 0.2s; /* Add transition for hover effect */
}
/* Add a hover effect for the blog card */
.blog-card:hover {
    transform: scale(1.1); /* Apply a 10% zoom effect on hover */
    box-shadow: 0 8px 12px rgba(0, 0, 0, 0.2); /* Add a shadow effect on hover */
}

.blog-card img {
    width: 100%;
    height: 120px; /* Fixed height of 60px */
    object-fit: cover; /* Maintain aspect ratio */
    object-position: center; /* Center the image horizontally and vertically */
}

.blog-card p {
    margin: 1em;
    margin-bottom: 2em;
}

.blog-card h3 {
    font-size: 20px;
    margin: 1em;
}

.blog-card .category-ribbon {
    background-color: #f16522; /* Adjust color as needed */
    color: #ffffff;
    padding: 5px 10px;
    border-radius: 3px;
    margin-bottom: 10px;
    display: inline-block;
}

/* Add styles for the category container */
.category-container {
    position: absolute; /* Position within the .blog-card */
    top: 0;
    right: 0;
    transform: translate(50%, -50%); /* Center the ribbon */
}

/* Add styles for the ribbon */
.category-ribbon {
    background-color: #f16522; /* Adjust color as needed */
    color: #ffffff;
    padding: 5px 20px; /* Adjust size as needed */
    border-radius: 3px;
    position: relative;
    z-index: 1; /* Place the ribbon above content */
    transform: translateX(40%) rotate(45deg); /* Adjust the translateX value as needed */
    transform-origin: top right; /* Rotate around the top right corner */
    top: 80px;
    right: 85px;
    width: 110px;

    text-align: center;
    font-size: 14px; /* Adjust font size as needed */
    line-height: 1.2; /* Adjust line height as needed */
}

/* Ensure the ribbon text is readable */
.category-ribbon::before {
    content: "";
    position: absolute;
    top: -4px;
    left: 0;
    border-width: 5px 5px 0;
    border-style: solid;
    border-color: #f16522 transparent transparent transparent;
}

.blog-button {
    text-align: center;
    margin-top: 20px;
}

.blog-button a {
    background-color: #f16522; /* Adjust color as needed */
    color: #ffffff;
    padding: 10px 20px;
    border-radius: 5px;
    text-decoration: none;
    font-weight: bold;
    font-size: 16px;
}


/* For mobile responsiveness */

@media screen and (max-width: 768px) {
    .blog-card, .activity-card {
        width: calc(50% - 20px);
    }
}

@media screen and (max-width: 480px) {
    .blog-card, .activity-card {
        width: 100%;
    }
}


--- articles/tech/first-article/meta.yml
---
title: "A super lightweight Dancer-based blog engine"
author: sukria
published: 2023-10-21
tags:
  - perl
  - dancer
  - blog
featured: /images/liteblog.jpg

--- articles/blog-meta.yml
---
categories:
  - tech
  - perl
featured_posts:
  - "tech/first-article"
  - "tech/second-article-tech"
  - "failed/does-not-exist"
 

--- views/liteblog/index.tt
[% IF no_widgets %]
<section id="activities">
    <div class="activity-card" id="activity-welcome">
        <h2>Great! Now it's time to enable some widgets</h2>
        <p>
            Welcome to your LiteBlog site! Everything is working just fine. You just have to enable some widgets in your Dancer2 config.

            Try adding those lines in your <code>config.yml</code> file and restart your app.
        </p>

        <pre>
liteblog:
  blog:
    title: "Read my Stories"
    root: "articles"
  activities:
    source: "activities.yml"
        </pre>
    </div>
</section>
[% END %]

[% IF has_activities %]
<!-- Activity Cards -->
<section id="activities">
    [% FOREACH a IN activities %]
        [% IF a.link %]
        <div class="activity-card clickable-div" id="activity-[% a.name %]">
            <a href="[% a.link %]"><img width="300" height="300" src="/images/[% a.name %].jpg" alt="[% a.name %]"></a>
        [% ELSE %]
        <div class="activity-card" id="activity-[% a.name %]">
            <img width="300" height="300" src="/images/[% a.name %].jpg" alt="[% a.name %]">
        [% END %]
            <h2>[% a.name %]</h2>
            <p>[% a.desc %] </p>
        </div> <!-- END activity-card -->

        [% IF a.link %]
        <script type="text/javascript">
        // JavaScript code to make the blog-card clickable
        document.getElementById('activity-[% a.name %]').addEventListener('click', function() {
            window.location.href = '[% a.link %]';
        });
        </script>
        [% END %]
    [% END %]
</section> <!-- END activities section -->
[% END %]

[% IF has_posts %]
<!-- Blog Cards -->
<section id="blog">
    <div class="blog-header">
        <h2>[% blog.title %]</h2>
    </div>
    <div class="blog-cards">

        <!-- Individual blog post cards go here -->
        [% FOREACH p IN posts %]
    <div class="blog-card" id="blog-[% p.slug %]">
        <a href="[% p.permalink %]"><img src="[% p.featured %]" alt="[% p.title %]"></a>
        <h3>[% p.title %]</h3>

	    <div class="category-container">
            <div class="category-ribbon">[% p.category %]</div>
        </div>
    
	    <p>[% p.excerpt %]</p>
    </div>

    <script type="text/javascript">
    // JavaScript code to make the blog-card clickable
    document.getElementById('blog-[% p.slug %]').addEventListener('click', function() {
        window.location.href = '[% p.permalink %]';
    });
    </script>
    [% END %]

    </div> <!-- END blog-cards -->
    
    [% IF blog.readmore_button %]
    <div class="blog-button">
        <a href="/blog">[% blog.readmore_button %]</a>
    </div>
    [% END %]
</section>
[% END %]

--- articles/tech/first-article/content.md
# This is the first title of the article

Here I have a paragraph. 

And here a second

## Here a subtitle

And there a last paragraph with a bullet-point list

  * One item
  * A second one
  * And a third

Voilà.

--- public/images/liteblog.jpg
/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAAMCAgMCAgMDAwMEAwMEBQgFBQQEBQoHBwYIDAoMDAsK
CwsNDhIQDQ4RDgsLEBYQERMUFRUVDA8XGBYUGBIUFRT/2wBDAQMEBAUEBQkFBQkUDQsNFBQUFBQU
FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBT/wAARCAGQAZADASIA
AhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA
AAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3
ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm
p6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA
AwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx
BhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK
U1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3
uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD9U6KK
KACiikPSgApa8Vtv2rvBkP7QWo/B7WTc+HfFccUM+mtqQVLfV0kTcPszhjlgcjY2CSpwDg17QGDH
igB1FFFABRRRQAUUUUAFFFFABRRRQAUUhOKQtgCgB1FN389KztZ8QW2hJbNcpOwuJ0t08iFpfmbp
naDtHqx4FNK+hMpRguaT0NOkzSFxmuc1DxoLDxlpugf2RqM/22FphqEUObaLGflds8Hj07j1pqLl
oiJ1IU0nJ+X3nSHNITSB81y3iDxZqOk+KtD0u18P3WpWmoMwn1CJgI7THdh3/T8aIxc3ZE1a0KMe
ae10vv0OrJxQDmm7s1z114lvIPGlloq6Jdy2dxbNO+rKR5ETA8Rt3yf60kubYqdSNNJy6ux0Qbmn
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

--- views/liteblog/article.tt
<section id="article">
<div class="article-wrapper">
<% content %>
</div>
</section>

--- activities.yml
---
- name: "LinkedIn"
  link: '#'
  desc: "Checkout my LinkedIn profile. This is an example. Feel free to change it in <code>liteblog/activities.yml</code>."
- name: "GitHub"
  link: "https://github.com/PerlDancer"
  desc: "This is the Dancer GitHub Official account. It's a good time to Star the <a href=\"https://github.com/PerlDancer/Dancer2\">Dancer2</a> project!  This is an example. Feel free to change it in <code>liteblog/activities.yml</code>."

--- views/layouts/liteblog.tt
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>[% title %]</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">

    <link rel="stylesheet" href="/css/liteblog.css">
    [% IF is_article_page %]
    <link rel="stylesheet" href="/css/liteblog/article.css">
    [% END %]
</head>
<body>

    <header id="mobile-header">
        <div id="avatar-icon">
            <a href="/"><img src="/images/liteblog.jpg" alt="Your Avatar"></a>
        </div>
        <a href="/"><button id="menu-toggle">[% title %]</button></a>
    </header>

    [% IF is_article_page %]
    <section id="hero" class="page-header">
    [% ELSE %]
    <section id="hero">
    [% END %]
        <div class="header-wrapper">
            <a href="/"><img src="/images/liteblog.jpg" alt="LiteBlog Logo" id="avatar"></a>
            <a href="/"><h1>[% title %]</h1></a>
            [% UNLESS is_article_page %]
                [% IF baseline %]
                <h3 class="site-baseline">[% baseline %]</h3>
                [% END %]
            [% END %]
        </div>

    [% IF is_article_page %]
        <div class="article-title">
            <h1 class="article-title-text">[% title %]</h1>
        </div>
    [% END %]
    </section>

[% content %]

<script type="text/javascript">
window.addEventListener('scroll', function () {
    var heroSection = document.getElementById('hero');
    var mobileHeader = document.getElementById('mobile-header');

    if (window.scrollY > heroSection.clientHeight) {
        mobileHeader.style.display = 'block';
    } else {
        mobileHeader.style.display = 'none';
    }
});
</script>

    </body>
</html>

