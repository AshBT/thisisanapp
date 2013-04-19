Randomapp::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  #add this as options to the event below:  

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


  # counter = Event.count
  # links_array = []

  # while counter > 0 do
  #   link1 = Event.find(counter)
  #   counter -= 1
  #   link2 = Event.find(counter)
  #   links_array.push(link1, link2)
  # end

  # puts links_array



  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # ActionMailer Config
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  # change to true to allow email to be sent during development
  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = true
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



  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
end