include Redmine::Export::PDF
module AllTimeLogHelper
    def timelogs_to_pdf(items, query, options={})
        columns = query.columns

        pdf = ITCPDF.new(current_language,"L")
        pdf.set_title("Timelog_entries")
        pdf.alias_nb_pages
        pdf.footer_date = format_date(User.current.today)
        pdf.add_page
        pdf.SetFontStyle('B',11)
        buf = "Timelog_entries"
        pdf.SetFontStyle('',13)
        pdf.RDMCell(190, 5, buf,"","","C")
        pdf.ln(9,1)
        base_x = pdf.get_x

        pdf.set_x(base_x)
        columns.each do |c| 
            pdf.set_text_color(0,63,127)
            pdf.SetFontStyle('B',8)
            pdf.RDMCell(30,5,c.caption.to_s,1,"LRTB")
        end
        pdf.ln(5,1)
        pdf.set_x(base_x)
        
        details=Array.new
        items.each do |item|
            details << columns.map {|c| pdf_content(c, item)}
        end
        details.each do |detail|
            detail.each do |d|
                pdf.RDMCell(30,5,d,1,"LRTB")
            end
            pdf.ln(5,1)
        end
        pdf.output
    end
end

