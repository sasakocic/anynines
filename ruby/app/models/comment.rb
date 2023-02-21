class Comment < ActiveRecord::Base
  self.table_name = 'comments'
  belongs_to :article
end