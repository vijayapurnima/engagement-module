namespace :users do

  desc "Push all users from Whitelabel Backend To EDO Presentation Service"
  task copy_users: :environment do
    puts 'Copying Users to Presentation Service'
    time = Benchmark.realtime do

      result = WhiteLabel::GetUsers.call()

      if result.success?

        users = result.users

        group = Group.find_by(group_id: SystemConfig.get('tsbe/group_id'))
        users.sort_by {|u| u[:id]}.each do |user|
          user = user.to_h.except(:auth_token)
          new_user = User.new(user)
          new_user.assign_attributes(verified:true)
          if new_user.save!
            result2= Edos::CreateEdoMembership.call(group_id: group.id, user_ref: new_user.try(:to_gid), role: "admin")
            unless result2.success?
              puts "Error occured while creating membership for the user", result2.message
            end
          end
        end

      else
        puts "Error occured while copying the users to EDO Presentation service ", result.message
      end
    end
    puts "Finished transforming Users to EDO Presentation service #{(time / 60).floor} minutes and #{(time % 60).round(2)} seconds"
  end
end

