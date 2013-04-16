FactoryGirl.define do

  factory :admin_policy do
    title "Test APO"
    permissions [{type: 'group', name: 'public', access: 'read'}]
    default_permissions [{type: 'group', name: 'public', access: 'read'}]
  end

  factory :content_model do
    title "Test Object"
    permissions [{type: 'group', name: 'public', access: 'read'}]

    trait :has_apo do
      admin_policy { create(:admin_policy) }
    end

    factory :content_model_has_apo, :traits => [:has_apo]
  end

end
