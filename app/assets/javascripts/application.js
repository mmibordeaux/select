/*global jQuery */
//= require jquery3
//= require rails-ujs
//= require activestorage
//= require popper
//= require bootstrap
//= require autolink
//= require jquery.mark.min
//= require Chart.bundle
//= require chartkick

jQuery(function ($) {
    'use strict';
    if ($('#formulaire').length > 0) {

        var $content = $('#formulaire textarea').html().replace(/\n/g, "<br />");
        $('#formulaire textarea').replaceWith($content);
        $('#parcoursup').autolink();
        $('.synthesis textarea').replaceWith($content);
        $('.synthesis').autolink();

        $('.marked').mark([
            'html',
            'python',
            'php',
            'css',
            'mooc',
            'tournage',
            'developpement',
            'javascript',
            'openclassroom',
            'jeu vidéo',
            'jeux vidéos',
            'webmaster',
            'reseaux sociaux',
            'communication',
            'sécurité',
            'community manager',
            'design graphique',
            'courts-métrages',
            'montage',
            'site web',
            'photoshop',
            'illustrator',
            'audiovisuel',
            'stage',
            'cadrage',
            'prise de son',
            'mao',
            'programmation',
            'infographie',
            'web design',
            'photographe',
            'artistique',
            'seo',
            'indesign',
            'photographie',
            'web marketing',
            'anglais',
            'game designer',
            'webdesign',
            'motion',
            'métier',
            'groupe',
            'équipe',
            'autodidacte',
            'apprendre',
            'apprentissage',
            'portes ouvertes',
            'jpo'
        ], {
            separateWordSearch: false,
            exclude: ['.labelInputText', '.titreCkeditor']
        });
    }
});