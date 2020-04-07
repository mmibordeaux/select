class Note
  def self.average(row)
    notes = row[71..220] + row[223..663] + row[666..1106]
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
