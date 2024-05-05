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

# Modificateurs 2024

Situation particulière, la question Parcoursup sur les productions a été supprimée (erreur administrative).


### 1. Productions numériques

| Titre     | Description                                                                                                                                                                 | Valeur | 
|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|
| Excellentes productions                             | Qui mettent en valeur les compétences du candidat sur le fond (portfolio qui parle du projet professionnel) mais également la forme (site avec cms ou codé ad hoc, vidéo de bonne qualité, blog avec rédactionnel...) | 10      |
| Productions correctes                               | Pertinent mais de qualité moyenne, ou de bonne qualité mais pas pertinent                                                         | 5      |
| Productions disponibles mais peu ou pas pertinentes | PPT, partie de jeu vidéo, photos de vacances, dessins pas aboutis…                                                                | 0      |
| Rien                                                | Pas de productions                                                                                                                | -10    |

### 2. Comportement et engagement

| Titre                           | Description                                                                      | Valeur |
|---------------------------------|----------------------------------------------------------------------------------|--------|
| Excellent                       | Pro-actif, moteur, participation, engagement citoyen…                            | 10     |  
| Bon comportement                | Un ensemble convenable                                                           | 5      | 
| Comportement neutre             | Ne dénote pas d’une attitude, d’une conduite le prédisposant à travailler en MMI | 0      | 
| Comportement très problématique | Insolence, trop de bavardage, absence totale de travail, grave immaturité…       | -10    |

### 3. Projet professionnel

| Titre     | Description                                                                                                                             | Valeur |
|-----------|-----------------------------------------------------------------------------------------------------------------------------------------|--------|
| Excellent | A rencontré des professionnels, a effectué des stages, se projette après le DUT concrètement, projet professionnel clairement identifié | 10     |  
| Bon       | Bien renseigné sur les compétences, sur les métiers, projet professionnel qui se dessine                                                | 6      |  
| Moyen     | Vision confuse des métiers, des compétences nécessaires, projet professionnel trop succinct                                             | 2      |  
| Mauvais   | Aucune conscience des réalités du terrain, attentiste, pas de projet professionnel                                                      | 0      |  

### 4. Curiosité et culture numérique

| Titre     | Description                                                                                                                             | Valeur |
|-----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|
| Excellent | Compétences techniques (avérées ou potentielles) dans plusieurs domaines (voire équilibrées entre les trois parcours !), excellente connaissance en culture numérique, identifie plusieurs actualités récentes en lien avec le web | 10     |
| Bon       | Mise en valeur de compétences (avérées ou potentielles) dans un domaine, rebondit sur une actualité récente du numérique                | 6      |
| Moyen     | Difficultés pressenties à appréhender certains contenus de la formation, faible culture numérique                                       | 2      | 
| Mauvais   | Culture numérique inexistante                                                                                                           | 0      |

### 5. Conviction du jury

| Titre     | Description                                                                              | Valeur |
|-----------|------------------------------------------------------------------------------------------|--------|
| Excellent | Le jury est unanimement convaincu de la grande qualité de la candidature pour le BUT MMI | 10     |
| Neutre    |                                                                                          | 0      |


# Modificateurs avant 2023

## Dossiers

### Qualité du parcours scolaire

| Titre                           | Description                                                                      | Valeur |
|---------------------------------|----------------------------------------------------------------------------------|--------|
| Excellent comportement          | étudiant pro-actif, moteur, participation, engagement citoyen…                   | 3      | 
| Bon comportement                | Un ensemble convenable                                                           | 1      | 
| Comportement neutre             | Ne dénote pas d’une attitude, d’une conduite le prédisposant à travailler en MMI | 0      | 
| Comportement très problématique | Insolence, trop de bavardage, absence totale de travail, grave immaturité…       | -5     |

### Projet de formation motivé

| Titre                                     | Description                                                                                                                        | Valeur |
|-------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------|--------|
| Projet professionnel clairement identifié | Connaissance des métiers, rencontre de professionnels, activités en lien avec MMI et bonne culture web…                            | 3      |
| Projet professionnel qui se dessine       | Au moins un secteur d'activité identifié                                                                                           | 1      |
| Projet professionnel flou                 | Projet trop succinct, amalgames dans les cœurs de métiers préparés en MMI, fausse idée des exigences ou débouchés de la formation… | 0      |
| Projet professionnel inexistant           | Aucune connaissance du PPN, aucune connaissance des futurs métiers MMI, aucun débouché identifié…                                  | -4     |

### Intérêt du projet en ligne

