class StaticPagesController < ApplicationController
  def index
    @team_photos = MetaInspector.new('https://8thlight.com/team/').images
  end
end
