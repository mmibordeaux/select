namespace :candidates do
  desc "Sync all candidates"
  task sync: :environment do
    Candidate.sync_all
    # Candidate.first.parcoursup_sync!
  end

  desc "Look for productions"
  task find_productions: :environment do
    Candidate.find_all_productions
    # Candidate.first.find_production!
  end
end
