
require 'active_record/fixtures'

User.delete_all
ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/../fixtures", "users")

Message.delete_all
ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/../fixtures", "messages")



