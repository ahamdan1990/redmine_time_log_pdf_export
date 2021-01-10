include Redmine::Export::PDF
        module LogTimeHelper
          def timelog_to_pdf(timeentry)
            pdf = ITCPDF.new(current_language)
            pdf.set_title("Time_log_#{timeentry.id}")
            pdf.alias_nb_pages
            pdf.footer_date = format_date(User.current.today)
            pdf.add_page
            pdf.SetFontStyle('B',11)
            buf = "Time_log_#{timeentry.id}"
            image_file = Rails.root.to_s + '/plugins/redmine_time_log_pdf_export/assets/images/logo.png' #Adding logo to the exported file
            pdf.Image(image_file, 10, 10, 52, '', 'PNG', '', 'T', false, 300, '', false, false, 0, false, false, false)
            pdf.SetFontStyle('',13)
            pdf.ln(20,1)
            pdf.RDMCell(190, 5, buf,"","","C")
            pdf.ln(9,1)
                pdf.SetFontStyle('',8)
                date = "#{format_time(timeentry.created_on)}"
                comment="#{timeentry.comments}"
                activity="#{timeentry.activity.name}"
                project="#{timeentry.project.name}"
                author = "#{timeentry.user}"
                timespent = "#{timeentry.hours}"
                pdf.ln(9,1)
                base_x = pdf.get_x
  
                left = []
                left << ["Created on", date]
                left << ["Author", author]
                left << ["Project", project]
                right = []
                right << ["Activity", activity]
                right << ["Time Spent", timespent]
                right << ["Comment", comment]
  
  
                rows = left.size > right.size ? left.size : right.size
                left  << nil while left.size  < rows
                right << nil while right.size < rows
  
  
                if pdf.get_rtl
                  border_first_top = 'RT'
                  border_last_top  = 'LT'
                  border_first = 'R'
                  border_last  = 'L'
                else
                  border_first_top = 'LT'
                  border_last_top  = 'RT'
                  border_first = 'L'
                  border_last  = 'R'
                end
  
                rows = left.size > right.size ? left.size : right.size
                rows.times do |i|
                  heights = []
                  pdf.SetFontStyle('B',9)
                  item = left[i]
                  heights << pdf.get_string_height(35, item ? "#{item.first}:" : "")
                  item = right[i]
                  heights << pdf.get_string_height(35, item ? "#{item.first}:" : "")
                  pdf.SetFontStyle('',9)
                  item = left[i]
                  heights << pdf.get_string_height(60, item ? item.last.to_s  : "")
                  item = right[i]
                  heights << pdf.get_string_height(60, item ? item.last.to_s  : "")
                  height = heights.max
  
                  item = left[i]
                  pdf.SetFontStyle('B',9)
                  pdf.RDMMultiCell(35, height, item ? "#{item.first}:" : "", (i == 0 ? border_first_top : border_first), '', 0, 0)
                  pdf.SetFontStyle('',9)
                  pdf.RDMMultiCell(60, height, item ? item.last.to_s : "", (i == 0 ? border_last_top : border_last), '', 0, 0)
  
                  item = right[i]
                  pdf.SetFontStyle('B',9)
                  pdf.RDMMultiCell(35, height, item ? "#{item.first}:" : "",  (i == 0 ? border_first_top : border_first), '', 0, 0)
                  pdf.SetFontStyle('',9)
                  pdf.RDMMultiCell(60, height, item ? item.last.to_s : "", (i == 0 ? border_last_top : border_last), '', 0, 2)
  
                  pdf.set_x(base_x)
                end
  
                pdf.set_text_color(0,63,127)
                pdf.SetFontStyle('B',8)
                pdf.RDMCell(190,5, "Custom Fields","LRTB","","C")
                pdf.set_text_color(0,0,0)
                pdf.ln(5,1)
                timeentry.custom_field_values.each do |value|
                  pdf.set_x(base_x)
                  name=value.custom_field.name
                  pdf.RDMMultiCell(190,5,name+": "+value.value,1,"LRTB")
                end
            pdf.output
          end
        end

  