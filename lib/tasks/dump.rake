namespace :dump do

  task :approved_reviews do
    require 'csv'

    Review.find_in_batches(batch_size: 100) do |batch|
      CSV.generate do |csv|
        batch.each do |review|
          csv << [review.name, review.url]
        end
      end
    end

  end
end
