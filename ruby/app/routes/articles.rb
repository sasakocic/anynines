require_relative '../controllers/articles'

class ArticleRoutes < Sinatra::Base
  use AuthMiddleware

  def initialize
    super
    @articleCtrl = ArticleController.new
  end

  before do
    content_type :json
  end

  get('/') do
    summary = @articleCtrl.get_batch

    if summary[:ok]
      { articles: summary[:data] }
    else
      { msg: 'Could not get articles.' }
    end.to_json
  end

  get('/:id') do
    summary = @articleCtrl.get_article(params['id'])
    if summary[:ok]
      { article: summary[:data] }
    else
      { msg: "Could not find article with id: #{params['id']}." }
    end.to_json
  end

  post('/') do
    payload = JSON.parse(request.body.read)
    summary = @articleCtrl.create_article(payload)

    if summary[:ok]
      { msg: 'Article created' }
    else
      { msg: summary[:msg] }
    end.to_json
  end

  put('/:id') do
    payload = JSON.parse(request.body.read)
    summary = @articleCtrl.update_article params['id'], payload

    if summary[:ok]
      { msg: 'Article updated' }
    else
      { msg: summary[:msg] }
    end.to_json
  end

  delete('/:id') do
    summary = @articleCtrl.delete_article params['id']

    if summary[:ok]
      { msg: 'Article deleted' }
    else
      { msg: 'Article does not exist' }
    end.to_json
  end
end
