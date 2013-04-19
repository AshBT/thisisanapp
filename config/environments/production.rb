Randomapp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb


  set_trace_func proc { |event, file, line, id, classname, binding| 
    whitelist = %w(call return)
    #blacklist = %w(c-call c-return line end class return)
    #if event != "c-call" && event != "c-return" && event != "line" && event != "end" && event != "class" && event != "return" && file =~ /(app\/.*)/
    #if file =~ /(app\/.*)/ && blacklist.include?(event) == false
    #
    if file =~ /(app\/.*)/ and whitelist.include? event
      @event = "#{event}"
      @file = "#{file}"
      @line = "#{line}"
      @classname = "#{classname}"
      #puts classname.methods - Object.methods
      #@callers = "#{classname.of_caller(2)}"
      @methods_available = "#{classname.methods - Object.methods}"
      #@caller_classname = "#{classname.parent}"
      @instance_values = "#{classname.instance_values}"
      #@class_binding_list = "{classname.__binding__.pretty_inspect}"
      @id = "#{id}"
      defaults = {"binding" => "source"}
      # @ancestors = "#{classname.ancestors}"
      # @eval = "#{classname.eval}"    
      # puts binding.inspect
      # puts classname.callers
      # puts classname.callers.map &:frame_description
      # puts classname
      # puts binding
      # puts binding.methods
      # # puts classname.__binding__.of_caller(0)
      # puts classname.of_caller(1).of_caller(1).frame_description
      # puts classname.of_caller(2).of_caller(1).frame_description
      # puts classname.of_caller(0).frame_description
      # puts classname.of_caller(1).frame_description
      # puts classname.of_caller(2).frame_description
      # puts classname.of_caller(0).frame_count
      # puts classname.of_caller(1).frame_count
      # puts classname.of_caller(2).frame_count
      @method_start = "#{classname.callers[2].frame_description}"
      @method_return = "#{classname.callers[-2].frame_description}"
      @binding_parent = "#{binding.parent_name.inspect}"
      @file_and_line = "#{@file.split("/")[-2]} + / + #{@file.split("/")[-1]} + #{line}"
      puts @file_and_line

      if @binding == "nil" or @binding == "null"
        @binding = "rails source"
      else
        @binding
      end

      if @binding_parent == "nil" or @binding_parent == "null"
        @binding_parent = "rails source"
      else
        @binding_parent
      end

      a = defaults.merge(
        "event" => @event, 
        "file" => @file, 
        "line" => @line, 
        "classname" => @classname, 
        "callers" => @callers, 
        "methods_available" => @methods_available,
        "class_binding_list" => @class_binding_list, 
        "instance_values" => @instance_values, 
        "caller_classname" => @caller_classname,
        "id" => @id,
        "binding" => @binding,
        "ancestors" => @ancestors,
        "evals" => @eval,
        "binding_parent" => @binding_parent,
        "initial_frame_description" => classname.callers[0].frame_description,
        "initial_frame_type" => classname.callers[0].frame_type,
        "method_start" => classname.callers[2].frame_description,
        "method_return" => classname.callers[-2].frame_description,
        "final_frame_type" => classname.callers[-1].frame_description
        )

      puts a
      
      #binding.pry

      if event == "call"
        Node.create(:source => @binding_parent, :target => @binding)
        Node.create(:source => @binding, :target => @file_and_line)
        Node.create(:source => @file_and_line, :target => @method_start)
        Node.create(:source => @file_and_line, :target => @method_return)
      else
        Node.create(:source => @file_and_line, :target => @binding_parent)
      end

      Event.create(:event_name => @event,
                    :file => @file,
                    :line => @line,
                    :classname => @classname,
                    )
  end
}


  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { :host => 'example.com' }
  # ActionMailer Config
  # Setup for production - deliveries, no errors raised
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default :charset => "utf-8"

  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: "example.com",
    authentication: "plain",
    enable_starttls_auto: true,
    user_name: ENV["GMAIL_USERNAME"],
    password: ENV["GMAIL_PASSWORD"]
  }



  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5
end
