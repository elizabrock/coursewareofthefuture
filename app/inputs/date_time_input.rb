class DateTimeInput < SimpleForm::Inputs::Base
  def label
    @@i ||= 0
    @@i += 1
    label_for = "#{attribute_name}_datepicker#{@@i}"
    @builder.label(label_for, label_text, label_html_options).gsub(/for="([^"]*)"/, "for='#{input_class}_datepicker#{@@i}'")
  end

  def input
    input_html_options[:class] << "datepicker"
    input_html_options[:id] = "#{input_class}_datepicker#{@@i}"
    @builder.text_field(attribute_name, input_html_options)
  end
end
