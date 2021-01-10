require_dependency '../app/helpers/queries_helper'
require 'application_helper'

module QueriesHelper
    def pdf_content(column, item)
        value = column.value_object(item)
        if value.is_a?(Array)
        value.collect {|v| pdf_value(column, item, v)}
        else
        pdf_value(column, item, value)
        end
    end

    def pdf_value(column, object, value)
        case column.name
        when :attachments
        value.to_a.map {|a| a.filename}.join("\n")
        else
        format_object(value, false) do |value|
            case value.class.name
            when 'Float'
            sprintf("%.2f", value)
            when 'IssueRelation'
            value.to_s(object)
            when 'Issue'
            if object.is_a?(TimeEntry)
                value.visible? ? "#{value.tracker} ##{value.id}: #{value.subject}" : "##{value.id}"
            else
                value.id
            end
            else
            value
            end
        end
        end
    end
end