class AddAttributionsToCandidates < ActiveRecord::Migration[5.2]
  def change
    add_reference :candidates, :attributed_to
  end
end
