require 'csv'

namespace :import do
  desc "Import candidates from csv"
  # rake import:candidates './tmp/dossiers.csv'
  task candidates: :environment do
    path = ARGV.last
    csv = CSV.open path, headers: :first_row, col_sep: ';'
    csv.each do |row|

      title = 'Général'
      baccalaureat = Baccalaureat.where(title: title).first_or_create
      title = row[11]
      unless title.blank?
        baccalaureat = Baccalaureat.where(title: title, parent: baccalaureat).first_or_create
        title = row[12]
        unless title.blank?
          baccalaureat = Baccalaureat.where(title: title, parent: baccalaureat).first_or_create
        end
      end

      number = row[5]
      first_name = row[7]
      last_name = row[6]
      candidate = Candidate.where(number: number).first_or_create
      candidate.first_name = first_name
      candidate.last_name = last_name
      candidate.baccalaureat = baccalaureat
      candidate.save
      puts "Created candidate #{number}"
    end
  end
end
