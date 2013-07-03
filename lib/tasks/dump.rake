namespace :dump do

  task rejected_reviews: :environment do
    require 'csv'

    Review.rejected.find_in_batches(batch_size: 100) do |batch|
      gen = CSV.generate do |csv|
        batch.each do |review|
          csv << [review.name, review.url]
        end
      end
      STDOUT.puts gen
    end
  end

  task accepted_reviews: :environment do
    require 'csv'

    Review.accepted.find_in_batches(batch_size: 100) do |batch|
      gen = CSV.generate do |csv|
        batch.each do |review|
          csv << [review.name, review.url]
        end
      end
      STDOUT.puts gen
    end
  end

end
