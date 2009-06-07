class EmailerController < ApplicationController
  before_filter :preload_mail


  def index
    render :layout => 'white'
  end
  
  def part
    @part = @mail.parts.select { |part| part.content_type == 'text/html' }.first
    
    render :layout => nil
  end
  
  private
    def preload_mail
      @method_name = params[:method_name]

      user = User.first

      case @method_name
      when 'comment'
        @mail = Emailer.create_comment(current_service, User.first, Comment.find_by_user_id(1))
      when 'comment_reply'
        @mail = Emailer.create_comment_reply(current_service, User.first, Comment.find_by_user_id(2))
      when 'comment_to_subscriber'
        @mail = Emailer.create_comment_to_subscriber(current_service, User.first, Comment.last)
      when 'confirm'
        @mail = Emailer.create_confirm(current_service, User.unconfirmed.last, User.unconfirmed.last.email)
      when 'lost_password'
        @mail = Emailer.create_lost_password(current_service, user)
      when 'message'
        @mail = Emailer.create_message(current_service, user, user.messages.last)
      when 'signup'
        @mail = Emailer.create_signup(current_service, User.unconfirmed.last)
      end
      
      true 
    end
end