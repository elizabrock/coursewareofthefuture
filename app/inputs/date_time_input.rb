class DateTimeInput < SimpleForm::Inputs::Base
  def label(wrapper_options)
    @@i ||= 0
    @@i += 1
    label_for = "#{attribute_name}_datepicker#{@@i}"
    @builder.label(label_for, label_text, merge_wrapper_options(label_html_options, wrapper_options)).gsub(/for="([^"]*)"/, "for='#{input_class}_datepicker#{@@i}'")
  end

  def input(wrapper_options)
    input_html_options[:class] << "datepicker"
    input_html_options[:id] = "#{input_class}_datepicker#{@@i}"
    input_html_options[:value] = @builder.object.send(attribute_name).try(:strftime, '%Y/%m/%d')
    @builder.text_field(attribute_name, merge_wrapper_options(input_html_options, wrapper_options))
  end
end
