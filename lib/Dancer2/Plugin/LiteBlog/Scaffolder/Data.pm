package Dancer2::Plugin::LiteBlog::Scaffolder::Data;
1;
__DATA__
--- views/layouts/main.tt
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>[% title %]</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">

    <link rel="stylesheet" href="/css/style.css">
    [% IF is_article_page %]
    <link rel="stylesheet" href="/css/article-style.css">
    [% END %]
</head>
<body>

    <header id="mobile-header">
        <div id="avatar-icon">
            <a href="/"><img src="/images/avatar.jpg" alt="Your Avatar"></a>
        </div>
        <a href="/"><button id="menu-toggle">[% site.name %]</button></a>
    </header>

    [% IF is_article_page %]
    <section id="hero" class="page-header">
    [% ELSE %]
    <section id="hero">
    [% END %]
        <div class="header-wrapper">
            <a href="/"><img src="/images/avatar.jpg" alt="Your Avatar" id="avatar"></a>
            <a href="/"><h1>[% site.name %]</h1></a>
            [% UNLESS is_article_page %]
                <h3 class="site-baseline">[% site.baseline %]</h3>
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

--- views/index.tt

<!-- Activity Cards -->
<section id="activities">
    [% FOREACH a IN activities %]
    <div class="activity-card" id="activity-[% a.name %]">
        <a href="[% a.link %]"><img width="300" height="300" 
             src="/images/[% a.name %].jpg" 
             alt="[% a.name %]"></a>
        <h2>[% a.name %]</h2>
        <p>[% a.desc %] </p>
    </div>

    <script type="text/javascript">
    // JavaScript code to make the blog-card clickable
    document.getElementById('activity-[% a.name %]').addEventListener('click', function() {
        window.location.href = '[% a.link %]';
    });
    </script>

    [% END %]
</section>


[% IF has_posts %]
<!-- Blog Cards -->
<section id="blog">
    <div class="blog-header">
        <h2>[% featuredpost_title %]</h2>
    </div>
    <div class="blog-cards">

        <!-- Individual blog post cards go here -->
        [% FOREACH p IN posts %]
    <div class="blog-card" id="blog-[% p.slug %]">
        <a href="[% p.permalink %]"><img src="[% p.featured_image %]" alt="[% p.title %]"></a>
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
    
    <div class="blog-button">
        <a href="/blog">[% featuredpost_readmore_button %]</a>
    </div>
</section>
[% END %]

