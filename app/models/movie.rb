class Movie < ActiveRecord::Base
    
    def self.all_ratings
        ['G','PG','PG-13','R','NC-17']
    end
    
    # Performs case insensitive matching for rating.
    def self.with_ratings(ratings)
        ratings = ratings.uniq {|item| item.upcase}
        Movie.where('upper(rating) in (?)', ratings)
    end
    
end
