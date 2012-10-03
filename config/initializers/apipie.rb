Apipie.configure do |config|
  config.app_name = "Fantasy Football APIs"
  config.copyright = "Some legal BS goes here"
  config.doc_base_url = "/apidoc"
  config.api_base_url = "/api"
  config.validate = false
  #config.markup = Apipie::Markup::Markdown.new
  config.reload_controllers = true
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api_controller.rb"
  config.app_info = <<-DOC
    List of APIs available for fantasy football app
  DOC
end