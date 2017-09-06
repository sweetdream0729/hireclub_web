class ProviderUpdateJob < ApplicationJob
  queue_as :urgent

  def perform(id, provider)
    Provider::UpdateProvider.new(id, provider).call
  end
end
