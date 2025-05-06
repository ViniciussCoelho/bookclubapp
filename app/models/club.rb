class Club < ApplicationRecord
  has_many :club_users, dependent: :destroy
  has_many :users, through: :club_users
  has_many :club_invitations, dependent: :destroy

  belongs_to :owner, class_name: "User"

  has_one_attached :banner

  validates :name, presence: true

  # Método auxiliar para obter a URL do banner, caso esteja usando Active Storage
  def banner_url
    if banner.attached?
      Rails.application.routes.url_helpers.rails_blob_url(banner, only_path: true)
    else
      nil
    end
  end

  def add_user(user, admin: false)
    club_users.create(user: user, is_admin: admin)
  end

  def generate_invitation_token(email = nil, inviter = nil)
    invitation = club_invitations.create(
      email: email,
      inviter: inviter
    )
    invitation.token
  end

  def send_invitation(email, inviter = nil, message = nil)
    invitation = club_invitations.create(
      email: email,
      inviter: inviter
    )

    # Aqui você chamaria o mailer para enviar o email
    # ClubMailer.invitation_email(invitation, message).deliver_later

    invitation
  end

  def accept_invitation(token, user)
    invitation = club_invitations.find_by(token: token)
    return false unless invitation

    invitation.accept!(user)
  end

  def append_message(user_name, message)
    self.chat_messages << {
      user: user_name,
      message: message,
      timestamp: Time.current
    }
    save!
  end
end
