namespace :add_forms do

  desc "Add Edo forms"
  task tsbe_forms: :environment do
    time = Benchmark.realtime do

      forms = [
          {
              title: 'Notice',
              service: 'EDOC-TSBE',
              elements: [
                  {
                      type: 'field',
                      priority: 0,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'subject',
                          label: 'Subject',
                          required: true,
                          placeholder: 'Enter a subject'
                      }
                  },
                  {
                      type: 'field',
                      priority: 1,
                      entity: {
                          field_type: 'textarea',
                          show: true,
                          edit: true,
                          name: 'notice_text',
                          label: 'Notice Text',
                          required: true,
                          placeholder: ''
                      }
                  },
                  {
                      type: 'field',
                      priority: 2,
                      entity: {
                          field_type: 'select',
                          show: true,
                          edit: true,
                          name: 'notice_type',
                          label: 'Notice Type',
                          required: true,
                          default: 'General',
                          choices: ['General', 'Feedback']
                      }
                  },
                  {
                      type: 'field',
                      priority: 3,
                      entity: {
                          field_type: 'file',
                          show: true,
                          edit: true,
                          name: 'attachment',
                          label: 'Attachments(s)',
                          required: true
                      }
                  },
              ]
          },
          {
              title: 'EOI Warning',
              service: 'EDOC-TSBE',
              elements: [
                  {
                      type: 'field',
                      priority: 0,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'subject',
                          label: 'Subject',
                          required: true,
                          placeholder: 'Enter a subject'
                      }
                  },
                  {
                      type: 'field',
                      priority: 1,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'pkg_name',
                          label: 'Package Name'
                      }
                  },
                  {
                      type: 'field',
                      priority: 2,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'pkg_desc',
                          label: 'Package Description'
                      }
                  },
                  {
                      type: 'field',
                      priority: 3,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'pkg_release',
                          label: 'Package Release'
                      }
                  },
                  {
                      type: 'field',
                      priority: 4,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'pkg_start_dt',
                          label: 'Package Start Date'
                      }
                  },
                  {
                      type: 'field',
                      priority: 5,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'sup_profile',
                          label: 'What do you look for in a supplier profile?'
                      }
                  }
              ]
          },
          {
              title: 'Member Promotion',
              description: '',
              service: 'EDOC-TSBE',
              elements: [
                  {
                      type: 'field',
                      priority: 0,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          required: true,
                          name: 'subject',
                          label: 'Subject'
                      }
                  },
                  {
                      type: 'field',
                      priority: 1,
                      entity: {
                          field_type: 'select',
                          show: true,
                          edit: true,
                          name: 'advertise',
                          label: 'What do you wish to advertise?',
                          choices: ['Product', 'Promotion', 'Event', 'Acquisition', 'News', 'Investment Opportunity', 'New Venture']
                      }
                  },
                  {
                      type: 'field',
                      priority: 2,
                      entity: {
                          field_type: 'radio',
                          show: true,
                          edit: true,
                          name: 'public_closed',
                          label: 'Public or Closed?',
                          choices: ['Public', 'Closed']
                      }
                  },
                  {
                      type: 'field',
                      priority: 3,
                      entity: {
                          field_type: 'textarea',
                          show: true,
                          edit: true,
                          name: 'promo_description',
                          label: 'Description'
                      }
                  },
                  {
                      type: 'field',
                      priority: 4,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'contact_info',
                          label: 'How should people contact for more info?'
                      }
                  }
              ]
          },
          {
              title: 'Client Project Detail',
              service: 'EDOC-TSBE',
              elements: [
                  {
                      type: 'field',
                      priority: 0,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'subject',
                          label: 'Subject',
                          required: true
                      }
                  },
                  {
                      type: 'field',
                      priority: 1,
                      entity: {
                          field_type: 'radio',
                          show: true,
                          edit: true,
                          name: 'market_alignment',
                          label: 'Market Alignment',
                          default: 'Project',
                          choices: ['Project', 'Business As Usual']
                      }
                  },
                  {
                      type: 'field',
                      priority: 2,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'project_name',
                          label: 'Project/Business Name'
                      }
                  },
                  {
                      type: 'field',
                      priority: 3,
                      entity: {
                          field_type: 'select',
                          show: true,
                          edit: true,
                          name: 'industry_sector',
                          label: 'Industry Sector',
                          choices: ['Resources',
                                    'Construction',
                                    'Information Technology',
                                    'Telecommunications',
                                    'Aerospace',
                                    'Agriculture',
                                    'Chemical',
                                    'Manufacturing',
                                    'Food',
                                    'Pharmaceutical',
                                    'Defence',
                                    'Education',
                                    'Energy',
                                    'Entertainment',
                                    'Hospitality',
                                    'Financial',
                                    'Health Care',
                                    'Media',
                                    'Transport',
                                    'Water'].sort!
                      }
                  },
                  {
                      type: 'field',
                      priority: 4,
                      entity: {
                          field_type: 'select',
                          show: true,
                          edit: true,
                          name: 'project_status',
                          label: 'Current Project Status',
                          choices: ['Pre-feasibility', 'Feasibility', 'EIS Approved', 'Proposed to Board', 'Committed and Funded', 'Details Design', 'Pre-construction', 'Under Construction', 'Ops & Maintenance', 'Decommissioned']
                      }
                  },
                  {
                      type: 'field',
                      priority: 5,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'jobs_created',
                          label: 'Jobs Created'
                      }
                  },
                  {
                      type: 'field',
                      priority: 6,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'website',
                          label: 'Website Address'
                      }
                  },
                  {
                      type: 'field',
                      priority: 7,
                      entity: {
                          field_type: 'radio',
                          show: true,
                          edit: true,
                          name: 'public_closed',
                          label: 'Will you distribute project opportunities publicly or to a closed list',
                          default: 'Public',
                          choices: ['Public', 'Closed']
                      }
                  },
                  {
                      type: 'field',
                      priority: 8,
                      entity: {
                          field_type: 'checkbox',
                          show: true,
                          edit: true,
                          name: 'send_info',
                          label: 'How will you send out information?',
                          multi: true,
                          choices: ['TSBE', 'EconomX', 'Chambers of Commerce', 'ICN Gateway', 'Other']
                      }
                  },
                  {
                      type: 'field',
                      priority: 9,
                      entity: {
                          field_type: 'date',
                          show: true,
                          edit: true,
                          name: 'market_release',
                          label: 'When are you likely to release information to the market?',
                          day: false, month: true, year: true
                      }
                  },
                  {
                      type: 'field',
                      priority: 10,
                      entity: {
                          field_type: 'radio',
                          show: true,
                          edit: true,
                          name: 'po_subcontractor',
                          label: 'Will you procure through PO, subcontract or both?',
                          default: 'PO',
                          choices: ['PO', 'Subcontractor', 'Both']
                      }
                  },
                  {
                      type: 'field',
                      priority: 11,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'items_purchase',
                          label: 'What are the items you mostly purchase?'
                      }
                  },
                  {
                      type: 'field',
                      priority: 12,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'labour_kind',
                          label: 'What kind of labour do you normally engage?'
                      }
                  },
                  {
                      type: 'field',
                      priority: 13,
                      entity: {
                          field_type: 'switch',
                          show: true,
                          edit: true,
                          name: 'local_cap',
                          label: 'Are you already researching local capability?'
                      }
                  },
                  {
                      type: 'field',
                      priority: 14,
                      entity: {
                          field_type: 'switch',
                          show: true,
                          edit: true,
                          name: 'local_content',
                          label: 'Do you have a weighting for Local Content?'
                      }
                  },
                  {
                      type: 'field',
                      priority: 15,
                      entity: {
                          field_type: 'switch',
                          show: true,
                          edit: true,
                          name: 'prequal_std',
                          label: 'Will there be a formal prequalification standard?'
                      }
                  },
                  {
                      type: 'field',
                      priority: 16,
                      entity: {
                          field_type: 'switch',
                          show: true,
                          edit: true,
                          name: 'sup_ecx_reg',
                          label: 'Do you want suppliers to register on EconomX?'
                      }
                  },
                  {
                      type: 'field',
                      priority: 17,
                      entity: {
                          field_type: 'select',
                          show: true,
                          edit: true,
                          name: 'sup_profile',
                          label: 'What do you look for in a supplier profile?',
                          single: false, choices: ['Up to date Information', 'Branding', 'Evidence of Management Systems', 'Product Compliancy', 'Product Range', 'Testimonials']
                      }
                  },
                  {
                      type: 'field',
                      priority: 18,
                      entity: {
                          field_type: 'checkbox',
                          show: true,
                          edit: true,
                          name: 'failure_fb',
                          label: 'How will you provide feedback to those who are unsuccessful?',
                          choices: ['Email', 'Phone Call', 'Letter']
                      }
                  },
                  {
                      type: 'field',
                      priority: 19,
                      entity: {
                          field_type: 'switch',
                          show: true,
                          edit: true,
                          name: 'eoi_templates',
                          label: 'Do you want to access some EOI templates?'
                      }
                  },
                  {
                      type: 'field',
                      priority: 20,
                      entity: {
                          field_type: 'switch',
                          show: true,
                          edit: true,
                          name: 'content_plan',
                          label: 'Do you have a tailored Local Content Plan?'
                      }
                  },
                  {
                      type: 'field',
                      priority: 21,
                      entity: {
                          field_type: 'switch',
                          show: true,
                          edit: true,
                          name: 'use_analytics',
                          label: 'Do you use analytics to improve your business?'
                      }
                  },
                  {
                      type: 'field',
                      priority: 22,
                      entity: {
                          field_type: 'group',
                          show: true,
                          edit: true,
                          name: 'procurement_plan',
                          label: 'What is the procurement plan?'
                      }
                  },
                  {
                      type: 'field',
                      priority: 23,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'scope',
                          label: 'Scope'
                      }
                  },
                  {
                      type: 'field',
                      priority: 24,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'pkg_size',
                          label: 'Size of Package'
                      }
                  },
                  {
                      type: 'field',
                      priority: 25,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'time_to_mkt',
                          label: 'Time to Market'
                      }
                  },
                  {
                      type: 'field',
                      priority: 26,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'unbundle',
                          label: 'Unbundle'
                      }
                  },
                  {
                      type: 'field',
                      priority: 27,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'prequalified',
                          label: 'Prequalified'
                      }
                  },
                  {
                      type: 'field',
                      priority: 28,
                      entity: {
                          field_type: 'select',
                          show: true,
                          edit: true,
                          name: 'buying_criteria',
                          label: 'What is your top 3 buying criteria?',
                          single: false, choices: ['Cost', 'Reliability', 'Availability', 'Flexibility', 'Performance', 'Responsive', 'Product', 'Service', 'Easy to Administer']
                      }
                  }
              ]
          },
          {
              title: 'Pass On Intel',
              description: '',
              service: 'EDOC-TSBE',
              elements: [
                  {
                      type: 'field',
                      priority: 0,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'subject',
                          label: 'Subject'
                      }
                  },
                  {
                      type: 'field',
                      priority: 1,
                      entity: {
                          field_type: 'textarea',
                          show: true,
                          edit: true,
                          name: 'tsbe_opinion',
                          label: 'TSBE Opinion'
                      }
                  },
                  {
                      type: 'field',
                      priority: 2,
                      entity: {
                          field_type: 'input',
                          show: true,
                          edit: true,
                          name: 'url',
                          label: 'URL'
                      }
                  },
                  {
                      type: 'field',
                      priority: 3,
                      entity: {
                          field_type: 'file',
                          show: true,
                          edit: true,
                          name: 'attachment',
                          single: true
                      }
                  }
              ]
          }
      ]
      result = Groups::GetGroup.call(group_id: SystemConfig.get('tsbe/group_id'))
      if result.success?
        puts "EDO details were retrieved Successfully",result.edo
        edo_data = result.group
        forms.each do |form|
          result = Forms::CreateForm.call(form_details: form, service: edo_data[:name])

          if result.success?

            puts "Finished creating form #{form[:title]} with id #{result.form['id']}"
          end
        end
      else
        puts "Unable to retrieve edo details"
      end

    end

    puts "Finished creating message_form form in #{(time / 60).floor} minutes and #{(time % 60).round(2)} seconds"
  end

end
