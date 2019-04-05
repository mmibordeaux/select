class Bulletins
  include Singleton

  POSITIVE_WORDS = [
    'sérieux',
    'bon travail',
    'satisfaisant',
    'motivé',
    'enthousiaste',
    'dynamique',
    'potentiel',
    'félicitations',
    'encouragements'
  ]

  NEGATIVE_WORDS = [
    'difficultés',
    'insuffisant',
    'décevant',
    'fragile',
    'résultats inégaux',
    'superficiel',
    'manque d\'implication',
    'résultats moyens',
    'catastrophique',
    'absent',
    'passable',
    'bavard'
  ]

  def self.keywords(html)
    instance.extract(html)
  end

  def extract(html)
    @html = html
    @keywords = find(POSITIVE_WORDS, 'positive') + find(NEGATIVE_WORDS, 'negative')
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
