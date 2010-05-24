<?php
/*
Plugin Name: Integration API
Version: 1.0
Plugin URI: http://greenfabric.com/page/integration_api_home_page
Description: Enable single sign-on between Wordpress and Ruby on Rails.
Author: Robb Shecter
Author URI: http://greenfabric.com/robb
*/

  /*
   * This plugin was made possible by the great work done by Daniel
   * Westermann-Clark on the HTTP Authentication Plugin.
   */


/*  Copyright (C) 2008 Robb Shecter ( greenfabric.com )

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA */

require_once 'integration_api_lib.php';

$API_DEBUG   = false;

if (! class_exists('IntegrationApiPlugin')) {
  class IntegrationApiPlugin {
    public $api;


    function IntegrationApiPlugin() {
      if (isset($_GET['activate']) and $_GET['activate'] == 'true') {
	add_action('init', array(&$this, 'initialize_options'));
      }
      add_action('admin_menu', array(&$this, 'add_options_page'));
      add_action('wp_authenticate', array(&$this, 'authenticate'), 10, 2);
      add_filter('check_password', array(&$this, 'skip_password_check'), 10, 4);
      add_action('wp_logout', array(&$this, 'logout'));
      add_action('lost_password', array(&$this, 'disable_function'));
      add_action('retrieve_password', array(&$this, 'disable_function'));
      add_action('password_reset', array(&$this, 'disable_function'));
      add_action('check_passwords', array(&$this, 'generate_password'), 10, 3);
      add_filter('show_password_fields', array(&$this, 'disable_password_fields'));
    }

	  
    /*
     * Do simple caching of the IntegrationApi instance.
     * There's probably a simpler way to do this.
     */
    function api() {
      if (! $this->api)
	$this->api = new IntegrationApi(get_option('i_api_api_url'));
      return $this->api;
    }


    /*************************************************************
     * Plugin hooks
     *************************************************************/
    
    /*
     * Add options for this plugin to the database.
     */
    function initialize_options() {
      if (current_user_can('manage_options')) {
	add_option('i_api_auto_create_user', false, 'Should a new user be created automatically if not already in the WordPress database?');
	add_option('i_api_api_url', 'http://localhost:3000/integration_api/', 'The url of the Integration API web service.');
	add_option('i_api_user_username',  '', 'How do you store the username in your Rails app?');
	add_option('i_api_user_firstname', '', 'How do you store the first name in your Rails app?');
	add_option('i_api_user_lastname',  '', 'How do you store the last name in your Rails app?');
	add_option('i_api_user_email',     '', 'How do you store the user email in your Rails app?');
	add_option('i_api_user_website',   '', "How do you store the user's website in your Rails app?");
	add_option('i_api_single_signon', false, 'Automatically detect if a user is logged in?');
	add_option('i_api_user_nickname', '', '');
	add_option('i_api_user_display_name', '', '');
	add_option('i_api_user_description', '', '');
      }
    }


    /*
     * Add an options pane for this plugin.
     */
    function add_options_page() {
      if (function_exists('add_options_page')) {
	add_options_page('Integration API', 'Integration API', 9, __FILE__, array(&$this, '_display_options_page'));
      }
    }
    
    
    /*
     * Check if the current person is logged in.  If so,
     * return the corresponding WP_User.
     */
    function authenticate($username, $password) {
      if ( $this->api()->is_logged_in() ) {
	$username = $this->api()->user_info()->{get_option('i_api_user_username')};
	$password = $this->_get_password();
      } else {
	$this->redirect_to_login();
      }

      $user = get_userdatabylogin($username);
	    
      if (! $user or $user->user_login != $username) {
	// User is logged into the API, but there's no 
	// Wordpress user for them.  Are we allowed to 
	// create one?
	if ((bool) get_option('i_api_auto_create_user')) {
	  $this->_create_user($username);
	  $user = get_userdatabylogin($username);
	}
	else {
	  // Bail out to avoid showing the login form
	  die("User $username does not exist in the WordPress database and user auto-creation is disabled.");
	}
      }
      return new WP_User($user->ID);
    }
    
    
    /*
     * Skip the password check, since we've externally authenticated.
     */
    function skip_password_check($check, $password, $hash, $user_id) {
      return true;
    }
    
    
    /*
     * Logout the user by redirecting them to the logout URL.
     */
    function logout() {
      header('Location: ' . $this->api()->logout_url());
      exit();
    }
    
	  
    /*
     * Send the user to the login page given by the API.
     */
    function redirect_to_login() {
      header('Location: ' . $this->api()->login_url());
      exit();
    }
    

    /*
     * Generate a password for the user. This plugin does not
     * require the user to enter this value, but we want to set it
     * to something nonobvious.
     */
    function generate_password($username, $password1, $password2) {
      $password1 = $password2 = $this->_get_password();
    }
	  

    /*
     * Used to disable certain display elements, e.g. password
     * fields on profile screen.
     */
    function disable_password_fields($show_password_fields) {
      return false;
    }
    
    
    /*
     * Used to disable certain login functions, e.g. retrieving a
     * user's password.
     */
    function disable_function() {
      die('Disabled');
    }


    /*************************************************************
     * Private methods
     *************************************************************/
    
    
    /*
     * Generate a random password.
     */
    function _get_password($length = 10) {
      return substr(md5(uniqid(microtime())), 0, $length);
    }


    /*
     * Create a new WordPress account for the specified username.
     */
    function _create_user($username) {
      require_once(WPINC . DIRECTORY_SEPARATOR . 'registration.php');
      $api_info = (array) $this->api()->user_info();
      $u = array();

      $u['user_pass']      = $this->_get_password();
      $u['user_login']     = $username;
      $u['user_email']     = $api_info[get_option('i_api_user_email')];
      $u['user_url']       = $api_info[get_option('i_api_user_website')];
      $u['user_firstname'] = $api_info[get_option('i_api_user_firstname')];
      $u['user_lastname']  = $api_info[get_option('i_api_user_lastname')];
      
      $u['nickname']       = $api_info[get_option('i_api_user_nickname')];
      $u['display_name']   = $api_info[get_option('i_api_user_display_name')];
      $u['description']    = $api_info[get_option('i_api_user_description')];
 
      wp_insert_user($u);
    }
    
    
    /*
     * Display the options for this plugin.
     */
    function _display_options_page() {
      $api_url           = get_option('i_api_api_url');
      $auto_create_user  = (bool) get_option('i_api_auto_create_user');
      $user_username     = get_option('i_api_user_username');
      $user_firstname    = get_option('i_api_user_firstname');
      $user_lastname     = get_option('i_api_user_lastname');
      $user_email        = get_option('i_api_user_email');
      $user_website      = get_option('i_api_user_website');
      $single_signon     = (bool) get_option('i_api_single_signon');
      $user_nickname     = get_option('i_api_user_nickname');
      $user_display_name = get_option('i_api_user_display_name');
      $user_description  = get_option('i_api_user_description');
?>
<div class="wrap">
  <h2>Integration API Settings</h2>

  <form action="options.php" method="post">
    <input type="hidden" name="action" value="update" />
    <input type="hidden" name="page_options" value="i_api_user_nickname,i_api_user_display_name,i_api_user_description,i_api_single_signon,i_api_user_username,i_api_user_firstname,i_api_user_lastname,i_api_user_email,i_api_user_website,,i_api_api_url,i_api_auto_create_user,i_api_auto_create_email_domain" />
    <?php if (function_exists('wp_nonce_field')): wp_nonce_field('update-options'); endif; ?>

    <table class="form-table">
      <tr valign="top">
        <th scope="row"><label for="i_api_api_url">API web service URL</label></th>
        <td>
          <input type="text" name="i_api_api_url" id="i_api_api_url" value="<?php echo htmlspecialchars($api_url) ?>" size="50" /><br />
          e.g., http://localhost:3000/integration_api/							   
        </td>
      </tr>
      <tr valign="top">
        <th scope="row"><label for="i_api_single_signon">Enable single sign-on?</label></th>
        <td>
          <input type="checkbox" name="i_api_single_signon" id="i_api_single_signon"<?php if ($single_signon) echo ' checked="checked"' ?> value="1" />
	  <p>
	    When this is enabled, users will not have to
	    click <i>login</i> or <i>logout</i>; Wordpress will simply
	    recognize their login state.  <span style="color: red;
	    font-weight: bold">Important:</span> activate this feature
	    only after verifying that login and logout is functioning
	    via the plugin.  Otherwise, you may be locked out from
	    Wordpress.
	  </p>
        </td>
      </tr>
      <tr valign="top">
        <th scope="row"><label for="i_api_auto_create_user">Automatically create accounts?</label></th>
        <td>
          <input type="checkbox" name="i_api_auto_create_user" id="i_api_auto_create_user"<?php if ($auto_create_user) echo ' checked="checked"' ?> value="1" />
	  <p>
            Should a new user be created automatically if not already
            in the WordPress database?<br />  Created users will
            obtain the role defined under &quot;New User Default
            Role&quot; on the <a href="options-general.php">General
            Options</a> page.
	  </p>
        </td>
      </tr>
    </table>
    

    <h3>User data mapping</h3>
    <p>
      If you've enabled <i>automatically create accounts</i>, above,
      then when this plugin creates the new Wordpress user, it will
      fill in some of the Wordpress user attributes.  This plugin gets
      the info directly from your Rails app. But you must first set up
      a &quot;mapping&quot; to specify what corresponds with what.
      Here are the Rails user attributes that your app is currently
      sending via the API:
    </p>
    <table style="margin-left: 40px;">
      <?
	    $user_array = (array) $this->api()->user_info(); 
            if ((count(array_keys($user_array))) == 0)
              echo "<p style=\"background-color: #fab; padding: 0.5em\"><span style=\"color: red; font-weight: bold\">Error: No Rails data.</span> Check (1) your API URL setting above, (2) that your Rails app is properly configured, and (3) that you are logged in to your Rails app.</p>";
            else {
	    echo "<tr><th>Rails attribute</th><th>Sample value</th></tr>";
	    foreach (array_keys($user_array) as $attribute) {
	      echo "<tr>";
	      echo "<td><b>";
	      echo $attribute;
	      echo "</b></td>";
	      echo "<td>";
	      echo $user_array[$attribute];
	      echo "</td>";
	      echo "</tr>";
	      }
            }
      ?>
    </table>
    <p>
      In each text field, enter the appropriate attribute name from
      the left column above. Leave a field blank if there's no
      corresponding field in your Rails user model or if you don't want
      the particular attribute to be automatically set.
    </p>

    <table class="form-table">
      <tr valign="top">
	<th scope="row"><label for="i_api_user_username">Username</label></th>
        <td>
          <input type="text" name="i_api_user_username" id="i_api_user_username" value="<?php echo htmlspecialchars($user_username) ?>" size="50" /><br/>
	  (Required) The login name for the user.  The user will not be able to change this.
        </td>
      </tr>
      <tr valign="top">
	<th scope="row"><label for="i_api_user_email">E-mail</label></th>
        <td>
          <input type="text" name="i_api_user_email" id="i_api_user_email" value="<?php echo htmlspecialchars($user_email) ?>" size="50" /><br/>
	  (Required)
        </td>
      </tr>
      <tr valign="top">
	<th scope="row"><label for="i_api_user_firstname">First Name</label></th>
        <td>
          <input type="text" name="i_api_user_firstname" id="i_api_user_firstname" value="<?php echo htmlspecialchars($user_firstname) ?>" size="50" /><br/>
        </td>
      </tr>
      <tr valign="top">
	<th scope="row"><label for="i_api_user_lastname">Last Name</label></th>
        <td>
          <input type="text" name="i_api_user_lastname" id="i_api_user_lastname" value="<?php echo htmlspecialchars($user_lastname) ?>" size="50" /><br/>
        </td>
      </tr>
      <tr valign="top">
	<th scope="row"><label for="i_api_user_website">Nickname</label></th>
        <td>
          <input type="text" name="i_api_user_nickname" id="i_api_user_nickname" value="<?php echo htmlspecialchars($user_nickname) ?>" size="50" /><br/>
	  Defaults to the user's username.
        </td>
      </tr>
      <tr valign="top">
	<th scope="row"><label for="i_api_user_website">Display Name</label></th>
        <td>
          <input type="text" name="i_api_user_display_name" id="i_api_user_display_name" value="<?php echo htmlspecialchars($user_display_name) ?>" size="50" /><br/>
	  A string that will be shown on the site. Defaults to user's username.
        </td>
      </tr>
      <tr valign="top">
	<th scope="row"><label for="i_api_user_website">Website</label></th>
        <td>
          <input type="text" name="i_api_user_website" id="i_api_user_website" value="<?php echo htmlspecialchars($user_website) ?>" size="50" /><br/>
	  A string containing the user's URL for their web site.
        </td>
      </tr>
      <tr valign="top">
	<th scope="row"><label for="i_api_user_description">Biographical Info</label></th>
        <td>
          <input type="text" name="i_api_user_description" id="i_api_user_description" value="<?php echo htmlspecialchars($user_description) ?>" size="50" /><br/>
	  A string containing content about the user.
        </td>
      </tr>

    </table>

    <p class="submit">
      <input type="submit" name="Submit" value="Save Changes" />
    </p>
  </form>
</div>
<?php
		}
	}
}

