require_relative '../controllers/comments'

class CommentRoutes < Sinatra::Base
  use AuthMiddleware

  def initialize
    super
    @controller = CommentController.new
  end

  before do
    content_type :json
  end

  get('/') do
    summary = @controller.get_batch

    if summary[:ok]
      { comments: summary[:data] }
    else
      { msg: 'Could not get comments.' }
    end.to_json
  end

  get('/:id') do
    summary = @controller.get_comment(params['id'])
    if summary[:ok]
      { comment: summary[:data] }
    else
      { msg: "Could not find comment with id: #{params['id']}." }
    end.to_json
  end

  post('/') do
    payload = JSON.parse(request.body.read)
    summary = @controller.create_comment(payload)

    if summary[:ok]
      { msg: 'Comment created' }
    else
      { msg: summary[:msg] }
    end.to_json
  end

  put('/:id') do
    payload = JSON.parse(request.body.read)
    summary = @controller.update_comment params['id'], payload

    if summary[:ok]
      { msg: 'Comment updated' }
    else
      { msg: summary[:msg] }
    end.to_json
  end

  delete('/:id') do
    summary = @controller.delete_comment params['id']

    if summary[:ok]
      { msg: 'Comment deleted' }
    else
      { msg: 'Comment does not exist' }
    end.to_json
  end
end
