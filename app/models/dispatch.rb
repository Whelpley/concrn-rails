class Dispatch < ActiveRecord::Base
  belongs_to :report
  belongs_to :responder
  validates_presence_of :report
  validates_presence_of :responder

  after_commit :alert_responder, on: :create

  def self.latest
    order('created_at desc').first
  end

  def rejected?
    status == "rejected"
  end

  def pending?
    status == "pending"
  end

  def accepted?
    status == "accepted"
  end

  def completed?
    status == "completed"
  end

  def accept!
    alert_reporting_party if update_attributes!(status: 'accepted')
  end

  def reject!
    acknowledge_rejection
    update_attributes!(status: 'pending', responder: nil)
  end

  def finish!
    thank_responder if update_attributes!(status: 'completed')
  end

  private

  def thank_responder
    Message.send "Thanks for your help. How did it go?", to: responder.phone
  end

  def acknowledge_rejection
    Message.send "We appreciate your timely rejection. Your report is being re-submitted.", to: responder.phone
  end

  def alert_responder
    Message.send report.responder_synopsis, to: responder.phone
  end

  def alert_reporting_party
    Message.send report.reporter_synopsis, to: report.phone
  end
end