// Load the plugin hooks, etc.
$integration_api_plugin = new IntegrationApiPlugin();


/*
 * Overriding this to provide the single sign-on function.  The user
 * doesn't have to click the login link; the system will automatically
 * log them in or out to match the current state returned by the API.
 */
if ( ((bool)get_option('i_api_single_signon')) && (! function_exists('get_currentuserinfo')) ) :
  function get_currentuserinfo() {
    global $current_user;

    if ( defined('XMLRPC_REQUEST') && XMLRPC_REQUEST )
      return false;

    if ( ! empty($current_user) )
      return;

    /*
     * If the API reports "logged out", make sure we're logged out in
     * Wordpress as well.
     */
    $api = new IntegrationApi(get_option('i_api_api_url'));
    if (! $api->is_logged_in()) {
      wp_set_current_user(0);
      wp_clear_auth_cookie();
      return false;
    }

    if ( ! $user = wp_validate_auth_cookie() ) {
      if ( empty($_COOKIE[LOGGED_IN_COOKIE]) || !$user = wp_validate_auth_cookie($_COOKIE[LOGGED_IN_COOKIE], 'logged_in') ) {
	/*
	 * The API reports "logged in", but we're not logged in to
	 * Wordpress.  Therefore, here we force the log in.
	 */
	$plugin      = new IntegrationApiPlugin();
	$user_record = $plugin->authenticate($api->user_info()->{'nickname'}, "pass");
	if ( is_wp_error($user_record) )
	  return false;
	
	wp_set_auth_cookie($user_record->ID, false, false);
	$user = $user_record->ID;
      }
    }

    wp_set_current_user($user);
  }
endif;



/*
 * Extending this function purely for extra error checking; this will
 * stop execution if the API is out of sync with Wordpress's "logged
 * in" status.
 */
if ($API_DEBUG && (! function_exists('is_user_logged_in()'))) :
  function is_user_logged_in() {
    $result = '';
    $user = wp_get_current_user();
    
    if ( $user->id == 0 )
      $result = false;
    else
      $result = true;

    $api = new IntegrationApi(get_option('i_api_api_url'));
    if ($api->is_logged_in()) {
      if (! $result)
	die ("Integration_API error: api yes, wp no.");
    }
    else {
      if ($result)
	die("Integration_API error: api no, wp yes.");
    }

    return $api->is_logged_in();
  }
endif;



?>
