class SearchHistoryHandler < ApplicationService
  attr_reader :query, :new_search

  def initialize(options = {})
    @query = options[:search]
    @new_search = options[:page].to_i.zero?
  end

  def call
    return unless query.present?
    return unless new_search

    increment_or_create
  end

  private

  def increment_or_create
    search_history = SearchHistory.find_by(query: query)

    if search_history
      search_history.increment!(:view_count)
    else
      SearchHistory.create(query: query)
    end
  end
end
