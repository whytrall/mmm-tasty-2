class CommentDeliverJob
  @queue = :high
  
  def self.perform(comment_id, service_domain, reply_to)
    comment = Comment.find_by_id(comment_id)
    
    if comment && comment.entry && !comment.entry.is_disabled? && comment.user && !comment.user.is_disabled?
      current_service = Tlogs::Domains::CONFIGURATION.options_for(service_domain, nil)
      comment.deliver!(current_service, reply_to)
    end
  end
end