set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

configure :development do
  activate :livereload
end

configure :build do
  set :relative_links, true
  activate :minify_css
  activate :minify_javascript
  activate :relative_assets
end
