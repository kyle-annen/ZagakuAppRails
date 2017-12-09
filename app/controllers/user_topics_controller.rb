class UserTopicsController < ApplicationController
  def create
    UserTopic.create(
      topic_version: user_topics_params[:topic_version],
      topic_id: user_topics_params[:topic_id],
      user_id: current_user.id
    )

    redirect_to "/learning-trails/#{user_topics_params[:topic_id]}"
  end

  private

  def user_topics_params
    params.permit(:topic_version, :topic_id)
  end
end
