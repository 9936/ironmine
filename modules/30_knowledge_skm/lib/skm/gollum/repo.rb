module Skm::Gollum::Repo
  def diff(a, b, *paths)
    diff = self.git.native('diff', {}, a, b, '--', *paths)
    # 修正中文文件名无法进行diff的bug
    diff.gsub!("diff --git \"a/","diff --git a\"")
    if diff =~ /diff --git a/
      diff = diff.sub(/.*?(diff --git a)/m, '\1')
    else
      diff = ''
    end
    Diff.list_from_string(self, diff)
  end
end