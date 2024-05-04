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