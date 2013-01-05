Irm::Person.class_eval do
  #覆盖Person中对邮箱唯一性的检查
  def need_uniqueness_email
    false
  end
end