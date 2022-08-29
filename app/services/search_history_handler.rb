class SearchHistoryHandler
  def initialize(search, page)
    @search = search
    @page = page.to_i
  end

  def call
    increment_or_create
  end

  private

  def increment_or_create
    search_history = SearchHistory.find_by(query: @search)

    if search_history && @page.zero?
      search_history.increment!(:view_count)
    elsif @search.present?
      SearchHistory.create(query: @search)
    end
  end
end
