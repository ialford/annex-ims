module RecurringSelectTagHelper
  def select_recurring_tag(name, default_schedules = nil, options = {}, html_options = {})
    RecurringSelectTag.new(nil, name, self, default_schedules, options, html_options).render
  end

  # copied from recurring_select source because they made it private so I can't call it
  private

  module SelectHTMLOptions
    private

    def recurring_select_html_options(html_options)
      html_options = html_options.stringify_keys
      html_options['class'] = (html_options['class'].to_s.split + ['recurring_select']).join(' ')
      html_options
    end
  end

  class RecurringSelectTag < ActionView::Helpers::Tags::Base
    include RecurringSelectHelper::FormOptionsHelper
    include SelectHTMLOptions

    def initialize(object, method, template_object, default_schedules = nil, options = {}, html_options = {})
      @default_schedules = default_schedules
      @choices = @choices.to_a if @choices.is_a?(Range)
      @method_name = method.to_s
      @object_name = object.to_s
      @html_options = recurring_select_html_options(html_options)
      @template_object = template_object
      add_default_name_and_id(@html_options)

      super(object, method, template_object, options)
    end

    def render
      option_tags = add_options(recurring_options_for_select(value, @default_schedules, @options), @options, value)
      select_content_tag(option_tags, @options, @html_options)
    end
  end
end
