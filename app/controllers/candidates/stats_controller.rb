class Candidates::StatsController < ApplicationController
	def index
    @candidates = Candidate.all
	end
end