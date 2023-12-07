# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'rainbow'

Dotenv::Railtie.load


puts 'Seeding DATA...'
SeedFu.quiet = true
SeedFu.seed


# #1. Add TSBE Group to Groups table

# group = Group.find_or_create_by!(group_id: SystemConfig.get("tsbe/group_id"), group_type: "edo")
# group.save!

# # Method for checking forms
# def check_form(form_result, new_comm, service, form_type)
#   changed_flag = false
#   deleted_flag = false
#   if form_result && form_result.success?
#     form = form_result.form
#     puts "form title :::::::", form[:title]
#     deleted_flag = true if form[:elements].length > new_comm[:elements].length
#     changed_flag = true if form[:elements].length < new_comm[:elements].length
#     form[:elements].each do |ele|
#       form_ele = new_comm[:elements].select {|element| element if (ele[:type].eql?(element[:type]) && ele[:priority].eql?(element[:priority]) && ele[:entity][:field_type].eql?(element[:entity][:field_type]))}
#       break if deleted_flag.eql?(true)
#       if form_ele.length.positive?
#         unless (form_ele.first[:entity][:default].nil? || form_ele.first[:entity][:default].eql?(ele[:entity][:default])) &&
#             (form_ele.first[:entity][:label].nil? || form_ele.first[:entity][:label].eql?(ele[:entity][:label])) &&
#             (form_ele.first[:entity][:single].nil? || (form_ele.first[:entity][:single]).to_s.eql?((ele[:entity][:single]).to_s)) &&
#             ((form_ele.first[:entity][:required] || false).to_s.eql?(ele[:entity][:required].to_s)) &&
#             (form_ele.first[:entity].except(:required, :default, :single, :label).sort == ele[:entity].except(:id, :min, :max, :tooltip, :default, :help_text, :required, :single, :label).sort)
#           changed_flag ||= true
#         end
#       else
#         deleted_flag ||= true
#       end
#     end
#     if deleted_flag.eql?(true)
#       # New form doesn't contain some fields which exists in existing form
#       form[:service] += "-REPLACED"
#     elsif changed_flag.eql?(true)
#       # New form contains changes with existing form
#       new_comm[:elements].each do |ele|
#         form_ele = form[:elements].select {|element| element if (ele[:type].eql?(element[:type]) && ele[:priority].eql?(element[:priority]) && ele[:entity][:field_type].eql?(element[:entity][:field_type]))}
#         if form_ele.length.positive?
#           ele[:entity].each do |key, value|
#             form_ele.first[:entity][key] = value
#           end
#         else
#           form[:elements] << ele
#         end
#       end
#     else
#       puts "#{form_type} form with id #{form[:id]},title  #{form[:title]}  has no changes"
#     end
#     if deleted_flag.eql?(true) || changed_flag.eql?(true)
#       result = Forms::UpdateForm.call(form_id: form[:id], form_details: form, service: service)
#       if result.success?
#         puts "#{form_type} Form ID #{result[:form]['id']} updated"
#       else
#         puts "Error, #{form_type} form update failed: #{result}"
#       end
#     end
#   end
#   unless form_result && form_result.success? && deleted_flag.eql?(false)
#     result = Forms::CreateForm.call(form_details: new_comm, service: service)
#     if result.success?
#       puts "Created a #{form_type} form with id #{result.form['id']}"
#     else
#       puts "Created a #{form_type} form failed"
#     end
#   end
# end

# #2. TSBE Forms creation

