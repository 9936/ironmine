# -*- coding: utf-8 -*-
module Irm::MenuEntriesHelper
  def available_sub_menu
    Irm::Menu.multilingual.collect {|menu| [menu[:name],menu[:id]]}
  end
  def available_sub_function_group
    Irm::FunctionGroup.multilingual.collect {|group| [group[:name],group[:id]]}
  end
end