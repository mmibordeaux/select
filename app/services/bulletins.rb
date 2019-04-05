class Bulletins
  include Singleton

  POSITIVE_WORDS = [
    'sérieux',
    'bon travail',
    'motivé',
    'enthousiaste',
    'dynamique',
    'potentiel',
    'félicitations',
    'encouragements',
    'excellent'
  ]

  NEUTRAL_WORDS = [
    'moyen',
    'convenable',
    'correct'
  ]

  NEGATIVE_WORDS = [
    'difficultés',
    'insuffisant',
    'décevant',
    'fragil',
    'résultats inégaux',
    'superficiel',
    'manque d\'implication',
    'catastrophique',
    'absen',
    'passable',
    'bavard',
    'aucun travail'
  ]

  def self.keywords(html)
    instance.extract(html)
  end

  def extract(html)
    @html = html
    @keywords = find(POSITIVE_WORDS, 'positive') + find(NEUTRAL_WORDS, 'neutral') + find(NEGATIVE_WORDS, 'negative')
    @keywords.sort_by { |w| w[:occurences] }.reverse
  end

  protected

  def find(words, kind)
    text = @html.downcase
    results = []
    words.each do |word|
      occurences = text.gsub(word.downcase).count
      if occurences > 0
        results << {
          word: word.capitalize,
          occurences: occurences,
          kind: kind
        }
      end
    end
    results
  end
end
