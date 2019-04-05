/*global jQuery */
//= require jquery3
//= require rails-ujs
//= require activestorage
//= require popper
//= require bootstrap
//= require autolink

jQuery(function ($) {
    'use strict';
    var $content = $('#formulaire textarea').html().replace(/\n/g, "<br />");
    $('#formulaire textarea').replaceWith($content);
    $('#parcoursup').autolink();
    $('.synthesis textarea').replaceWith($content);
    $('.synthesis').autolink();
});