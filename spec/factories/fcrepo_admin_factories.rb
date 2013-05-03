FactoryGirl.define do

  factory :admin_policy do
    title "Test APO"
    permissions [{type: 'group', name: 'public', access: 'read'}]
    default_permissions [{type: 'group', name: 'public', access: 'read'}]
  end

  factory :collection do
    title "Test Collection"
    permissions [{type: 'group', name: 'public', access: 'read'}]
  end

  factory :item do
    sequence(:title) { |n| "Test Item [#{n}]" }
    permissions [{type: 'group', name: 'public', access: 'read'}]
  end

  factory :part do
    sequence(:title) { |n| "Test Part [#{n}]" }
    permissions [{type: 'group', name: 'public', access: 'read'}]
  end

end
