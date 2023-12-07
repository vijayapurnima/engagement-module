namespace :restrictions do

  desc "Add restrictions to EDO's"
  task create: :environment do
    time = Benchmark.realtime do

      restriction_type = "email"
      edo_id = SystemConfig.get("tsbe/group_id")
      restrictions = ["tsbe.com.au"]
      group = Group.find_by(group_id: edo_id)
      restriction = Restriction.create!(restriction_type: restriction_type, group_id: group.id, restrictions: restrictions)

      restriction.save!


    end

    puts "Finished adding restrictions to TSBE EDO  in #{(time / 60).floor} minutes and #{(time % 60).round(2)} seconds"
  end

end
