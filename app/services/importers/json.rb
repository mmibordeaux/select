class Importers::Json
  BACS_GEN = [
    'Série Générale', 
    'Générale',
    'Professionnelle',
    'Professionnelle Agricole',
    'Economique et social',
    'Littéraire',
    'Scientifique',
    'DAEU'
  ]

  def initialize(path)
    @path = path
    import
  end

  protected

  def import
    clean_all
    candidates.each do |candidate|
      import_candidate(candidate)
    end
  end

  def clean_all
    Candidate.destroy_all
    Candidate.connection.execute('ALTER SEQUENCE candidates_id_seq RESTART WITH 1')
    Baccalaureat.destroy_all
    Baccalaureat.connection.execute('ALTER SEQUENCE baccalaureats_id_seq RESTART WITH 1')
  end
  
  # DonneesCandidats
  # CriteresSociaux
  # DonneesSportifHautNiveau
  # DonneesArtisteHautNiveau
  # ActivitesCentresInteret
  # Scolarite
  # BulletinsScolaires
  # FicheAvenir
  # NotesFicheAvenir
  # Baccalaureat
  # NotesBaccalaureat
  # DonneesVoeux
  # QuestionsReponses
  # FormulaireDematerialise
  def import_candidate(data)
    return if data['DonneesVoeux']['CandidatureConfirmeeLibelle'] == 'Non validée'
    candidate = Candidate.new
    candidate.data = data
    candidate.number = data['DonneesCandidats']['NumeroDossierCandidat']
    candidate.first_name = data['DonneesCandidats']['PrenomCandidat']
    candidate.last_name = data['DonneesCandidats']['NomCandidat']
    candidate.gender = data['DonneesCandidats']['Sexe']
    candidate.parcoursup_lettre_motivation = data['DonneesVoeux']['LettreDeMotivation']
    candidate.baccalaureat = build_baccalaureat(data)
    candidate.baccalaureat_mention = data['Baccalaureat']['MentionObtenueLibelle']
    candidate.level = build_level(data)
    candidate.scholarship = has_scholarship?(data)
    candidate.dossier_note = average_note_with_defaults(data)
    candidate.save
    # byebug if candidate.number == '1447482'
    puts candidate
  end

  def build_baccalaureat(data)
    serie = data['Baccalaureat']['SerieDiplomeLibelle']
    gen_or_tech = serie.in?(BACS_GEN) ? Baccalaureat::GEN
                                      : Baccalaureat::TECH
    # Racine
    bac = Baccalaureat.with_title_and_parent(gen_or_tech, nil)
    # Type de bac
    bac = Baccalaureat.with_title_and_parent(serie, bac)
    # Spécialité
    bac = Baccalaureat.with_title_and_parent(data['Baccalaureat']['SpecialiteLibelle'], bac)
    # Option
    bac = Baccalaureat.with_title_and_parent(data['Baccalaureat']['OptionBacLibelle'], bac)
    bac
  end

  def build_level(data)
    level = data['DonneesCandidats']['ProfilCandidatLibelle']
    sport_art = data['DonneesCandidats']['SportifOuArtisteLibelle']
    level += " - #{sport_art}" if !sport_art.in?(['Ni sportif, ni artiste', 'Non renseigné'])
    level
  end

  def average_note(data)
    all_notes = []
    # Donnée plus disponible dans l'export JSON
    # all_notes.concat build_notes_avenir(data)
    all_notes.concat build_notes_bac(data)
    all_notes.concat build_notes_bulletins(data)
    all_notes.flatten!
    all_notes.compact!
    all_notes.sum / all_notes.size.to_f
  end

  def average_note_with_defaults(data)
    note = average_note(data)
    return Candidate::DEFAULT_NOTE if note.nan? || note.zero?
    note
  end

  def build_notes_avenir(data)
    data.dig('NotesFicheAvenir').map do |note| 
      convert_note note.dig('MoyenneCandidat')
    end
  end
  
  def build_notes_bac(data)
    data.dig('NotesBaccalaureat').map do |note|
      convert_note note.dig('NoteEpreuve')
    end
  end
  
  def build_notes_bulletins(data)
    notes = []
    data.dig('BulletinsScolaires').each do |year|
      year.dig('BulletinsScolairesAnnee', 'BulletinsScolairesSeries').each do |period|
        period.dig('BulletinsScolairesParPeriode').each do |bulletin|
          note = bulletin.dig('MoyenneduCandidat')
          next if note == 'N'
          next if note == 'Aucune note'
          notes << convert_note(note)
        end
      end
    end
    notes
  end

  def has_scholarship?(data)
    data['CriteresSociaux']['CandidatboursierLibelle'] != 'Non boursier'
  end

  def convert_note(note)
    return nil if note.nil? || note.blank? 
    note.gsub(',', '.').to_f
  end

  def full_data
    @full_data ||= URI.open(@path) { |file| file.read }
  end

  def json
    @json ||= JSON.parse full_data
  end

  def candidates
    @candidates ||= json['exportDeDonnees']['exportCandidats'].first['candidats']
  end
end
