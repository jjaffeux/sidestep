class Test < UIViewController
  attr_accessor :id

  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.redColor
    p id
  end
end
