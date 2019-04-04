class AddParcoursupDataToCandidates < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :parcoursup_entete, :text
    add_column :candidates, :parcoursup_scolarite, :text
    add_column :candidates, :parcoursup_activites_centres_interet, :text
    add_column :candidates, :parcoursup_bac, :text
    add_column :candidates, :parcoursup_bulletins, :text
    add_column :candidates, :parcoursup_ael, :text
    add_column :candidates, :parcoursup_lettre_motivation, :text
    add_column :candidates, :parcoursup_groupe, :text
    add_column :candidates, :parcoursup_documents, :text
    add_column :candidates, :parcoursup_formulaire, :text
  end
end
