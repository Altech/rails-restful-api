class Api::V2::BaseController < ApplicationController
  include ActionController::Serialization

  include Api::RestfulControllerConcern

  before_action :prepare_restful_params

  serialization_scope :current_user

  rescue_from Api::RescuableError do |exception|
    response.headers['X-Error-Message'] = exception.message.to_s
    response.headers['X-Error-Code']    = exception.error_code.to_s

    render json: {
      message: exception.message,
      error_code: exception.error_code,
    }, status: exception.http_status
  end
end
