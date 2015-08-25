module Motion::Project
  class Sidestep
    if App.config.template == :ios
      MAIN = "app_delegate"
    else
      MAIN = "main_activity"
    end

    def initialize(controller, keys)
      @controller = controller
      @keys = keys

      FileUtils.mkdir_p("./tmp")
    end

    def replace
      current_main = "./app/#{MAIN}.rb"

      App.config.files -= [current_main]
      new_main = prepare_tempfile(current_main)
      content = write_erb(template, {controller: @controller, keys: @keys})
      write_file(new_main, content)
      App.config.files += [new_main]
    end

    protected

    def template
      specific = "./#{MAIN}.erb"
      if File.exist?(specific)
        return File.expand_path(specific)
      end

      File.expand_path("../#{MAIN}.erb", __FILE__)
    end

    def prepare_tempfile(path)
      tempfile = File.join(File.dirname(App.config.project_dir), "tmp", File.basename(path))
      if File.exists?(tempfile)
        File.delete(tempfile)
      end
      tempfile
    end

    def write_erb(path, locals)
      template_path = File.expand_path(path, __FILE__)
      template = File.new(template_path).read
      ERB.new(template).result(OpenStruct.new(locals).instance_eval { binding })
    end

    def write_file(path, content)
      io = File.new(path, "w")
      io.puts(content)
      io.close
    end
  end
end

desc "Run a specific controller"
task :sidestep, [:controller] do |t, args|
  if args[:controller]
    controller = args[:controller]
  else
    App.fail("You have to provide a controller, eg: rake sidestep[MyController]")
  end

  ARGV.shift
  keys = ARGV.map { |option| option.split("=") }.to_h

  Motion::Project::Sidestep.new(controller, keys).replace

  if App.config.template == :ios
    Rake::Task[:simulator].invoke
  else
    App.config.sub_activities << controller.to_s
    Rake::Task[:emulator].invoke
  end
end
