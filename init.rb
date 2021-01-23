require 'redmine'
require 'logtimehelper'
require 'alltimeloghelper'
require 'timelogcontroller_patch'
require_dependency 'queries_helper_patch'

Redmine::Plugin.register :redmine_time_log_pdf_export do
  name 'Redmine Time Log Pdf Export plugin'
  author 'Ali Hamdan'
  description 'This is a plugin for Redmine Time_Log module that add a button in the list table of time_log view which export it as a pdf'
  version '1.0.0'
  url 'https://github.com/ahamdan1990/redmine_time_report_pdf'
  author_url 'https://github.com/ahamdan1990'
end

TimelogHelper.send(:include,  LogTimeHelper)
TimelogHelper.send(:include,  AllTimeLogHelper)
TimelogController.send(:include, TimelogControllerPatch)
# QueriesHelper.send(:include, QueriesHelperPatch)
