class ProviderDeleteJob < ApplicationJob
  queue_as :urgent

  def perform(id)
    Provider::DeleteProvider.new(id).call
  end
end
