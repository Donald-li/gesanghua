class Api::Entrance::LingXi::MonthDonatesController < Api::Entrance::LingXi::BaseController

  def synchronize
    logger.info "+++++++++++++++++"
    logger.info params.inspect
    logger.info request.body.read
    logger.info JSON.parse(request.body.read).inspect
    logger.info "+++++++++++++++++"

  end

end
