
dojo.addOnLoad(site_init);

/*
 * Perform site-wide initialization
 */
function site_init() {	
	load_widgets();
	// if the current page has a page_init function, call that
	if(typeof page_init == 'function') { 
		page_init();
	}
}

function $(id) {
	return document.getElementById(id);	
}

function submit_wall_post() {
	before_wall_post();
	dojo.xhrPost({
	    form: "wall_post_entry_form",
	    timeout: 3000, // give up after 3 seconds
	    content: { authenticity_token:authenticity_token },
		load: function (data) {wall_post_saved(data);}
	});
	//return false;
}

function delete_wall_post(id) {
	dojo.xhrPost({
		url: '/wall_posts/delete',
	    timeout: 3000, // give up after 3 seconds
	    content: { id:id, authenticity_token:authenticity_token },
		load: function (data) {wall_post_deleted(data);}
	});	
}

function wall_post_deleted(request) {
	$('wall_posts_content').innerHTML = request;
	// clear wall post message area, need to clear tinymce i think
	$('wall_post_message').value == '';
}

function before_wall_post() {
	tinyMCE.triggerSave(true,true);
	$('wall_post_entry').style.display = 'none';
}

// have to call this after the new tinymce editor is loaded upon a save
// tinyMCE.execCommand('mceAddControl', false, id); 


function wall_post_saved(request) {
	$('wall_posts_content').innerHTML = request;
	// clear wall post message area, need to clear tinymce i think
	$('wall_post_message').value == '';
}

function show_wall_post_entry() {
	var wipeIn = dojo.fx.wipeIn({node: "wall_post_entry",duration: 200});
	wipeIn.play();
}

function cancel_wall_post() {
	var wipeOut = dojo.fx.wipeOut({node: "wall_post_entry",duration: 200});
	wipeOut.play();
}

/*
$(document).ajaxSend(function(event, request, settings) {
  if (typeof(AUTH_TOKEN) == "undefined") return;
  // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
  settings.data = settings.data || "";
  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
}); */

function handle_promote_to_admin_btn() {
	var rows = dijit.byId('gridNode').selection.getSelected();
	for (i=0; i<rows.length; i++) {
		// send ajax request to promote user to group admin
		dojo.xhrPost({
			url: '/memberships/update',
		    timeout: 3000, // give up after 3 seconds
		    content: { id:rows[i].id, admin:true, authenticity_token:authenticity_token },
			load: function (data) {member_promoted(data);}
		});	
	}
}

function member_promoted(data) {
	alert('member promoted = ' + data);
}

function handle_demote_from_admin_btn() {
	var rows = dijit.byId('gridNode').selection.getSelected();
	for (i=0; i<rows.length; i++) {
		// send ajax request to demote user from group admin
		dojo.xhrPost({
			url: '/memberships/update',
		    timeout: 3000, // give up after 3 seconds
		    content: { id:rows[i].id, admin:false, authenticity_token:authenticity_token },
			load: function (data) {member_demoted(data);}
		});	
	}
}

function member_promoted(data) {
	alert('member promoted = ' + data);
}

function handle_remove_from_group_btn() {
	var rows = dijit.byId('gridNode').selection.getSelected();
	for (i=0; i<rows.length; i++) {
		alert(rows[i].id);
		// send ajax request to remove user from group
		// goes through the membership controller
	}
}

function handle_select_all_members() {
	if ($("manage_group_users_table" + " INPUT[type='checkbox']").attr('checked') == false) {
		$("manage_group_users_table" + " INPUT[type='checkbox']").attr('checked', false);
	}
	else {
		$("manage_group_users_table" + " INPUT[type='checkbox']").attr('checked', true);
	}
    return false;
}

function sort_users() {
	location.href = 'users?sort_field=' + $("sort_users_sel").value;
}

function sort_groups() {
	location.href = 'groups?sort_field=' + $("sort_groups_sel").value;
}

function display_blog_settings() {
	if (document.getElementById('blog_settings').style.display == 'none') {
		// get current settings from server
		
		// display settings
		document.getElementById('blog_settings').style.display="block";
	}
	else {
		// hide settings
		document.getElementById('blog_settings').style.display="none";
		
		// save to server
		//   call RssFeedsController.update method
		// after save, redisplay blog widget
	}
}

