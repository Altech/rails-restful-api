class Api::V2::CompaniesController < Api::V2::BaseController
  before_action :set_company, only: [:show]

  def show
    render json: @company
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end
end
