require 'file_mark'
class ImportKeywordWorker
  include Sidekiq::Worker
  include FileMark

  def read_list(list_file)
    File.readlines(list_file).map(&:chomp).uniq
  end

  def perform(list_file, ids = nil)
    with_locked_file list_file do
      list = read_list(list_file)
      list.each do |term|
        keyword = Keyword.where(title: term).first_or_create

        # search all current articles
        keyword.save_keyword_occurrence!
      end
    end
  end
end
