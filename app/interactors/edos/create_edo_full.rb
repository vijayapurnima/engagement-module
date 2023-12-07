class Edos::CreateEdoFull
  include Interactor

  # Call method used for creating all the entries required for adding a new EDO
  # Calls Form Service to create new forms
  #
  # @rest_param group_id [Integer] The id of the Business Service group to associate this EDO with
  # @rest_param group_type [String] The type of EDO to create, one of 'edo', 'non_edo'
  # @rest_param restrictions [String[]] The email restrictions to apply to the group
  # @rest_param tsbe_replacement [String The text to replace EDO name i.e. TSBE appearances in the form field labels
  def call

    #Make the base group
    group = Group.create!(group_id: context[:group_id], group_type: context[:group_type])

    #Duplicate the TSBE forms for the new EDO
    fake_user = EdoMembership.find_by_group_id(1).user
    forms = Forms::GetFormsByEdo.call(service_name: fake_user.service_name, access_type: 'owner').forms.map{ |form| Forms::GetForm.call(id: form['id'], current_user: fake_user).form }
    service_name = fake_user.service_name
    forms.each do |form|
      elems = form[:elements].to_json
      elems = elems.gsub(/#{service_name}/, context[:tsbe_replacement] || group.group_details(%(name))[:name])
      form[:elements] = JSON.parse(elems, symbolize_keys: true)
      form[:service] = 'EDOC-' + group.group_details(%(name))[:name]
      new_form = Forms::CreateForm.call(form_details: form.symbolize_keys)
    end

    #Make the restrictions
    Restriction.create(group: group, restriction_type: 'email', restrictions: context[:restrictions].to_json)

    context[:group] = group
  end
end
