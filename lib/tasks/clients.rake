namespace :clients do
  desc "Create clients for dinamic count"
  task create: :environment do
    count = ENV["COUNT"].to_i

    if count <= 0
      puts "❌ Please provide COUNT=N (example: bundle exec rake clients:create COUNT=20)"
      exit
    end

    puts "➡️ Creating #{count} clients..."

    count.times do |i|
      FactoryBot.create(:client)
    end

     puts "✅ #{count} clients created successfully!"
  end
end
