class BulletinsAnalyze

  POSITIVE_WORDS = [
    'sérieu',
    'bon travail',
    'motivé',
    'enthousiaste',
    'dynamique',
    'potentiel',
    'félicitations',
    'encouragements',
    'excellent',
    'compliment',
    'volontaire '
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

  def initialize(html)
    @html = html
    @neural
  end

  def keywords
    unless @keywords
      @keywords = (positive + neutral + negative).sort_by { |w| w[:occurences] }.reverse
    end
    @keywords
  end

  def positive
    @positive ||= find(POSITIVE_WORDS, 'positive')
  end

  def neutral
    @neutral ||= find(NEUTRAL_WORDS, 'neutral') 
  end

  def negative
    @negative ||= find(NEGATIVE_WORDS, 'negative')
  end

  def positive_occurences_count
    @positive_occurences_count ||= count_occurences_in(positive)
  end

  def neutral_occurences_count
    @neutral_occurences_count ||= count_occurences_in(neutral)
  end

  def negative_occurences_count
    @negative_occurences_count ||= count_occurences_in(negative)
  end

  def keywords_occurences_count
    @keywords_occurences_count ||= count_occurences_in(keywords)
  end

  def percent_positive
    percent positive_occurences_count, keywords_occurences_count
  end

  def percent_neutral
    percent neutral_occurences_count, keywords_occurences_count
  end

  def percent_negative
    percent negative_occurences_count, keywords_occurences_count
  end

  protected

  def count_occurences_in(results)
    results.inject(0) { |sum, result| sum += result[:occurences] }
  end

  def percent(value, total)
    total.zero? ? 0
                : 100.0 * value / total
  end

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
