module ControlPanelHelper

  def valid_ical_link(link)
    begin
      calendar_file = open(link, &:read)
      Icalendar::Calendar.parse(calendar_file).length > 0
    rescue
      false
    end
  end
end