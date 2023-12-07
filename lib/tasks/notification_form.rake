namespace :notification_form do

  desc "Add a notification form"
  task create: :environment do
    time = Benchmark.realtime do

      comm = {
          title: 'Notification',
          service: ApplicationController::SERVICE_NAME[0, 4],
          elements: [
              {
                  type: 'field',
                  priority: 0,
                  entity: {
                      field_type: 'input',
                      show: true,
                      edit: true,
                      name: 'title',
                      label: 'Notification Title',
                      required: true,
                      placeholder: 'Enter a title'
                  }
              },
              {
                  type: 'field',
                  priority: 1,
                  entity: {
                      field_type: 'textarea',
                      show: true,
                      edit: true,
                      name: 'notification_text',
                      label: 'Notification Text',
                      required: true,
                      placeholder: 'Type your message here...'
                  }
              },
              {
                  type: 'field',
                  priority: 3,
                  entity: {
                      field_type: 'textarea',
                      show: true,
                      edit: true,
                      name: 'notification_comment',
                      label: 'Comments',
                      required: false,
                      placeholder: 'Type your comments here...'
                  }

              }
          ]
      }
      result = Groups::GetGroup.call(group_id: SystemConfig.get('tsbe/group_id'))
      if result.success?
        puts "EDO details were retrieved Successfully"
        edo_data = result.group
        result = Forms::CreateForm.call(form_details: comm, service: edo_data[:name])
        if result.success?
          puts "Created a notification form with id #{result.form['id']}"
        else
          puts "Created a notification form failed"
        end
      else
        puts "Unable to retrieve edo details"
      end

    end

    puts "Finished creating notification_form form in #{(time / 60).floor} minutes and #{(time % 60).round(2)} seconds"
  end

end
