require_relative '../controllers/articles'
require_relative '../controllers/comments'

class ArticleRoutes < Sinatra::Base
  use AuthMiddleware

  def initialize
    super
    @article_controller = ArticleController.new
    @comment_controller = CommentController.new
  end

  before do
    content_type :json
  end

  get('/') do
    summary = @article_controller.get_batch

    if summary[:ok]
      { articles: summary[:data] }
    else
      { msg: 'Could not get articles.' }
    end.to_json
  end

  get('/:id/comments') do
    summary = @comment_controller.get_article_comments(params['id'])
    if summary[:ok]
      { comments: summary[:data] }
    else
      { msg: "Could not find comments for article with id: #{params['id']}." }
    end.to_json
  end

  get('/:id') do
    summary = @article_controller.get_article(params['id'])
    if summary[:ok]
      { article: summary[:data] }
    else
      { msg: "Could not find article with id: #{params['id']}." }
    end.to_json
  end

  post('/:id/comments') do
    payload = JSON.parse(request.body.read)
    summary = @comment_controller.create_article_comment(params['id'], payload)

    if summary[:ok]
      { msg: 'Comment created' }
    else
      { msg: summary[:msg] }
    end.to_json
  end

  post('/') do
    payload = JSON.parse(request.body.read)
    summary = @article_controller.create_article(payload)

    if summary[:ok]
      { msg: 'Article created' }
    else
      { msg: summary[:msg] }
    end.to_json
  end

  put('/:id') do
    payload = JSON.parse(request.body.read)
    summary = @article_controller.update_article params['id'], payload

    if summary[:ok]
      { msg: 'Article updated' }
    else
      { msg: summary[:msg] }
    end.to_json
  end


  delete('/:id') do
    summary = @article_controller.delete_article params['id']

    if summary[:ok]
      { msg: 'Article deleted' }
    else
      { msg: 'Article does not exist' }
    end.to_json
  end
end
