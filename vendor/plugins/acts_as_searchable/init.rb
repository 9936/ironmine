# Include hook code here
require File.dirname(__FILE__) + '/lib/acts_as_searchable'
ActiveRecord::Base.send(:include, Ironmine::Acts::Searchable)
ActionView::Base.send(:include,SearchableHelper)
