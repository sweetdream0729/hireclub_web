class ProviderRelayJob < ApplicationJob
  queue_as :urgent

  def perform(id, action)
    if action == "update"
    	Provider::UpdateProvider.new(id).call
    elsif action == "delete"
    	Provider::DeleteProvider.new(id).call
    end
  end
end
