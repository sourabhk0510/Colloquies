// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

// For delete Answer
$(function(){
	$('.delete_post').bind('ajax:success', function() {
		alert("coming");
		$(this).closest('table').fadeOut();
	});
});


// for Answer Point
$(document).ready(function(){
	$("div#updatevote").click( function() {
	  var vote_action = $(this).attr('class');
		var id = $(this).attr('data-answer_id');
	  var user_status = $(this).attr('user_status');
	  if (user_status == 'user_unavilable') {
	    alert('Please Sign-in');
	    }else {  
		  $.ajax({
	  	  type: 'POST',
			  url: "/questions/update_vote",
	      data: {"id": id, "vote_action": vote_action},
		 	  success: function(data){
		 		$("#vote_answer_" + id).html(data);
	      },
	      error: function(data){
	      }
	    });
	  }
	});
});

// To Delete Question
$(document).ready(function(){
	$(".delete_question").click(function(){
	  var id = $(this).attr('data-question_id');
	  $.ajax({
	    type: "DELETE",
	    url: "/questions/" + id,
	    success: function (data) {
        $("#questions").html(data);
        alert("Succesfully Deleted")
     },
     error: function (){
        window.alert("something wrong!");
     }
	  });
	});
});