function show_blog_drafts() {
	var drafts = dojo.query(".blog_post_draft");
	if (drafts.length > 0 && (drafts[0].style.display == 'none' || drafts[0].style.display == '')) {
		// select all elements with class 'blog_post_draft' and change display
		// property to 'block'
		for (i=0; i<drafts.length; i++) {
			drafts[i].style.display = 'block';
		}
		$('show_drafts_btn').innerHTML = 'Hide Drafts';
	}
	else if (drafts.length > 0) {
		// select all elements with class 'blog_post_draft' and change display
		// property to 'hide'
		for (i=0; i<drafts.length; i++) {
			drafts[i].style.display = 'none';
		}
		$('show_drafts_btn').innerHTML = 'Show Drafts';
	}
}

function post_status(event) {
    //event.preventDefault();
    //event.stopPropagation();
	dojo.xhrPost({
	    form: "status_post_entry_form",
	    timeout: 3000, // give up after 3 seconds
	    content: { authenticity_token:authenticity_token },
		load: function (data) {status_post_saved(data);}
	});
}

// Called after new status successfully posted to server
// now we want to refresh the activity stream and activity post widgets to reflect new content
function status_post_saved(data) {
	refresh_profile_widget('activity_feed_profile');
	refresh_profile_widget('status_posts_profile');
}

function get_widget(content, url, widget_name) {
	dojo.xhrGet({
		url: url,
	    timeout: 10000, // give up after 10 seconds
		content: content,
		error: function (data) {
			widget_load_error(widget_name, data);
		},
		load: function (data) {
			widget_loaded(widget_name, data);
		}
	});
}

/*
 * Called when the Only Statuses checkbox is checked in the activity stream of a users profile page.
 */
function filter_activities() {
	var status = dojo.byId('status_checkbox').checked;
	var include_friends = dojo.byId('friends_checkbox').checked;
	if (status == true && include_friends == true) {
		content = { name:'activity_feed_profile', only_statuses:'true', include_friends:'true', user_id:user_id, authenticity_token:authenticity_token };
		get_widget(content, '/widgets/load_profile_widget', 'activity_feed_profile');
	}
	else if (status == true) {
		content = { name:'activity_feed_profile', only_statuses:'true', user_id:user_id, authenticity_token:authenticity_token };
		get_widget(content, '/widgets/load_profile_widget', 'activity_feed_profile');
	}
	else if (include_friends == true) {
		content = { name:'activity_feed_profile', include_friends:'true', user_id:user_id, authenticity_token:authenticity_token };
		get_widget(content, '/widgets/load_profile_widget', 'activity_feed_profile');
	}
	else {
		refresh_profile_widget('activity_feed_profile')
	}
}

/*
 * Called when the Only Friends checkbox is checked in the activity stream on the home page.
 */
function only_friends_activities() {
	var include_friends = dojo.byId('friends_checkbox').checked;
	if (include_friends == true) {
		content = { name:'activity_feed_home', include_friends:'true', authenticity_token:authenticity_token };
		get_widget(content, '/widgets/load', 'activity_feed_home');
	}
	else {
		refresh_home_widget('activity_feed_home')
	}
}

/*
 * Called when the Include Friends checkbox is checked in the activity stream of a user's profile page.
 */
function friends_activities() {
	var status = dojo.byId('status_checkbox').checked;
	var include_friends = dojo.byId('friends_checkbox').checked;
	if (status == true && include_friends == true) {
		content = { name:'activity_feed_profile', only_statuses:'true', include_friends:'true', user_id:user_id, authenticity_token:authenticity_token };
		get_widget(content, '/widgets/load_profile_widget', 'activity_feed_profile');
	}
	else if (include_friends == true) {
		content = { name:'activity_feed_profile', include_friends:'true', user_id:user_id, authenticity_token:authenticity_token };
		get_widget(content, '/widgets/load_profile_widget', 'activity_feed_profile');
	}
	else if (status == true) {
		content = { name:'activity_feed_profile', only_statuses:'true', user_id:user_id, authenticity_token:authenticity_token };
		get_widget(content, '/widgets/load_profile_widget', 'activity_feed_profile');	
	}
	else {
		refresh_profile_widget('activity_feed_profile')
	}
}

