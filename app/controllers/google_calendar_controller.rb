class GoogleCalendarController < ApplicationController

  def get_calendar_events calid 
    client = Google::Apis::CalendarV3::CalendarService.new
    secrets = File.open('client_secret.json')

    client = Signet::OAuth2::Client.new({
      client_id: '37448837042-85sb5fo8ci2vll891jvq8kqm3at0mn0c.apps.googleusercontent.com',
      client_secret: 'LsoOzdnfpokjgzYhNbQ-Hruu'
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri
    })
  
    scope =  'https://www.googleapis.com/auth/calendar'
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open('cal_secret.json'),
      scope: scope)
    authorizer.fetch_access_token!
    

    client = Google::Apis::CalendarV3::CalendarService.new
    client.authorization = authorizer

    calendar = cal_id
    
    begin
      client.list_events(calendar)
    rescue Google::Apis::AuthorizationError => exception
      puts exception
    end
  end

  def redirect
    client = Signet::OAuth2::Client.new({
      client_id: '37448837042-85sb5fo8ci2vll891jvq8kqm3at0mn0c.apps.googleusercontent.com',
      client_secret: 'LsoOzdnfpokjgzYhNbQ-Hruu'
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri:
    })

    
  end

  def callback
  end

  def show
  end


end