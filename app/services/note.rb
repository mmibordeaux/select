class Note
  def self.average(row)
    range = row[26..-1]
    notes = []
    range.each_with_index do |value, index|
      unless value.blank?
        next if value.length > 5
        note = value.to_f
        notes << note
        puts "Adding note #{note}"
      end
    end
    average = notes.any?  ? notes.sum / notes.count
                          : 0.0
    puts "#{notes.count} total notes, average #{average}"
    average
  end
end
