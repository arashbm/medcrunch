require 'pp'
relations = KeywordsRelation.all
kwds = Keyword.all.to_a

adj_mat = []
kwds.count.times { adj_mat << Array.new(kwds.count, 0).dup}

relations.each do |r|
  i = kwds.find_index { |k| k.id == r.keyword_first_id }
  j = kwds.find_index { |k| k.id == r.keyword_last_id }
  adj_mat[i][j] = adj_mat[j][i] = r.weight
end

kwds.map! do |k|
  [k.title]
end

while kwds.count > 1

  # nobody has a relation with themself!
  kwds.each_with_index { |k, i| adj_mat[i][i] = 0.0 }

  # find maximum connected keywords
  max = adj_mat.map(&:max).max
  i = adj_mat.map(&:max).find_index(max)
  j = adj_mat[i].find_index(max)

  if i == j
    # all are equal and separate islands
    break
  end

  # merge
  first = [i,j].min
  last = [i,j].max

  kwds.each_with_index do |kwd, index|
    new_weight = (adj_mat[index][first] + adj_mat[index][last])/2.0
    adj_mat[index][first] = adj_mat[first][index] = new_weight
  end
  
  adj_mat.slice!(last)
  adj_mat.map { |row| row.slice!(last) }

  kwds[first] = [kwds[last], kwds[first]]
  kwds.slice!(last)
end

print kwds.to_json
