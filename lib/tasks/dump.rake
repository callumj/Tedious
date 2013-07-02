namespace :dump do

  task :accepted_reviews do
    require 'csv'

    Review.accepted.find_in_batches(batch_size: 100) do |batch|
      CSV.generate do |csv|
        batch.each do |review|
          csv << [review.name, review.url]
        end
      end
    end

  end
end
