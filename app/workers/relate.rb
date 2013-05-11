class KeywordRelationWorker
  include Sidekiq::Worker

  def perform
    KeywordsRelation.delete_all
    list = []
    Keyword.select(:id).find_each do |keyword|
      keyword.neighbour_keyword_ids.each do |k|
        list << [keyword.id, k['weight'].to_i, k['keyword_id'].to_i] if k['keyword_id'].to_i > keyword.id
      end
    end
    KeywordsRelation.import [:keyword_first_id, :weight, :keyword_last_id], list, validate: false
  end
end
