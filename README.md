# README

    rake candidates:reset

    rake candidates:sync

    rake candidates:find_productions

    rake candidates:split_first_evaluation

    rake candidates:split_second_evaluation

    rake candidates:positionize

    rake candidates:recompute_notes

    rake app:import data=tmp/data.json

## Phases

### Evaluation

Lecture de tous les dossiers importés de Parcoursup.

### Entretien

Entretien avec les candidats.

### Sélection

Classement des candidats sur liste principale et secondaire.

# Import JSON

Mettre à disposition temporairement les données JSON sur une URL https.

Avec dropbox, il faut appeler ce type d'url, avec le `dl=1`
```
rake app:import data="https://www.dropbox.com/scl/fi/[id]/[filename].json?rlkey=[key]&dl=1"
```

En ligne, c'est 
```
scalingo run --app mmibordeaux-select run bash
```

Puis on passe les commandes.

# Modificateurs

## Dossiers

### Qualité du parcours scolaire

| Titre                           | Description                                                                      | Valeur | Candidats |
|---------------------------------|----------------------------------------------------------------------------------|--------|-----------|
| Excellent comportement          | étudiant pro-actif, moteur, participation, engagement citoyen…                   | 3      | 0         | 
| Bon comportement                | Un ensemble convenable                                                           | 1      | 0         | 
| Comportement neutre             | Ne dénote pas d’une attitude, d’une conduite le prédisposant à travailler en MMI | 0      | 0         | 
| Comportement très problématique | Insolence, trop de bavardage, absence totale de travail, grave immaturité…       | -5     | 0         | 

### Projet de formation motivé

| Titre                                     | Description                                                                                                                        | Valeur | Candidats |
|-------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------|--------|-----------|
| Projet professionnel clairement identifié | Connaissance des métiers, rencontre de professionnels, activités en lien avec MMI et bonne culture web…                            | 3      | 0         | 
| Projet professionnel qui se dessine       | Au moins un secteur d'activité identifié                                                                                           | 1      | 0         | 
| Projet professionnel flou                 | Projet trop succinct, amalgames dans les cœurs de métiers préparés en MMI, fausse idée des exigences ou débouchés de la formation… | 0      | 0         | 
| Projet professionnel inexistant           | Aucune connaissance du PPN, aucune connaissance des futurs métiers MMI, aucun débouché identifié…                                  | -4     | 0         | 

### Intérêt du projet en ligne

| Titre                                               | Description                                                                                                                                                                                                                                | Valeur | Candidats |
|-----------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|-----------|
| Excellentes productions                             | Qui mettent en valeur les compétences du candidat sur le fond (portfolio qui parle du projet professionnel) mais également la forme (site type wixi/tumblr ou cms ou développé en code, vidéo de bonne qualité, blog avec rédactionnel...) | 6      | 0         | 
| Productions correctes                               | Pertinent mais de qualité moyenne, ou de bonne qualité mais pas pertinent                                                                                                                                                                  | 3      | 0         | 
| Productions disponibles mais peu ou pas pertinentes | PPT, partie de jeu vidéo, photos de vacances, dessins pas aboutis…                                                                                                                                                                         | 0      | 0         | 
| Rien                                                | pas de production en ligne                                                                                                                                                                                                                 | -10    | 0         | 
### Motivation pour la spécialité

| Titre                  | Description                                                             | Valeur | Candidats |
|------------------------|-------------------------------------------------------------------------|--------|-----------|
| Très bonne motivation  | Dynamisme, compétences dans plusieurs domaines de la formation…         | 3      | 0         | 
| Bonne motivation       | Au moins une compétence identifiée                                      | 1      | 0         | 
| Motivation mitigée     | Aucune compétence mise en valeur…                                       | 0      | 0         | 
| Motivation inexistante | Difficultés majeures identifiées sur certains domaines de la formation… | -4     | 0         | 

## Entretiens

