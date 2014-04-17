class DateTimeInput < SimpleForm::Inputs::Base
  def input
    input_html_options[:class] << "datepicker"
    @builder.text_field(attribute_name, input_html_options)
  end
end
