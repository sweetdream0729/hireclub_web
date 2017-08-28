class AddIdProofToProviders < ActiveRecord::Migration[5.0]
  def change
  	add_column :providers, :id_proof_uid, :string
  	add_column :providers, :stripe_file_id, :string
  end
end
