class KeywordRelationWorker
  include Sidekiq::Worker

  def perform(ids=nil)
    list = []
    ks = if ids
           Keyword.select(:id).where(id: ids).to_a
         else
           Keyword.select(:id).to_a
         end
    ks.each do |keyword|
      keyword.neighbour_keyword_ids.each do |k|
        list << [keyword.id, k['weight'].to_i, k['keyword_id'].to_i] if k['keyword_id'].to_i > keyword.id
      end
    end
    KeywordsRelation.import [:keyword_first_id, :weight, :keyword_last_id], list, validate: false
  end
end
