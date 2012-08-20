module Skm::Gollum::Repo
  def self.included(base)
    base.class_eval do
      def diff(a, b, *paths)
        diff = self.git.native('diff', {}, a, b, '--', *paths)
        # 修正中文文件名无法进行diff的bug
        if diff =~ /diff --git a/
          diff = diff.sub(/.*?(diff --git a)/m, '\1')
        elsif diff =~ /diff --git "a/
          diff = diff.sub(/.*?(diff --git "a)/m, '\1')
        else
          diff = ''
        end
        Grit::Diff.list_from_string(self, diff)
      end
    end
  end
end