desc "Run a specific controller"
task :bypass, [:controller] do |t, args|
  def write_erb(path, locals)
    template_path = File.expand_path(path, __FILE__)
    template = File.new(template_path).read
    ERB.new(template).result(OpenStruct.new(locals).instance_eval { binding })
  end

  def prepare_tmp_file(path)
    tmpfile = File.join(File.dirname(App.config.project_dir), "tmp", File.basename(path))
    if File.exists?(tmpfile)
      File.delete(tmpfile)
    end
    tmpfile
  end

  def write_file(path, content)
    io = File.new(path, "w")
    io.puts(content)
    io.close
  end

  def find_template(files)
    specific = "./app_delegate.erb"
    if File.exist?(specific)
      return File.expand_path(specific)
    end

    File.expand_path("../app_delegate.erb", __FILE__)
  end

  if args[:controller]
    controller = args[:controller]
  else
    App.fail("You have to provide a valid controller, eg: rake bypass[MyController]")
  end

  ARGV.shift
  keys = ARGV.map { |option| option.split("=") }.to_h

  current_app_delegate = "./app/app_delegate.rb"
  App.config.files -= [current_app_delegate]
  new_app_delegate = prepare_tmp_file(current_app_delegate)
  FileUtils.mkdir_p("./tmp")
  template = find_template(App.config.files)
  content = write_erb(template, {controller: controller, keys: keys})
  write_file(new_app_delegate, content)
  App.config.files += [new_app_delegate]

  Rake::Task[:simulator].invoke
end
