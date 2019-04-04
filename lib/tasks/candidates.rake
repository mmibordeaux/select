namespace :candidates do
  desc "Sync all candidates"
  task sync: :environment do
    Candidate.sync_all
    # Candidate.first.parcoursup_sync!
  end
end
