class QuestionsCleanupJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Rails.logger.info "Hello World"
  end
end
