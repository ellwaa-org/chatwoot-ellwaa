class ContactPolicy < ApplicationPolicy
  def index?
    true
  end

  def active?
    true
  end

  def import?
    @account_user.administrator?
  end

  def export?
    @account_user.administrator?
  end

  def search?
    true
  end

  def filter?
    true
  end

  def update?
    contact_accessible?
  end

  def contactable_inboxes?
    true
  end

  def destroy_custom_attributes?
    true
  end

  def show?
    contact_accessible?
  end

  def create?
    true
  end

  def avatar?
    true
  end

  def destroy?
    @account_user.administrator?
  end

  private

  # Agents can only open/edit contacts whose conversations are assigned to
  # them; administrators and Enterprise custom roles (contact_manage) are
  # unrestricted.
  def contact_accessible?
    return true if @account_user.administrator?
    return true if @account_user.permissions.include?('contact_manage')

    record.conversations.exists?(assignee_id: @user.id)
  end
end

ContactPolicy.prepend_mod_with('ContactPolicy')
