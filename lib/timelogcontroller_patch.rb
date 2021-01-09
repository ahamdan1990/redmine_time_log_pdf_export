module TimelogControllerPatch
  def self.included(base)
    base.class_eval do
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