class Company < ActiveRecord::Base
   attr_accessible :name, :admin_id

   validates_presence_of :name, :admin_id
   validates_uniqueness_of :name

   belongs_to :admin,
   class_name: "Users",
   primary_key: :id,
   foreign_key: :admin_id

   has_many :managers,
   class_name: "User",
   primary_key: :id,
   foreign_key: :manager_id

end
