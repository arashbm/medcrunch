module FileMark
  def mark_dataset(dataset, mark='marked')
    Sidekiq.redis do |redis|
      redis.sadd "datasets:#{mark}", dataset.to_s
    end
  end
  def unmark_dataset(dataset, mark='marked')
    Sidekiq.redis do |redis|
      redis.srem "datasets:#{mark}", dataset.to_s
    end
  end
  def dataset_marked?(dataset, mark='marked')
    Sidekiq.redis do |redis|
      return redis.sismember "datasets:#{mark}", dataset.to_s
    end
  end

  # this will do the given block within a lock to keep xml files safe
  def with_locked_file(filename)
    puts "locking #{filename}"
    if dataset_marked?(filename, 'locked') 
      raise "already marked as locked"
    end
    # actual locking
    mark_dataset(filename, 'locked')
    begin
      yield
    ensure
      puts "unlocking #{filename}"
      # actual unlocking
      unmark_dataset(filename, 'locked')
    end
  end
end
