class CommentController
  def create_comment(comment)
    new_comment = Comment.new(:author_name => comment['author_name'], :content => comment['content'], :created_at => Time.now, :article_id => comment['article_id'])
    new_comment.save

    { ok: true, obj: comment }
  rescue StandardError
    { ok: false }
  end

  def create_article_comment(id, comment)
    article = Article.where(id: id).first

    return { ok: false, msg: 'Article could not be found' } if article.nil?

    new_comment = article.comments.new(:author_name => comment['author_name'], :content => comment['content'], :created_at => Time.now)
    new_comment.save

    { ok: true, obj: new_comment }
  rescue StandardError
    { ok: false }
  end
  def update_comment(id, new_data)

    comment = Comment.where(id: id).first

    return { ok: false, msg: 'Comment could not be found' } if comment.nil?

    comment.author_name = new_data['author_name']
    comment.article_id = new_data['article_id']
    comment.content = new_data['content']
    comment.save

    { ok: true, obj: comment }
  rescue StandardError
    { ok: false }
  end

  def get_comment(id)
    res = Comment.where(:id => id)

    if res.empty?
      { ok: false, msg: 'Comment not found' }
    else
      { ok: true, data: res.first }
    end
  rescue StandardError
    { ok: false }
  end

  def get_article_comments(id)
    res = Comment.where(:article_id => id)

    { ok: true, data: res.all }
  rescue StandardError
    { ok: false }
  end

  def delete_comment(id)
    delete_count = Comment.delete(id)

    if delete_count == 0
      { ok: false }
    else
      { ok: true, delete_count: delete_count }
    end
  end

  def delete_article_comments(id)
    delete_count = Article.where(id: id).comments.delete_all

    if delete_count == 0
      { ok: false }
    else
      { ok: true, delete_count: delete_count }
    end
  end

  def get_batch
    { ok: true, data: Comment.all }
  end
end
