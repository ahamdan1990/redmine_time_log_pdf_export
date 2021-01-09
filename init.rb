require 'redmine'
require 'LogTimeHelper'
require 'timelogcontroller_patch'
Redmine::Plugin.register :time_log_pdf_export do
  name 'Time Log Pdf Export plugin'
  author 'Ali Hamdan'
  description 'This is a plugin for Redmine Time_Log module that add a button in the list table of time_log view which export it as a pdf'
  version '1.0.0'
  url 'https://github.com/ahamdan1990/redmine_time_report_pdf'
  author_url 'https://github.com/ahamdan1990'
end

TimelogHelper.send(:include,  LogTimeHelper)
TimelogController.send(:include, TimelogControllerPatch)
