require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"

class ImportGcalActionsService
  include Callable

  attr_reader :calendar_summary, :calendar_id, :start, :summary, :description, :starting_datetime, :ending_datetime

  def initialize(kw_args)
    @calendar_id = kw_args.fetch(:calendar_id, "ihocidn4tm9afnvd3lbpmorj5k@group.calendar.google.com")
    @calendar_summary = kw_args.fetch(:calendar_summary, "Actions by mihai.banulescu@gmail.com")
    @starting_datetime = kw_args.fetch(:starting_date, Time.now.at_beginning_of_week)
    @ending_datetime = kw_args.fetch(:ending_date, Time.now)
  end

  def call
    # action_events = RetrieveGcalActionsService.call(
    #   calendar_id,
    #   calendar_summary,
    #   starting_datetime,
    #   ending_datetime,
    # )

    # action_events.each do |event_info|
    #   import_action(event_info)
    # end
  end

  private

  def import_action(event_info)
  end
end

