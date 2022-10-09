class Platform < ApplicationRecord
  self.primary_key = :system_id

  def self.save_platform_info(log, decode_tx)
    platform = Platform.find(log["info"]["systemId"])

    case log["abi"]["name"]
    when "CreatePlatform"
      platform.update!({tb_manager: log["info"]["tbManager"], rights_account: log["info"]["rightsAccount"]})
    when "PlatformRightsInfo"
      platform.update!({rights_amount: log["info"]["amount"]})
    end
  end

end
