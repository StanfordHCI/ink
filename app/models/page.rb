class Page < ActiveRecord::Base
  belongs_to :user
  has_many :text_panels
  has_many :pictures
  has_many :s_selectpanels
  has_many :m_selectpanels
  accepts_nested_attributes_for :text_panels, allow_destroy: true
  accepts_nested_attributes_for :pictures, allow_destroy: true
  accepts_nested_attributes_for :s_selectpanels, allow_destroy: true
  accepts_nested_attributes_for :m_selectpanels, allow_destroy: true

  validates :site_name, presence: true
  validate :require_panel_names

  private
    def require_panel_names
      for panel in text_panels
        errors.add(:base, "No text panel name.") if panel.panel_name.blank?
      end
      for panel in pictures
        errors.add(:base, "No picture panel name.") if panel.panel_name.blank?
      end
      for panel in s_selectpanels
        errors.add(:base, "No single select panel name.") if panel.panel_name.blank?
      end
      for panel in m_selectpanels
        errors.add(:base, "No multi select panel name.") if panel.panel_name.blank?
      end
    end
end

