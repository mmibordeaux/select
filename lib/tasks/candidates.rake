namespace :candidates do
  desc "Reset all candidates and baccalaureats database"
  task reset: :environment do
    Candidate.destroy_all
    Baccalaureat.destroy_all
    User.where(id: [11, 9, 12]).destroy_all
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

  desc "Split randomly between users"
  task split_random: :environment do
    users = User.evaluators
    candidates = Candidate.todo.order(:id)
    candidates_per_user = (1.0 * candidates.count / users.count).ceil
    users.each_with_index do |user, index|
      candidates_for_user = candidates.limit(candidates_per_user).offset(candidates_per_user * index)
      candidates_for_user.update_all(attributed_to_id: user.id)
    end
  end

  desc "Split first evaluation with quotas"
  task split_first_evaluation: :environment do
    candidates_left = Candidate.with_no_evaluation.count
    if candidates_left.zero?
      puts "All candidates split"
      next # https://stackoverflow.com/questions/2316475/how-do-i-return-early-from-a-rake-task
    end
    users = User.evaluators.order(:first_evaluation_quota, :first_evaluation_baccalaureats)
    users_left = users.count
    candidates_planned_ids = []
    users.each do |user|
      unless user.first_evaluation_baccalaureats.blank?
        baccalaureats = Baccalaureat.where(id: user.first_evaluation_baccalaureats.split(','))
        baccalaureats_ids = baccalaureats.map { |b| b.children_ids }.flatten
        candidates = Candidate.where(baccalaureat: baccalaureats_ids)
      else
        candidates = Candidate.with_no_evaluation
      end
      candidates = candidates.where.not(id: candidates_planned_ids)
      max_candidates = (1.0 * candidates_left / users_left).ceil
      quantity = user.first_evaluation_quota  ? [max_candidates, user.first_evaluation_quota].min
                                              : max_candidates
      ids = attribute_evaluations user, candidates, quantity
      candidates_planned_ids += ids
      candidates_left -= ids.count
      users_left -= 1
    end
  end

  desc "Split second evaluation"
  task split_second_evaluation: :environment do
    candidates_ids = []
    Candidate.each do |candidate|

    end
  end

  def attribute_evaluations(user, candidates, quantity)
    puts "Attributing #{quantity} candidates to #{user} from #{candidates.count} possible candidates"
    candidates_planned_ids = []
    candidates.order("RANDOM()").limit(quantity).each do |candidate|
      user.evaluations.where(candidate: candidate).first_or_create
      candidates_planned_ids << candidate.id
    end
    candidates_planned_ids
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
