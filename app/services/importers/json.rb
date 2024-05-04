class Importers::Json
  BACS_GEN = [
    'Série Générale', 
    'Générale',
    'Professionnelle',
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
    Baccalaureat.destroy_all
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
    candidate.number = data['DonneesCandidats']['NumeroDossierCandidat']
    candidate.first_name = data['DonneesCandidats']['PrenomCandidat']
    candidate.last_name = data['DonneesCandidats']['NomCandidat']
    candidate.gender = data['DonneesCandidats']['Sexe']
    candidate.parcoursup_lettre_motivation = data['DonneesVoeux']['ProjetMotive']
    candidate.baccalaureat = baccalaureat(data)
    candidate.baccalaureat_mention = data['Baccalaureat']['MentionObtenueLibelle']
    candidate.save
    # byebug
  end

  def baccalaureat(data)
    serie = data['Baccalaureat']['SerieDiplomeLibelle']
    gen_or_tech = serie.in?(BACS_GEN) ? Baccalaureat::GEN
                                      : Baccalaureat::TECH
    type = Baccalaureat.with_title_and_parent(gen_or_tech, nil)
    Baccalaureat.with_title_and_parent(serie, type)
  end

  def data
    @data ||= File.read(@path)
  end

  def json
    @json ||= JSON.parse data
  end

  def candidates
    @candidates ||= json['exportDeDonnees']['exportCandidats'].first['candidats']
  end
end
