include Redmine::Pagination
module TimelogControllerPatch
  def self.included(base)
    base.class_eval do

      def index
        retrieve_time_entry_query
        scope = time_entry_scope.
          preload(:issue => [:project, :tracker, :status, :assigned_to, :priority]).
          preload(:project, :user)
    
        respond_to do |format|
          format.html {
            @entry_count = scope.count
            @entry_pages = Paginator.new @entry_count, per_page_option, params['page']
            @entries = scope.offset(@entry_pages.offset).limit(@entry_pages.per_page).to_a
    
            render :layout => !request.xhr?
          }
          format.api  {
            @entry_count = scope.count
            @offset, @limit = api_offset_and_limit
            @entries = scope.offset(@offset).limit(@limit).preload(:custom_values => :custom_field).to_a
          }
          format.atom {
            entries = scope.limit(Setting.feeds_limit.to_i).reorder("#{TimeEntry.table_name}.created_on DESC").to_a
            render_feed(entries, :title => l(:label_spent_time))
          }
          format.csv {
            # Export all entries
            @entries = scope.to_a
            send_data(query_to_csv(@entries, @query, params), :type => 'text/csv; header=present', :filename => 'timelog.csv')
          }
          format.pdf do
            @entries = scope.to_a
            send_data(timelogs_to_pdf(@entries, @query,params), :type => 'application/pdf',:filename => "#{@project.identifier}-time_entries.pdf")
          end
    
        end
      end
      
      def show
          respond_to do |format|
            # TODO: Implement html response
            format.html
            format.api
            format.pdf do
              send_file_headers!(:type => 'application/pdf',
                                :filename => "#{@project.identifier}-#{@time_entry.id}.pdf")
            end
          end
        end
      end
    end
end