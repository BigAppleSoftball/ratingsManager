class Profile < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  #TODO This will break when editing a user profile as an admin
  has_secure_password
  #validates :password, length: { minimum: 6 }, on: :create

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :email, presence: true,
                    format:{ with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  belongs_to :team
  has_one :hallof_famer
  has_many :rosters
  has_one :rating
  has_one :board_member
  has_one :committee
  #has_one :team

  # TODO(paige) implement
  def staff?
    true
  end

  # String to represent a user (e-mail, name, etc.)
  def to_s
    "#{first_name} #{last_name}"
  end

  def self.search(search)
    if search
      where('last_name LIKE ? OR first_name LIKE ?', "%#{search}%", "%#{search}%")
    else
      all
    end
  end

  def Profile.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def Profile.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  #
  # Display name of the user
  def name
    "#{self.first_name} #{self.last_name}"
  end

  # returns an array of teams managed by the 
  # current profile
  def teams_managed
    Roster.select('team_id').where(:profile_id => self.id, :is_manager => true)
  end

  def teams_managed_list
    teams_managed.map{|i| i.team_id}
  end

  # returns an array of teams repped by the 
  # current profile
  def teams_repped
    Roster.select('team_id').where(:profile_id => self.id, :is_rep => true)
  end

  def divisions_repped
    BoardMember.where(:profile_id => self.id, :is_division_rep => true)
  end

   def divisions_repped_list
    divisions_repped.map{|i| i.division_id}
  end

  #
  # This is for actual board member adminstrators and not site adminstrators
  # Returns an array of positions
  #
  def league_admin_positions
    BoardMember.select('id, position').where(:profile_id => self.id, :is_league_admin => true)
  end
  
  private

    def create_remember_token
      self.remember_token = Profile.encrypt(Profile.new_remember_token)
    end
end
