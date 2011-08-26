# == Schema Information
# Schema version: 20110816190509
#
# Table name: tlog_settings
#
#  id                         :integer(4)      not null, primary key
#  user_id                    :integer(4)      default(0), not null, indexed
#  title                      :string(255)
#  about                      :text
#  updated_at                 :datetime
#  rss_link                   :string(255)
#  tasty_newsletter           :boolean(1)      default(TRUE), not null
#  default_visibility         :string(255)     default("mainpageable"), not null
#  comments_enabled           :boolean(1)      default(FALSE)
#  css_revision               :integer(4)      default(1), not null
#  sidebar_is_open            :boolean(1)      default(TRUE), not null
#  is_daylog                  :boolean(1)      default(FALSE), not null
#  sidebar_hide_tags          :boolean(1)      default(TRUE), not null
#  sidebar_hide_calendar      :boolean(1)      default(FALSE), not null
#  sidebar_hide_search        :boolean(1)      default(FALSE), not null
#  sidebar_hide_messages      :boolean(1)      default(FALSE), not null
#  sidebar_messages_title     :string(255)
#  email_messages             :boolean(1)      default(TRUE), not null
#  past_disabled              :boolean(1)      default(FALSE), not null
#  privacy                    :string(16)      default("open"), not null
#  main_background_file_name  :string(255)
#  main_background_updated_at :datetime
#  main_background_meta       :text
#
# Indexes
#
#  index_tlog_settings_on_user_id  (user_id)
#

class TlogSettings < ActiveRecord::Base
  DEFAULT_PRIVACY_FOR_SELECT = [
      ['все могут видеть', 'open'],
      ['только зарегистрированные пользователи', 'rr'],
      ['только люди, на которых я подписался сам', 'fr'],
      ['вообще никто, только я!', 'me']
    ]
  
  belongs_to :user
  
  validates_presence_of :user_id
  validates_inclusion_of :default_visibility, :in => %(public private mainpageable voteable), :on => :save

  validates_inclusion_of :privacy, :in => %(open rr fr me), :on => :save
  
  has_attached_file :main_background,
    :url            => '/assets/main/:sha1_partition/:id_:style.:extension',
    :path           => ':rails_root/public:url',
    :use_timestamp  => false,
    :styles         => { :square => '40x40#' }

  
  def default_visibility
    read_attribute(:default_visibility) || 'mainpageable'
  end
  
  # обновляем счетчик последнего обновления, чтобы сбросить кеш для страниц.
  #  это актуально когда пользователь переключается между режимами "обычный" / "тлогодень"
  #  и когда он включает / выключает опцию "скрыть прошлое"
  after_save do |record|
    record.user.update_attributes(:entries_updated_at => Time.now) unless (record.changes.keys - ['updated_at']).blank?
  end
end
