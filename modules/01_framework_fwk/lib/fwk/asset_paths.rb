# 修改asset path 生成相对路径
module Fwk::AssetPaths
  def self.included(base)
    base.class_eval do
      private
      def rewrite_relative_url_root(source, relative_url_root)
        relative_url_root && !source.starts_with?("#{relative_url_root}/") ? "#{relative_url_root}#{source}" : "..#{source}"
      end
    end
  end
end