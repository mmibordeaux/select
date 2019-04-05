class Note
  def self.average(row)
    # Avoid row[96..97]
    notes = [row[18]] + row[21..95] + row[98..1000]
    notes_quantity = 0
    notes_sum = 0.0
    notes.each do |note|
      next if note.nil?
      note_f = note.gsub(',', '.').to_f
      notes_sum += note_f
      notes_quantity += 1
      puts "Adding note #{note_f}, #{notes_quantity} total notes"
    end
    notes_quantity.zero?  ? 0.0
                          : notes_sum / notes_quantity
  end
end