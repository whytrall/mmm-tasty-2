class Emailer < ActionMailer::Base
  helper :application, :comments, :url

  def signup(user)
    setup 

    @subject    = 'ммм... регистрация'
    @body       = {:user => user}
    @recipients = user.email
    @from       = '"Ммм... тейсти" <noreply@mmm-tasty.ru>'
  end

  def confirm(user, email)
    setup     :subj => 'ммм... подтверждение емейл адреса',
              :from => '"Mmm... noreply" <noreply@mmm-tasty.ru>',
              :email => email,
              :body => { :user => user, :email => email }
  end
  
  def message(user, message)
    setup     :subj => 'ммм.... новое личное сообщение',
              :from => '"Mmm... message" <messages@mmm-tasty.ru>',
              :user => user,
              :body => { :message => message }
  end
  
  def comment(user, comment)
    setup     :subj => "ммм... комментарий (#{comment.entry.excerpt})",
              :from => '"Mmm... comments" <comments@mmm-tasty.ru>',
              :user => user,
              :body => { :comment => comment }
  end  

  def comment_reply(user, comment)
    setup     :subj => "ммм... ответ на Ваш комментарий (#{comment.entry.excerpt})",
              :from => '"Mmm... comments" <comments@mmm-tasty.ru>',
              :user => user,
              :body => { :comment => comment }
  end  
  
  # письмо для пользователей подписанных на комментарии
  def comment_to_subscriber(user, comment)
    setup       

    @subject    = "ммм... комментарий (#{comment.entry.excerpt})"
    @body       = {:user => user, :comment => comment}
    @recipients = user.email
    @from       = '"Mmm... comments" <comments@mmm-tasty.ru>'
  end

  # письмо-напоминание о забытом пароле
  def lost_password(user)
    setup     :subj => 'ммм... напоминание пароля',
              :from => '"Mmm... password" <noreply@mmm-tasty.ru>',
              :user => user,
              :body => { :recover_link => service_url(recover_password_path(:user_id => user.id, :secret => user.recover_secret)) }
  end
  
  private
    def setup(options = {})
      # message specific things
      @body       = (options[:body] || {})
      @body[:user] = options[:user] if @body[:user].blank? && options[:user]
  
      # global settings
      @sent_on    = Time.now
      @headers    = {}
      @subject    = options[:subj]
      @recipients = options[:email].blank? ? options[:user].email : options[:email]
      @from       = options[:from]

      setup_service
    end

    def setup_service
      @body[:current_service] = Tlogs::Domains::CONFIGURATION.default
    end
end