class CreateAccountInteractor < BaseInteractor
  def initialize(user)
    @user = user
  end

  def perform
    if account.save
      succeeded(account)
    else
      succeeded(account.errors)
    end
  end

  private

  attr_accessor :user

  def account
    @account ||= Account.new(user_id: user.id)
  end
end
