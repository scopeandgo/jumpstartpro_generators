Rails.application.config.generators do |g|
  g.orm :active_record, primary_key_type: :bigint

  # Don't generate app/assets/controller_name.scss with generators
  g.stylesheets false
  g.helper false
  g.jbuilder false
  g.view_specs false
  g.helper_specs false
end
