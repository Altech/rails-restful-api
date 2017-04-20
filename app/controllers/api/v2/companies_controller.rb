class Api::V2::CompaniesController < Api::V2::BaseController
  before_action :set_company, only: [:show]

  def index
    @companies = Company.all

    @companies = preload_for(@companies)

    render json: setup_pagination(@companies),
      fields: @fields,
      include: @include
  end

  def show
    render json: @company,
      fields: @fields,
      include: @include
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end
end
