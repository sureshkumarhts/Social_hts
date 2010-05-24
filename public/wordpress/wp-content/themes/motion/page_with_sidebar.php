<?php
/**
 * @package WordPress
 * @subpackage Motion
 */
/*
Template Name: Page with sidebar
*/
?>


<?php get_header(); ?>

<div id="main">
<div id="content">

<?php if (have_posts()) : ?>
<?php while (have_posts()) : the_post(); ?>
     
<?php if (function_exists('wp_list_comments')): ?>
<div <?php post_class(); ?> id="post-<?php the_ID(); ?>">
<?php else : ?>
<div class="post" id="post-<?php the_ID(); ?>">
<?php endif; ?>

<div class="posttop">
<h2 class="posttitle"><a href="<?php the_permalink() ?>" rel="bookmark" title="Permanent Link to <?php the_title_attribute(); ?>"><?php the_title(); ?></a></h2>
</div><!-- /posttop -->
        
<div class="postcontent">
<?php the_content('Read More &raquo;'); ?>
<div class="cleared"></div>
<div class="linkpages"><?php wp_link_pages(); ?></div>
</div><!-- /postcontent -->
<small><?php edit_post_link('Admin: Edit this entry?','',''); ?></small>
</div><!-- /post -->

<div id="comments">
<?php if (function_exists('wp_list_comments')): ?>
<!-- WP 2.7 and above -->
<?php comments_template('', true); ?>

<?php else : ?>
<!-- WP 2.6 and below -->
<?php comments_template(); ?>
<?php endif; ?>
</div> <!-- Closes Comment -->

<?php endwhile; ?>
<?php else : ?>
<div class="post">
<div class="posttop">
<h2 class="posttitle"><a href="#">Oops!</a></h2>
</div><!-- /posttop -->        
<div class="postcontent">
<p>What you are looking for doesn't seem to be on this page...</p>
</div><!-- /postcontent -->        
</div><!-- /post -->
<?php endif; ?>


</div><!-- /content -->

        
<?php get_sidebar(); ?>


</div><!-- /main --> 
<?php get_footer(); ?>
