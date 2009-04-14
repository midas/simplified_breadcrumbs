module SimplifiedBreadcrumbs

  class ActionController::Base

    protected

    def add_breadcrumb(name, url)
      @breadcrumbs ||= []
      url = send(url) if url.is_a?(Symbol)
      @breadcrumbs << [name, url]
    end

    def self.add_breadcrumb(name, url, options = {})
      before_filter(options) do |controller|
        controller.send(:add_breadcrumb, name, url)
      end
    end

  end

  module Helper

    # Returns the HTML for the 
    #
    def breadcrumb( *args )
      options = args.extract_options!
      options[:separator] ||= "&rsaquo;"
      html = ""
      return html if @breadcrumbs.nil?
      if options[:wrap_with]
        html = @breadcrumbs.map { |name, url| "<#{options[:wrap_with]}>#{link_to_unless_current( name, url )}</#{options[:wrap_with]}>" }.join( "" )
      elsif options[:seperator]
        html = @breadcrumbs.map { |name, url| link_to_unless_current( name, url ) }.join(" #{options[:separator]} ")
      end
      return html
    end
    
  end

end

ActionController::Base.send(:include, SimplifiedBreadcrumbs)
ActionView::Base.send(:include, SimplifiedBreadcrumbs::Helper)