### 1. Connaissances de la formation

| Titre     | Description                                                                                                                                                                 | Valeur | Candidats |
|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|-----------|
| Excellent | Excellente connaissance des contenus et spécificités de la formation, des ateliers thématiques, venu aux JPO, motivé pour s’installer à Bordeaux                            | 6      | 0         | 
| Bon       | Bonne connaissance des contenus en MMI sans connaître le mode de fonctionnement en atelier thématique du département de Bordeaux, conscient des efforts à fournir           | 2      | 0         | 
| Moyen     | Niveau d’information faible sur la formation, se positionne par rapport à des clichés, fausse idée des exigences ou débouchés de la formation                               | 1      | 0         | 
| Mauvais   | Niveau d’information inexistant sur la formation, ne mesure pas la somme de travail demandée en DUT, difficultés majeures identifiées sur certains domaines de la formation | 0      | 0         | 

### 2. Construction du projet professionnel

| Titre     | Description                                                                                                                             | Valeur | Candidats |
|-----------|-----------------------------------------------------------------------------------------------------------------------------------------|--------|-----------|
| Excellent | A rencontré des professionnels, a effectué des stages, se projette après le DUT concrètement, projet professionnel clairement identifié | 6      | 0         | 
| Bon       | Bien renseigné sur les compétences, sur les métiers, projet professionnel qui se dessine                                                | 2      | 0         | 
| Moyen     | Vision confuse des métiers, des compétences nécessaires, projet professionnel trop succinct                                             | 1      | 0         | 
| Mauvais   | Aucune conscience des réalités du terrain, attentiste, pas de projet professionnel                                                      | 0      | 0         | 

### 3. Motivation

| Titre     | Description                                                                                                                                                                             | Valeur | Candidats |
|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|-----------|
| Excellent | Excellente motivation, sens de l’organisation, capacité à travailler en équipe, à apprendre/s’auto-former, à gérer un projet ou une équipe, implication citoyenne dans des associations | 6      | 0         | 
| Bon       | Dynamisme, qualités d’écoute, sérieux, souci de bien faire                                                                                                                              | 2      | 0         | 
| Moyen     | Difficultés à travailler en équipe, manque de maturité et d’autonomie                                                                                                                   | 1      | 0         | 
| Mauvais   | Aucune motivation mise en valeur, nonchalance, passivité lors de l’entretien                                                                                                            | 0      | 0         | 

### 4. Curiosité et culture générale / MMI

| Titre     | Description                                                                                                                                                                                                                  | Valeur | Candidats |
|-----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|-----------|
| Excellent | Compétences techniques (avérées ou potentielles) dans plusieurs domaines (voire équilibrées entre les trois parcours !), excellente connaissance en culture web, identifie plusieurs actualités récentes en lien avec le web | 6      | 0         | 
| Bon       | Mise en valeur de compétences (avérées ou potentielles) dans un domaine, rebondit sur une actualité récente du web                                                                                                           | 2      | 0         | 
| Moyen     | Difficultés pressenties à appréhender certains contenus de la formation, faible culture web                                                                                                                                  | 1      | 0         | 
| Mauvais   | Culture web inexistante                                                                                                                                                                                                      | 0      | 0         | 

### 5. Capacité d’argumentation et de conviction

| Titre     | Description                                                                                             | Valeur | Candidats |
|-----------|---------------------------------------------------------------------------------------------------------|--------|-----------|
| Excellent | Argumentaire très préparé, réponses pertinentes, finesse d’analyse et perspicacité dans le raisonnement | 6      | 0         | 
| Bon       | Réponses claires et construites, argumentaire cohérent                                                  | 2      | 0         | 
| Moyen     | Réponses superficielles, voire confuses, flottements lors de l’entretien                                | 1      | 0         | 
| Mauvais   | Timidité excessive, aucune argumentation, beaucoup d’appréhension et de réticences lors de l’entretien  | 0      | 0         | 
