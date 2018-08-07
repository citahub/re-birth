FactoryBot.define do
  factory :sync_error do
    add_attribute(:method) { "getTransaction" }
    code -32700
    params ["0x0"]
    message "invalid format: [0x0]"
    data nil
  end
end