function add_new_topic() {
	alert('new topic');
}

function message_delete() {
	alert('delete');
}

function add_blog_post_comment() {
	//tinyMCE.triggerSave(true,true);
	dojo.xhrPost({
	    form: "comment_entry_form",
	    timeout: 3000, // give up after 3 seconds
	    content: { authenticity_token:authenticity_token },
		load: function (data) {blog_post_comment_saved(data);}
	});
}

function blog_post_comment_saved(request) {
	$('blog_post_comments_area').innerHTML = request;
}

function add_photo_comment() {
	//tinyMCE.triggerSave(true,true);
	dojo.xhrPost({
	    form: "comment_entry_form",
	    timeout: 3000, // give up after 3 seconds
	    content: { authenticity_token:authenticity_token },
		load: function (data) {photo_comment_saved(data);}
	});
}

function photo_comment_saved(request) {
	$('photo_comments_area').innerHTML = request;
}

function submit_forum_post_reply() {
	tinyMCE.triggerSave(true,true);
	dojo.xhrPost({
	    form: "forum_post_reply_form",
	    timeout: 3000, // give up after 3 seconds
	    content: { authenticity_token:authenticity_token },
		load: function (data) {forum_post_reply_saved(data);}
	});	
}

function forum_post_reply_saved(request) {
	$('existing_replies').innerHTML = request;
	tinyMCE.activeEditor.setContent("");
}


try
{
    var IE = (navigator.userAgent.toLowerCase().indexOf("msie") != -1 ? true : false);
}
catch(e)
{
    var IE = false;
}

// Resizes the content div to the appropriate size.
// Should only be needed for IE
function ResizeContentDiv()
{
    var winHeight = window.innerHeight;
    if(winHeight == undefined){ winHeight = document.body.clientHeight; }

    if(winHeight > 0)
    {
        document.getElementById('middle').style.height = ( winHeight - 156 );
    }
}

// Unfortunately SlideDown does not work in IE,
// hence this implementation.
// Show the properties of the folder
function ShowProperties()
{
    if(IE)
    {
        Element.hide('list');
        Element.show('folder_rights');
    }
    else
    {
        new Effect.SlideUp('list', {queue: 'front'});
        new Effect.SlideDown('folder_rights', {queue: 'end'});
    }
    Element.show('list_link');
    Element.hide('rights_link');
    return false;
}

// Show the sub-folders and files in a folder
function ShowList()
{
    if(IE)
    {
        Element.hide('folder_rights');
        Element.show('list');
    }
    else
    {
        new Effect.SlideUp('folder_rights', {queue: 'front'});
        new Effect.SlideDown('list', {queue: 'end'});
    }
    Element.show('rights_link');
    Element.hide('list_link');
    return false;
}

// Create, Update and Delete is only possible when Reading is allowed too.
// By using this function onclick of the Read checkbox, you make sure that if
// Reading is not allowed Create, Update and Delete is not allow either.
function UncheckCreateUpdateDelete(checked, group)
{
    if(!checked)
    {
        eval("document.getElementById('create_check_box_" + group + "').checked = false");
        eval("document.getElementById('update_check_box_" + group + "').checked = false");
        eval("document.getElementById('delete_check_box_" + group + "').checked = false");
    }
}

// By using this function onclick of the Create, Update and Delete checkbox,

// you make sure that if Create, Update and Delete is allowed, Reading is allowed too.
function CheckRead(checked, group)
{
    if(checked)
    {
        eval("document.getElementById('read_check_box_" + group + "').checked = true");
    }
}

