# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron


set :output, "log/cron_log.log"

# set :environment , :production
set :environment , :development

every :hour do
# every 1.minute do
  runner "User.update_user_statistic_record"
  runner "IncomeRecord.update_income_statistic_record"
end

every 1.day, :at => '3:59 pm' do
  runner "ProjectSeasonApplyBookshelf.clear_garbage"
  runner "BookshelfSupplement.clear_garbage"
end

# Learn more: http://github.com/javan/whenever
