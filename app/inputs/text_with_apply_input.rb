class TextWithApplyInput < Formtastic::Inputs::StringInput
  def to_html
    value = @object.send(method)
    input_wrapping do
      if value.blank?
        label_html <<
        builder.text_field(method, input_html_options)
      else
        label_html <<
        builder.text_field(method, input_html_options) +
        template.link_to("»", "#", class: 'light-button apply right', rel: "#candidate_#{method}")
      end
    end
  end
end