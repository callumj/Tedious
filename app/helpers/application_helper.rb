require 'uglifier'

module ApplicationHelper

  def bookmarklet_js(name)
    path = File.join(Rails.root, "public", "assets", "bookmarklet.#{name}.js")
    if File.exist? path
      raw IO.read(path)
    else
      asset_path = File.join(Rails.root, "app", "assets", "javascripts", "bookmarklet.#{name}.js")
      raw Uglifier.compile(IO.read(asset_path), compress: {drop_debugger: false})
    end
  end

end
