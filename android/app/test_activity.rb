class TestActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super
    puts "TestActivity"
  end
end
