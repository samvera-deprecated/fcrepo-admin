FactoryGirl.define do

  factory :admin_policy do
    title "Test APO"
    permissions [{type: 'group', name: 'public', access: 'read'}]
    default_permissions [{type: 'group', name: 'public', access: 'read'}]
  end

  factory :fcrepo_object do
    title "Test Object"

    trait :apo do
      admin_policy
    end

    factory :fcrepo_object_apo, :traits => [:apo]
  end

end
