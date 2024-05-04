# Deprecated since 2 factors
# Code archived here but not functional
class Importers::Parcoursup

  scope :parcoursup_synced, -> { where.not(parcoursup_formulaire: nil)}

  def self.import(csv)
    require 'csv'
    rows = CSV.parse csv, {
      headers: :first_row,
      col_sep: ';'
    }
    rows.each do |row|
      number = row['Candidat - Code']
      validated = row['Vœu confirmé - Libellé'].to_s == 'Validée'
      if validated
        groupe = row['Groupe candidat - Code']
        type = groupe == '141307' ? Baccalaureat::TECH
                                  : Baccalaureat::GEN
        baccalaureat = Baccalaureat.with_title_and_parent(type, nil)
        # Terminale, 1ere année d'études supérieures...
        # Attention, espace initial dans le libellé
        niveau_etude = row[' Niveau Etude - Libellé 2022/2023']
        # Terminale, Année préparatoire aux études supérieures, BUT...
        type_formation = row['Type Formation - Libellé  2022/2023']
        # Série Générale, Sciences et Technologies de l'Industrie et du Développement Durable, Bac pro...
        serie = row['Série - Libellé']
        # Uniquement pour certains bacs : Système informatique et numérique, Energies et environnement...
        specialite = row['Spécialité / Mention - Libellé  2022/2023']
        # Bacs
        title = serie
        unless title.blank?
          baccalaureat = Baccalaureat.with_title_and_parent(title, baccalaureat)
          title = specialite
          unless title.blank?
            baccalaureat = Baccalaureat.with_title_and_parent(title, baccalaureat)
          end
        end
        # Niveau 
        level = ""
        level += niveau_etude if niveau_etude.present?
        level += " - #{type_formation}" if type_formation.present? && (type_formation != niveau_etude)
        level += " - #{serie}" if serie.present?
        level += " - #{specialite}" if specialite.present?
        # Infos
        first_name = row['Candidat - Prénom']
        last_name = row['Candidat - Nom']
        gender = row['Sexe']
        baccalaureat_mention = row['Mention Obtenue - Libellé']
        scholarship = row['Candidat boursier - Libellé'].to_s == 'Boursier de l\'enseignement scolaire'
        # Création
        candidate = Candidate.where(number: number).first_or_create
        candidate.gender = gender
        candidate.first_name = first_name
        candidate.last_name = last_name
        candidate.baccalaureat_mention = baccalaureat_mention
        candidate.baccalaureat = baccalaureat
        candidate.level = level
        candidate.scholarship = scholarship
        candidate.dossier_note = Note.average(row)
        if candidate.valid?
          puts "Created candidate #{number}"
          candidate.save
        else
          byebug
        end
      else
        Candidate.where(number: number).destroy_all
        puts "Deleted candidate #{number}"
      end
    end
  end

  def parcoursup_synced?
    !parcoursup_formulaire.blank?
  end

  def parcoursup_sync!
    Parcoursup::PARTS.each do |part|
      key = parcoursup_part_to_key(part)
      value = self.send key
      if value.blank?
        value = Parcoursup.instance.load_page(number, part)
        update_column key, value
        sleep 1
      end
    end
  end

  def find_production!
    return unless parcoursup_synced?
    # Formulaire
    formulaire = parcoursup_clean('formulaire')
    doc = Nokogiri::HTML formulaire
    text = doc.at('textarea').text
    self.production_in_formulaire = !text.blank?
    # Somewhere else
    http_found = false
    http_found = true if 'http'.in? formulaire
    parcoursup_lettre_motivation = parcoursup_clean('lettre_motivation')
    http_found = true if 'http'.in? parcoursup_lettre_motivation
    self.production_somewhere_else = http_found
    # Auto attribute modifier
    if !self.production_in_formulaire && !self.production_somewhere_else
      puts id
      Evaluation.no_url id, 1 # Arnaud
    end
    # Analyzed
    self.production_analyzed = true
    save
  end

  def parcoursup(part)
    key = parcoursup_part_to_key(part)
    self.send key
  end

  def parcoursup_clean(part)
    raw = parcoursup part
    return '' if raw.nil?
    doc = Nokogiri::HTML raw
    doc.xpath('//script').remove
    doc.xpath('//style').remove
    doc.at('body').inner_html
  end

  def parcoursup_load(part)
    Parcoursup.instance.load_page(number, part)
  end

  def parcoursup_part_to_key(part)
    "parcoursup_#{part.underscore}".to_sym
  end

  def parcoursup_synthesis_lettre_motivation
    letter = parcoursup_clean 'lettre_motivation'
    doc = Nokogiri::HTML letter
    doc.at('#div_lm_consult').inner_html
  end

  def parcoursup_synthesis_formulaire
    formulaire = parcoursup_clean 'formulaire'
    doc = Nokogiri::HTML formulaire
    doc.at('.divGlobalFormulaire').inner_html
  end

  def is_there_a_document?
    ! 'Le candidat n\'a pas téléversé de document'.in?(parcoursup_documents)
  end
end