# forms = [
#     {
#         title: 'Notice',
#         service: 'EDOC-TSBE',
#         elements: [
#             {
#                 type: 'field',
#                 priority: 0,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'subject',
#                     label: 'Subject',
#                     required: true,
#                     placeholder: 'Enter a subject'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 1,
#                 entity: {
#                     field_type: 'textarea',
#                     show: true,
#                     edit: true,
#                     name: 'notice_text',
#                     label: 'Notice Text',
#                     required: true,
#                     placeholder: ''
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 2,
#                 entity: {
#                     field_type: 'select',
#                     show: true,
#                     edit: true,
#                     name: 'notice_type',
#                     label: 'Notice Type',
#                     required: true,
#                     default: 'General',
#                     choices: ['General', 'Feedback']
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 3,
#                 entity: {
#                     field_type: 'file',
#                     show: true,
#                     edit: true,
#                     name: 'attachment',
#                     label: 'Attachments(s)',
#                     required: true
#                 }
#             },
#         ]
#     },
#     {
#         title: 'EOI Warning',
#         service: 'EDOC-TSBE',
#         elements: [
#             {
#                 type: 'field',
#                 priority: 0,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'subject',
#                     label: 'Subject',
#                     required: true,
#                     placeholder: 'Enter a subject'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 1,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'pkg_name',
#                     label: 'Package Name'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 2,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'pkg_desc',
#                     label: 'Package Description'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 3,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'pkg_release',
#                     label: 'Package Release'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 4,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'pkg_start_dt',
#                     label: 'Package Start Date'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 5,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'sup_profile',
#                     label: 'What do you look for in a supplier profile?'
#                 }
#             }
#         ]
#     },
#     {
#         title: 'Member Promotion',
#         description: '',
#         service: 'EDOC-TSBE',
#         elements: [
#             {
#                 type: 'field',
#                 priority: 0,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     required: true,
#                     name: 'subject',
#                     label: 'Subject'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 1,
#                 entity: {
#                     field_type: 'select',
#                     show: true,
#                     edit: true,
#                     name: 'advertise',
#                     label: 'What do you wish to advertise?',
#                     choices: ['Product', 'Promotion', 'Event', 'Acquisition', 'News', 'Investment Opportunity', 'New Venture']
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 2,
#                 entity: {
#                     field_type: 'radio',
#                     show: true,
#                     edit: true,
#                     name: 'public_closed',
#                     label: 'Public or Closed?',
#                     choices: ['Public', 'Closed']
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 3,
#                 entity: {
#                     field_type: 'textarea',
#                     show: true,
#                     edit: true,
#                     name: 'promo_description',
#                     label: 'Description'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 4,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'contact_info',
#                     label: 'How should people contact for more info?'
#                 }
#             }
#         ]
#     },
#     {
#         title: 'Client Project Detail',
#         service: 'EDOC-TSBE',
#         elements: [
#             {
#                 type: 'field',
#                 priority: 0,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'subject',
#                     label: 'Subject',
#                     required: true
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 1,
#                 entity: {
#                     field_type: 'radio',
#                     show: true,
#                     edit: true,
#                     name: 'market_alignment',
#                     label: 'Market Alignment',
#                     default: 'Project',
#                     choices: ['Project', 'Business As Usual']
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 2,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'project_name',
#                     label: 'Project/Business Name'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 3,
#                 entity: {
#                     field_type: 'select',
#                     show: true,
#                     edit: true,
#                     name: 'industry_sector',
#                     label: 'Industry Sector',
#                     choices: ['Resources',
#                               'Construction',
#                               'Information Technology',
#                               'Telecommunications',
#                               'Aerospace',
#                               'Agriculture',
#                               'Chemical',
#                               'Manufacturing',
#                               'Food',
#                               'Pharmaceutical',
#                               'Defence',
#                               'Education',
#                               'Energy',
#                               'Entertainment',
#                               'Hospitality',
#                               'Financial',
#                               'Health Care',
#                               'Media',
#                               'Transport',
#                               'Water'].sort!
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 4,
#                 entity: {
#                     field_type: 'select',
#                     show: true,
#                     edit: true,
#                     name: 'project_status',
#                     label: 'Current Project Status',
#                     choices: ['Pre-feasibility', 'Feasibility', 'EIS Approved', 'Proposed to Board', 'Committed and Funded', 'Details Design', 'Pre-construction', 'Under Construction', 'Ops & Maintenance', 'Decommissioned']
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 5,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'jobs_created',
#                     label: 'Jobs Created'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 6,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'website',
#                     label: 'Website Address'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 7,
#                 entity: {
#                     field_type: 'radio',
#                     show: true,
#                     edit: true,
#                     name: 'public_closed',
#                     label: 'Will you distribute project opportunities publicly or to a closed list',
#                     default: 'Public',
#                     choices: ['Public', 'Closed']
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 8,
#                 entity: {
#                     field_type: 'checkbox',
#                     show: true,
#                     edit: true,
#                     name: 'send_info',
#                     label: 'How will you send out information?',
#                     choices: ['TSBE', 'EconomX', 'Chambers of Commerce', 'ICN Gateway', 'Other']
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 9,
#                 entity: {
#                     field_type: 'date',
#                     show: true,
#                     edit: true,
#                     name: 'market_release',
#                     label: 'When are you likely to release information to the market?'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 10,
#                 entity: {
#                     field_type: 'radio',
#                     show: true,
#                     edit: true,
#                     name: 'po_subcontractor',
#                     label: 'Will you procure through PO, subcontract or both?',
#                     default: 'PO',
#                     choices: ['PO', 'Subcontractor', 'Both']
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 11,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'items_purchase',
#                     label: 'What are the items you mostly purchase?'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 12,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'labour_kind',
#                     label: 'What kind of labour do you normally engage?'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 13,
#                 entity: {
#                     field_type: 'switch',
#                     show: true,
#                     edit: true,
#                     name: 'local_cap',
#                     label: 'Are you already researching local capability?'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 14,
#                 entity: {
#                     field_type: 'switch',
#                     show: true,
#                     edit: true,
#                     name: 'local_content',
#                     label: 'Do you have a weighting for Local Content?'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 15,
#                 entity: {
#                     field_type: 'switch',
#                     show: true,
#                     edit: true,
#                     name: 'prequal_std',
#                     label: 'Will there be a formal prequalification standard?'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 16,
#                 entity: {
#                     field_type: 'switch',
#                     show: true,
#                     edit: true,
#                     name: 'sup_ecx_reg',
#                     label: 'Do you want suppliers to register on EconomX?'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 17,
#                 entity: {
#                     field_type: 'select',
#                     show: true,
#                     edit: true,
#                     name: 'sup_profile',
#                     label: 'What do you look for in a supplier profile?',
#                     single: false, choices: ['Up to date Information', 'Branding', 'Evidence of Management Systems', 'Product Compliancy', 'Product Range', 'Testimonials']
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 18,
#                 entity: {
#                     field_type: 'checkbox',
#                     show: true,
#                     edit: true,
#                     name: 'failure_fb',
#                     label: 'How will you provide feedback to those who are unsuccessful?',
#                     choices: ['Email', 'Phone Call', 'Letter']
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 19,
#                 entity: {
#                     field_type: 'switch',
#                     show: true,
#                     edit: true,
#                     name: 'eoi_templates',
#                     label: 'Do you want to access some EOI templates?'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 20,
#                 entity: {
#                     field_type: 'switch',
#                     show: true,
#                     edit: true,
#                     name: 'content_plan',
#                     label: 'Do you have a tailored Local Content Plan?'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 21,
#                 entity: {
#                     field_type: 'switch',
#                     show: true,
#                     edit: true,
#                     name: 'use_analytics',
#                     label: 'Do you use analytics to improve your business?'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 22,
#                 entity: {
#                     field_type: 'group',
#                     show: true,
#                     edit: true,
#                     name: 'procurement_plan',
#                     label: 'What is the procurement plan?'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 23,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'scope',
#                     label: 'Scope'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 24,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'pkg_size',
#                     label: 'Size of Package'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 25,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'time_to_mkt',
#                     label: 'Time to Market'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 26,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'unbundle',
#                     label: 'Unbundle'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 27,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'prequalified',
#                     label: 'Prequalified'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 28,
#                 entity: {
#                     field_type: 'select',
#                     show: true,
#                     edit: true,
#                     name: 'buying_criteria',
#                     label: 'What is your top 3 buying criteria?',
#                     single: false, choices: ['Cost', 'Reliability', 'Availability', 'Flexibility', 'Performance', 'Responsive', 'Product', 'Service', 'Easy to Administer']
#                 }
#             }
#         ]
#     },
#     {
#         title: 'Pass On Intel',
#         description: '',
#         service: 'EDOC-TSBE',
#         elements: [
#             {
#                 type: 'field',
#                 priority: 0,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'subject',
#                     label: 'Subject'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 1,
#                 entity: {
#                     field_type: 'textarea',
#                     show: true,
#                     edit: true,
#                     name: 'tsbe_opinion',
#                     label: 'TSBE Opinion'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 2,
#                 entity: {
#                     field_type: 'input',
#                     show: true,
#                     edit: true,
#                     name: 'url',
#                     label: 'URL'
#                 }
#             },
#             {
#                 type: 'field',
#                 priority: 3,
#                 entity: {
#                     field_type: 'file',
#                     show: true,
#                     edit: true,
#                     name: 'attachment',
#                     single: true
#                 }
#             }
#         ]
#     }
# ]


