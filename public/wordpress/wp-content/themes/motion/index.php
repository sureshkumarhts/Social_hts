<?php 
/**
 * @package WordPress
 * @subpackage Motion
 */
get_header(); ?>

<div id="main">
<div id="content">
<h2 id="contentdesc">Results &raquo;</h2>

<?php if (have_posts()) : ?>
<?php while (have_posts()) : the_post(); ?>

<?php if (function_exists('wp_list_comments')): ?>
<div <?php post_class(); ?> id="post-<?php the_ID(); ?>">
<?php else : ?>
<div class="post" id="post-<?php the_ID(); ?>">
<?php endif; ?>
     
<div class="posttop">
<h2 class="posttitle"><a href="<?php the_permalink() ?>" rel="bookmark" title="Permanent Link to <?php the_title_attribute(); ?>"><?php the_title(); ?></a></h2>
<div class="postmetatop">
<div class="categs">Filed Under: <?php the_category(', ') ?> by <?php the_author(); ?></div>
<div class="date"><span><?php the_time('M.d, Y') ?></span></div>
<div class="cleared"></div>
</div><!-- /postmetatop -->
</div><!-- /posttop -->
        
<div class="postcontent">
<?php the_excerpt('View Full Article &raquo;'); ?>
</div><!-- /postcontent -->
        
<div class="postmetabottom">
<div class="tags"><?php the_tags('Tags: ', ', ', ''); ?></div>
<div class="readmore"><span><a href="<?php the_permalink() ?>">read more</a></span></div>
<div class="cleared"></div>
</div><!-- /postmetabottom -->
</div><!-- /post -->

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

<div id="navigation">
<?php if(function_exists('wp_pagenavi')) { ?>
<?php wp_pagenavi(); ?>
<?php }
else { ?>
<div class="alignleft"><?php next_posts_link('&laquo; Older Entries') ?></div>
<div class="alignright"><?php previous_posts_link('Newer Entries &raquo;') ?></div>
<?php } ?><!-- end of pagenavi conditional statement -->
<div class="cleared"></div>
</div><!-- /navigation -->

</div><!-- /content -->

        
<?php get_sidebar(); ?>


</div><!-- /main --> 
<?php get_footer(); ?>

