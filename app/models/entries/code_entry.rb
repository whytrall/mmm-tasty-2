# = Schema Information
#
# Table name: *entries*
#
#  id               :integer(4)      not null, primary key
#  user_id          :integer(4)      default(0), not null
#  data_part_1      :text
#  data_part_2      :text
#  data_part_3      :text
#  type             :string(255)     default(""), not null
#  is_disabled      :boolean(1)      not null
#  created_at       :datetime        not null
#  metadata         :text
#  comments_count   :integer(4)      default(0), not null
#  updated_at       :datetime
#  is_voteable      :boolean(1)
#  is_private       :boolean(1)      not null
#  cached_tag_list  :text
#  is_mainpageable  :boolean(1)      default(TRUE), not null
#  comments_enabled :boolean(1)      not null
########
class CodeEntry < Entry
  validates_presence_of :data_part_1, :message => 'это обязательное поле'
  validates_length_of :data_part_1, :within => 1..ENTRY_MAX_LENGTH, :on  => :save, :too_long => 'ммм... слишком много кода'
  validates_length_of :data_part_2, :within => 0..ENTRY_MAX_LENGTH, :on => :save, :if => Proc.new { |e| !e.data_part_2.blank? }, :too_long => 'это поле слишком длинное'
  def entry_russian_dict; { :who => 'код', :whom => 'код' } end
  
  def excerpt
    self.data_part_1.to_s.truncate(150).to_s
  end
end