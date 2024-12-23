module AssetsHelper
  def tasty_include_stylesheets(*packages)
    options = packages.extract_options!

    packages.map { |pack| tasty_include_stylesheet(pack, options) }.join("\n").html_safe
  end

  def tasty_include_stylesheet(name, options = {})
    if Rails.env.development?
      tag :link,
        :href => service_url(
                    css_packages_path(
                      :name => name,
                      :ts => Time.now.to_i
                    )
                  ),
        :rel => 'stylesheet',
        :type => 'text/css',
        :media => 'all'
    else
      stylesheet_link_tag(name, :cache => "cache/#{name}" ) rescue nil
    end
  end

  def tasty_stylesheet_path(name, options = {})
    if Rails.env.development?
      service_url(css_packages_path(:name => name, :ts => Time.now.to_i))
    else
      stylesheet_path("cache/#{name}")
    end
  end

  def tasty_include_javascripts(*packages)
    options = packages.extract_options!
    packages.map { |pack| tasty_include_package(pack, options) }.join("\n").html_safe
  end

  def tasty_include_package(name, options = {})
    if Rails.env.development?
      content_tag :script, '', :type => 'text/javascript', :src => service_url(js_packages_path(:name => name))
    else
      javascript_include_tag(name, :cache => "cache/#{name}" ) rescue nil
    end
  end

  def tasty_javascript_path(name, options = {})
    if Rails.env.development?
      service_url(js_packages_path(:name => name))
    else
      javascript_path("cache/#{name}")
    end
  end

end
