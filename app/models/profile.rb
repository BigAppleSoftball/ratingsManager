class Profile < ActiveRecord::Base
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  has_secure_password
  validates :password, length: { minimum: 6 }
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

  private

    def create_remember_token
      self.remember_token = Profile.encrypt(Profile.new_remember_token)
    end
end
