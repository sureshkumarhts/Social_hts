<?php
/**
 * @package WordPress
 * @subpackage Motion
 */

if ( function_exists('register_sidebar') ) {
	register_sidebar(array(
		'name'=>'sidebar',
		'before_widget' => '<li id="%1$s" class="boxed widget %2$s">',
		'after_widget' => '</li>',
		'before_title' => '<h3 class="widgettitle">',
		'after_title' => '</h3>',
	));
	register_sidebar(array(
		'name'=>'footer_left',
		'before_widget' => '<li id="%1$s" class="widget %2$s">',
		'after_widget' => '</li>',
		'before_title' => '<h3 class="widgettitle">',
		'after_title' => '</h3>',
	));
	register_sidebar(array(
		'name'=>'footer_middle',
		'before_widget' => '<li id="%1$s" class="widget %2$s">',
		'after_widget' => '</li>',
		'before_title' => '<h3 class="widgettitle">',
		'after_title' => '</h3>',
	));
	register_sidebar(array(
		'name'=>'footer_right',
		'before_widget' => '<li id="%1$s" class="widget %2$s">',
		'after_widget' => '</li>',
		'before_title' => '<h3 class="widgettitle">',
		'after_title' => '</h3>',
	));
	register_sidebar(array(
		'name'=>'header',
		'before_widget' => '<div id="headerbanner" class="widget %2$s">',
		'after_widget' => '</div>',
		'before_title' => '<h3 class="widgettitle">',
		'after_title' => '</h3>',
	));

}



function mytheme_comment($comment, $args, $depth) {
   $GLOBALS['comment'] = $comment; ?>
   <li <?php comment_class(); ?> id="li-comment-<?php comment_ID() ?>">
     <div id="comment-<?php comment_ID(); ?>">

	
	<?php echo get_avatar($comment,$size='50'); ?>

	<div class="commentbody">
	<div class="author"><?php comment_author_link() ?></div>
		<?php if ($comment->comment_approved == '0') : ?>
		<em>(Your comment is awaiting moderation...)</em>
		<?php endif; ?>
	<div class="commentmetadata"><a href="#comment-<?php comment_ID() ?>" title=""><?php comment_date('F jS, Y') ?> on <?php comment_time() ?></a> <?php edit_comment_link('edit','&nbsp;&nbsp;',''); ?></div>
	<?php comment_text() ?>
	</div><!-- /commentbody -->

      	<div class="reply">        
      	 <?php comment_reply_link(array_merge( $args, array('depth' => $depth, 'max_depth' => $args['max_depth']))) ?>
      	</div><!-- /reply -->
	<div class="cleared"></div>
			
     </div><!-- /comment -->
<?php
        }



function mytheme_ping($comment, $args, $depth) {
   $GLOBALS['comment'] = $comment; ?>
   <li <?php comment_class(); ?> id="li-comment-<?php comment_ID() ?>">
     <div id="comment-<?php comment_ID(); ?>">

	<div class="commentbody">
	<div class="author"><?php comment_author_link() ?></div>
		<?php if ($comment->comment_approved == '0') : ?>
		<em>(Your comment is awaiting moderation...)</em>
		<?php endif; ?> 
	<?php comment_text() ?>
	</div><!-- /commentbody -->

     </div>
<?php
        }



?>