// Javascript framework
// for upload progress.
var UploadProgress = {
  uploading: null,
  monitor: function(upid) {
    if(!this.periodicExecuter) {
      this.periodicExecuter = new PeriodicalExecuter(function() {
        if(!UploadProgress.uploading) return;
        new Ajax.Request('/file/progress?upload_id=' + upid);
      }, 3);
    }

    this.uploading = true;
    this.StatusBar.create();
  },

  update: function(total, current) {
    if(!this.uploading) return;
    var status     = current / total;
    var statusHTML = status.toPercentage();
    $('results').innerHTML   = statusHTML + "<br /><small>" + current.toHumanSize() + ' of ' + total.toHumanSize() + " uploaded.</small>";
    this.StatusBar.update(status, statusHTML);
  },

  
  finish: function(return_url) {
    this.uploading = false;
    this.StatusBar.finish();
    $('results').innerHTML = 'finished!';
    window.parent.location.href = return_url;
  },
  
  cancel: function(msg) {
    if(!this.uploading) return;
    this.uploading = false;
    if(this.StatusBar.statusText) this.StatusBar.statusText.innerHTML = msg || 'canceled';
  },
  
  StatusBar: {
    statusBar: null,
    statusText: null,
    statusBarWidth: 500,
  
    create: function() {
      Element.hide('initial-status');
      this.statusBar  = this._createStatus('status-bar');
      this.statusText = this._createStatus('status-text');
      this.statusText.innerHTML  = '0%';
      this.statusBar.style.width = '0';
    },

    update: function(status, statusHTML) {
      this.statusText.innerHTML = statusHTML;
      this.statusBar.style.width = Math.floor(this.statusBarWidth * status);
    },

    finish: function() {
      this.statusText.innerHTML  = '100%';
      this.statusBar.style.width = '100%';
    },
    
    _createStatus: function(id) {
      el = $(id);
      if(!el) {
        el = document.createElement('span');
        el.setAttribute('id', id);
        $('progress-bar').appendChild(el);
      }
      return el;
    }
  },
  
  FileField: {
    add: function() {
      new Insertion.Bottom('file-fields', '<p style="display:none"><input id="data" name="data" type="file" /> <a href="#" onclick="UploadProgress.FileField.remove(this);return false;">x</a></p>')
      $$('#file-fields p').last().visualEffect('blind_down', {duration:0.3});
    },
    
    remove: function(anchor) {
      anchor.parentNode.visualEffect('drop_out', {duration:0.25});
    }
  }
}

Number.prototype.bytes     = function() { return this; };
Number.prototype.kilobytes = function() { return this *  1024; };
Number.prototype.megabytes = function() { return this * (1024).kilobytes(); };
Number.prototype.gigabytes = function() { return this * (1024).megabytes(); };
Number.prototype.terabytes = function() { return this * (1024).gigabytes(); };
Number.prototype.petabytes = function() { return this * (1024).terabytes(); };
Number.prototype.exabytes =  function() { return this * (1024).petabytes(); };
['byte', 'kilobyte', 'megabyte', 'gigabyte', 'terabyte', 'petabyte', 'exabyte'].each(function(meth) {
  Number.prototype[meth] = Number.prototype[meth+'s'];
});

Number.prototype.toPrecision = function() {
  var precision = arguments[0] || 2;
  var s         = Math.round(this * Math.pow(10, precision)).toString();
  var pos       = s.length - precision;
  var last      = s.substr(pos, precision);
  return s.substr(0, pos) + (last.match("^0{" + precision + "}$") ? '' : '.' + last);
}

// (1/10).toPercentage()
// # => '10%'
Number.prototype.toPercentage = function() {
  return (this * 100).toPrecision() + '%';
}

Number.prototype.toHumanSize = function() {
  if(this < (1).kilobyte())  return this + " Bytes";
  if(this < (1).megabyte())  return (this / (1).kilobyte()).toPrecision()  + ' KB';
  if(this < (1).gigabytes()) return (this / (1).megabyte()).toPrecision()  + ' MB';
  if(this < (1).terabytes()) return (this / (1).gigabytes()).toPrecision() + ' GB';
  if(this < (1).petabytes()) return (this / (1).terabytes()).toPrecision() + ' TB';
  if(this < (1).exabytes())  return (this / (1).petabytes()).toPrecision() + ' PB';
                             return (this / (1).exabytes()).toPrecision()  + ' EB';
}

