class ApplicationController < ActionController::Base
  filter_parameter_logging :password
  
  # before_filter :prelaunch_megasecrecy

  include ExceptionNotifiable if RAILS_ENV == 'production'
  include ProductionImages if RAILS_ENV == 'development'
  
  helper :white_list, :url, :asset_gluer

  # MAIN FILTERS
  attr_accessor   :current_site
  helper_method   :current_site

  attr_accessor   :current_user
  helper_method   :current_user
  
  attr_accessor   :current_service
  helper_method   :current_service
  
  helper_method   :is_admin?

  before_filter :preload_current_service
  before_filter :remove_old_cookies
  before_filter :preload_current_site # loads @current_site
  before_filter :preload_current_user # loads @current_user
  
  protected
    def remove_old_cookies
      if cookies[:tsig]
        cookies.delete :tsig
        cookies.delete :tsig, :domain => current_service.cookie_domain
      end
      
      if cookies[:login_field_value]
        cookies.delete :login_field_value
        cookies.delete :login_field_value, :domain => current_service.cookie_domain
      end
      
      if cookies[:tlogs]
        cookies.delete :tlogs
        cookies.delete :tlogs, :domain => current_service.cookie_domain
      end
      
      if cookies['tlogs-100']
        cookies.delete 'tlogs-100'
        cookies.delete 'tlogs-100', :domain => current_service.cookie_domain
      end
      
      if cookies['tlogs-112']
        cookies.delete 'tlogs-112'
        cookies.delete 'tlogs-112', :domain => current_service.cookie_domain
      end
      
      if cookies['session']
        cookies.delete :session
        cookies.delete :session, :domain => current_service.cookie_domain
      end
    end
  
    def preload_current_service
      @current_service = Tlogs::Domains::CONFIGURATION.options_for(request.host || 'localhost', request)
    end
  
    def preload_current_site
      @current_site = nil

      url = nil
      if request.host.ends_with?('mmm-tasty.ru')
        url = request.subdomains.first
        
        # перенаправляем на сайт сервиса, если адрес запрещенный
        redirect_to "#{request.protocol}www.mmm-tasty.ru#{request.port == 80 ? '' : ":#{request.port}"}" and return false if User::RESERVED.include?(url) && url != 'www'
      elsif request.host == 'localhost'
        url = params[:current_site] if request.path.starts_with?('/users/')
        
        # перенаправляем на сайт сервиса, если адрес запрещенный
        redirect_to "#{request.protocol}#{request.host_with_port}" and return false if User::RESERVED.include?(url)
      end
      
      
      @current_site = User.find_by_url(url, :include => [:tlog_settings, :avatar]) unless url.blank?
      
      true
    end
  
    def preload_current_user
      return true if @current_user

      # from session
      @current_user = User.active.find_by_id(session[:u]) if session[:u]

      unless cookies[:t].blank?
        id, sig = cookies[:t].unpack('m').first.unpack('LZ*')
        user = User.active.find_by_id(id)
        if user && user.signature == sig
          session[:u] = user.id
          @current_user = user
        end
      end

      true
    end
    

    # Является ли текущий пользователь владельцем сайта
    def is_owner?
      return true if current_user && current_site && current_user.id == current_site.id
      false
    end
    helper_method :is_owner?

    # Фильтр который требует чтобы пользователь был авторизован прежде чем
    #  мог получить доступ к указанной странице
    def require_current_user
      if current_user && current_user.is_a?(User)        
        redirect_to service_url(login_path) and return false if current_user.is_disabled?
        return true
      end
      
      flash[:notice] = 'Вам необходимо зайти чтобы выполнить запрос'
      if request.get?
        session[:r] = "#{request.protocol}#{request.host_with_port}#{request.request_uri}"
      end
      redirect_to service_url(login_path)
      false
    end
    
    def require_current_site
      return true if current_site && current_site.is_a?(User)
      render :template => 'global/tlog_not_found', :layout => false, :status => 404
      false
    end
    
    def is_admin?
      current_user && current_user.is_admin?
    end
    
    def require_admin
      return true if require_current_user && current_user.is_admin?
      
      render :text => 'pemission denied', :status => 403
      return false
    end

    def require_confirmed_current_user
      redirect_to service_url(confirm_path(:action => :required)) and return false if (is_owner? && !current_site.is_confirmed?) || (!current_site && current_user && !current_user.is_confirmed?)
      
      redirect_to service_url(login_path) and return false if current_user && current_user.is_disabled?
      
      true    
    end
    
    def require_confirmed_current_site
      if !current_site.is_confirmed?          
        render_tasty_404("Этот имя занято, но пользователь еще не подтвердил свою регистрацию.<br/>Загляните, пожалуйста, позже.<br/><br/><a href='#{service_url}' rel='follow'>&#x2190; вернуться на главную</a>")
        return false
      end
      
      if current_site.is_disabled?
        render_tasty_404("Этот аккаунт заблокирован или удален")
        return false
      end
      
      true
    end

    def current_user_eq_current_site
      return true if current_user && current_site && current_user.id == current_site.id
      
      render(:text => 'permission denied', :status => 403) and return false
    end

    def render_tasty_404(text, options = {})
      options[:layout] ||= '404'
      options[:status] ||= 404
      options[:text] = text
      render options
    end    
    
    include UrlHelper
end