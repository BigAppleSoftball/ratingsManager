class Profile < ActiveRecord::Base
  attr_accessor :reset_token
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  #TODO This will break when editing a user profile as an admin
  has_secure_password
  validates :password, length: { minimum: 6 },
                        on: :create

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :email, presence: true,
                    format:{ with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  belongs_to :team
  has_one :hallof_famer, dependent: :destroy
  has_many :rosters, dependent: :destroy
  has_one :rating, dependent: :destroy
  has_many :board_members, dependent: :nullify
  has_many :committees, dependent: :nullify

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

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = Profile.new_token
    update_attribute(:reset_digest,  Profile.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

   # Sends password reset email.
  def send_password_reset_email
    ProfileMailer.password_reset(self).deliver_now
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

  # Returns a random token.
  def new_token
    SecureRandom.urlsafe_base64
  end
  
  private

    def create_remember_token
      self.remember_token = Profile.encrypt(Profile.new_remember_token)
    end
end
