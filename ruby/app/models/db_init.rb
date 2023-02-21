require 'active_record'

DB = ActiveRecord::Base.establish_connection(
  :adapter => 'postgresql',
  :database => ENV['DB_NAME'],
  :host => ENV['DB_HOST'],
  :username => ENV['DB_USER'],
  :password => ENV['DB_PASS'],
)

ActiveRecord::Base.connection.create_table(:articles, primary_key: 'id', force: true) do |t|
    t.string :title
    t.string :content
    t.string :created_at
end

ActiveRecord::Base.connection.create_table(:comments, primary_key: 'id', force: true) do |t|
    t.references :article
    t.text :content
    t.string :author_name
    t.string :created_at
end

require_relative 'article'
require_relative 'comment'

article = Article.create(:title => 'Title ABC', :content => 'Lorem Ipsum', :created_at => Time.now)
article.comments.create(:content => '1st comment', :author_name => 'Author', :created_at => Time.now)
Article.create(:title => 'Title ZFX', :content => 'Some Blog Post', :created_at => Time.now)
Article.create(:title => 'Title YNN', :content => 'O_O_Y_O_O', :created_at => Time.now)

puts "Article count in DB: #{Article.count}"
puts "Comment count in DB: #{Comment.count}"

