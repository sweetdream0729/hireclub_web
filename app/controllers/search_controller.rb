class SearchController < ApplicationController
  def index
    get_results
  end

  def jobs
    get_results("Job")
    render :index
  end

  def projects
    get_results("Project")
    render :index
  end

  def members
    get_results("User")
    render :index
  end

  def companies
    get_results("Company")
    render :index
  end

  def skills
    get_results("Skill")
    render :index
  end

  def communities
    get_results("Community")
    render :index
  end

  def get_results(type = nil)
    @searchable_type = type
    @query = params[:q]
    @page = params[:page]

    if @searchable_type.present?
      @results = PgSearch.multisearch(@query).where(:searchable_type => @searchable_type).page(@page).per(10)
    else
      @results = PgSearch.multisearch(@query).page(@page).per(10)
    end

    AnalyticsEvent.create_search_event({query: @query, type: @searchable_type, page: @page}, current_user, request)
  end
end