# result = Groups::GetGroup.call(group_id: SystemConfig.get('tsbe/group_id'))
# if result.success?
#   puts "EDO details were retrieved Successfully", result.edo
#   edo_data = result.group
#   forms_result = Forms::GetFormsByEdo.call(service_name: edo_data[:name], access_type: 'owner')
#   if forms_result.success?
#     edo_forms = forms_result.forms
#     puts edo_forms, edo_forms.length
#     if edo_forms.length.zero?
#       forms.each do |form|
#         check_form(nil, form, ApplicationController::SERVICE_NAME + edo_data[:name], "Communication Form")
#       end
#     else
#       edo_forms.each do |form|
#         comm = forms.select {|comm_form| comm_form if form['title'].eql?(comm_form[:title])}
#         comm = comm.length.positive? ? comm.first : nil
#         form_result = Forms::GetForm.call(id: form['id'],
#                                           service_name: ApplicationController::SERVICE_NAME + edo_data[:name],
#                                           access_type: 'owner')

#         check_form(form_result, comm, ApplicationController::SERVICE_NAME + edo_data[:name], "Communication Form") unless comm.nil?
#       end
#     end
#   end
# else
#   puts "Unable to retrieve edo details"
# end

# #3. Create Notification Form

# comm = {
#     title: 'Notification',
#     service: ApplicationController::SERVICE_NAME[0, 4],
#     elements: [
#         {
#             type: 'field',
#             priority: 0,
#             entity: {
#                 field_type: 'input',
#                 show: true,
#                 edit: true,
#                 name: 'title',
#                 label: 'Notification Title',
#                 required: true,
#                 placeholder: 'Enter a title'
#             }
#         },
#         {
#             type: 'field',
#             priority: 1,
#             entity: {
#                 field_type: 'textarea',
#                 show: true,
#                 edit: false,
#                 name: 'notification_text',
#                 label: 'Notification Text',
#                 required: true,
#                 placeholder: 'Type your message here...'
#             }
#         }
#     ]
# }
# notification_result = Forms::GetForm.call(id: SystemConfig.get('form/notification_form'),
#                                           service_name: ApplicationController::SERVICE_NAME[0, 4],
#                                           access_type: 'owner')
# check_form(notification_result, comm, ApplicationController::SERVICE_NAME[0, 4], "Notification")

# #4. Create Restrictions

# restriction_type = "email"
# edo_id = SystemConfig.get("tsbe/group_id")
# restrictions = ["tsbe.com.au"]
# group = Group.find_by(group_id: edo_id)
# restriction = Restriction.find_or_create_by!(restriction_type: restriction_type, group_id: group.id)
# restriction.assign_attributes(restrictions: restrictions)
# restriction.save!