| Titre                                               | Description                                                                                                                                                                                                                                | Valeur |
|-----------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|
| Excellentes productions                             | Qui mettent en valeur les compétences du candidat sur le fond (portfolio qui parle du projet professionnel) mais également la forme (site type wixi/tumblr ou cms ou développé en code, vidéo de bonne qualité, blog avec rédactionnel...) | 6      |
| Productions correctes                               | Pertinent mais de qualité moyenne, ou de bonne qualité mais pas pertinent                                                                                                                                                                  | 3      |
| Productions disponibles mais peu ou pas pertinentes | PPT, partie de jeu vidéo, photos de vacances, dessins pas aboutis…                                                                                                                                                                         | 0      |
| Rien                                                | pas de production en ligne                                                                                                                                                                                                                 | -10    |

### Motivation pour la spécialité

| Titre                  | Description                                                             | Valeur |
|------------------------|-------------------------------------------------------------------------|--------|
| Très bonne motivation  | Dynamisme, compétences dans plusieurs domaines de la formation…         | 3      |
| Bonne motivation       | Au moins une compétence identifiée                                      | 1      |
| Motivation mitigée     | Aucune compétence mise en valeur…                                       | 0      |
| Motivation inexistante | Difficultés majeures identifiées sur certains domaines de la formation… | -4     |

## Entretiens

### 1. Connaissances de la formation

| Titre     | Description                                                                                                                                                                 | Valeur | 
|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|
| Excellent | Excellente connaissance des contenus et spécificités de la formation, des ateliers thématiques, venu aux JPO, motivé pour s’installer à Bordeaux                            | 6      |
| Bon       | Bonne connaissance des contenus en MMI sans connaître le mode de fonctionnement en atelier thématique du département de Bordeaux, conscient des efforts à fournir           | 2      |
| Moyen     | Niveau d’information faible sur la formation, se positionne par rapport à des clichés, fausse idée des exigences ou débouchés de la formation                               | 1      |
| Mauvais   | Niveau d’information inexistant sur la formation, ne mesure pas la somme de travail demandée en DUT, difficultés majeures identifiées sur certains domaines de la formation | 0      |

### 2. Construction du projet professionnel

| Titre     | Description                                                                                                                             | Valeur |
|-----------|-----------------------------------------------------------------------------------------------------------------------------------------|--------|
| Excellent | A rencontré des professionnels, a effectué des stages, se projette après le DUT concrètement, projet professionnel clairement identifié | 6      |  
| Bon       | Bien renseigné sur les compétences, sur les métiers, projet professionnel qui se dessine                                                | 2      |  
| Moyen     | Vision confuse des métiers, des compétences nécessaires, projet professionnel trop succinct                                             | 1      |  
| Mauvais   | Aucune conscience des réalités du terrain, attentiste, pas de projet professionnel                                                      | 0      |  

### 3. Motivation

| Titre     | Description                                                                                                                                                                             | Valeur | 
|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|
| Excellent | Excellente motivation, sens de l’organisation, capacité à travailler en équipe, à apprendre/s’auto-former, à gérer un projet ou une équipe, implication citoyenne dans des associations | 6      |
| Bon       | Dynamisme, qualités d’écoute, sérieux, souci de bien faire                                                                                                                              | 2      |
| Moyen     | Difficultés à travailler en équipe, manque de maturité et d’autonomie                                                                                                                   | 1      |
| Mauvais   | Aucune motivation mise en valeur, nonchalance, passivité lors de l’entretien                                                                                                            | 0      |

### 4. Curiosité et culture générale / MMI

| Titre     | Description                                                                                                                                                                                                                  | Valeur |
|-----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------|
| Excellent | Compétences techniques (avérées ou potentielles) dans plusieurs domaines (voire équilibrées entre les trois parcours !), excellente connaissance en culture web, identifie plusieurs actualités récentes en lien avec le web | 6      |
| Bon       | Mise en valeur de compétences (avérées ou potentielles) dans un domaine, rebondit sur une actualité récente du web                                                                                                           | 2      |
| Moyen     | Difficultés pressenties à appréhender certains contenus de la formation, faible culture web                                                                                                                                  | 1      | 
| Mauvais   | Culture web inexistante                                                                                                                                                                                                      | 0      |

### 5. Capacité d’argumentation et de conviction

| Titre     | Description                                                                                             | Valeur |
|-----------|---------------------------------------------------------------------------------------------------------|--------|
| Excellent | Argumentaire très préparé, réponses pertinentes, finesse d’analyse et perspicacité dans le raisonnement | 6      |
| Bon       | Réponses claires et construites, argumentaire cohérent                                                  | 2      |
| Moyen     | Réponses superficielles, voire confuses, flottements lors de l’entretien                                | 1      |
| Mauvais   | Timidité excessive, aucune argumentation, beaucoup d’appréhension et de réticences lors de l’entretien  | 0      |
