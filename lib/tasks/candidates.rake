namespace :candidates do
  desc "Reset all candidates and baccalaureats database"
  task reset: :environment do
    Candidate.destroy_all
    Baccalaureat.destroy_all
  end

  desc "Sync all candidates"
  task sync: :environment do
    Candidate.find_each do |candidate|
      candidate.parcoursup_sync! unless candidate.parcoursup_synced?
    end
    # Candidate.first.parcoursup_sync!
  end

  desc "Look for productions"
  task find_productions: :environment do
    Candidate.find_each do |candidate|
      candidate.find_production!
    end
    # Candidate.first.find_production!
  end

  desc "Split between users"
  task split: :environment do
    users = User.evaluators
    candidates = Candidate.todo.order(:id)
    candidates_per_user = (1.0 * candidates.count / users.count).ceil
    users.each_with_index do |user, index|
      candidates_for_user = candidates.limit(candidates_per_user).offset(candidates_per_user * index)
      candidates_for_user.update_all(attributed_to_id: user.id)
    end
  end

  desc "Positionize"
  task positionize: :environment do
    Candidate.positionize
  end

  desc "Recompute notes"
  task recompute_notes: :environment do
    Candidate.recompute_notes
  end
end
