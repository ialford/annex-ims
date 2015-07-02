class UnstockItem
  attr_reader :item, :user

  def self.call(item, user)
    new(item, user).unstock!
  end

  def initialize(item, user)
    @item = item
    @user = user
  end

  def unstock!
    validate_input!

    item.unstocked!

    if item.save!
      ActivityLogger.unstock_item(item: item, tray: item.tray, user: user)
      item
    else
      false
    end
  end

  private

    def validate_input!
      if IsObjectItem.call(item)
        true
      else
        raise "object is not an item"
      end
    end

  end
