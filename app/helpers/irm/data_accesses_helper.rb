# -*- coding: utf-8 -*-
module Irm::DataAccessesHelper
  def available_access_level
    lookup("IRM_DATA_ACCESS_LEVEL")
  end

  def available_accessible_bo
    [[t(:label_irm_data_access_all_business_object),nil]]+Irm::BusinessObject.multilingual.collect{|i| [i[:name],i.id]}
  end


  # 将组织数据以树形展示
  def organizations_tree_data
    organizations = Irm::Organization.multilingual.enabled.order("id")
    datas = {:root=>[]}
    organizations.each do |org|
      if org.parent_org_id.present?
        datas[org.parent_org_id] ||= []
        datas[org.parent_org_id] << org
      else
        datas[:root] << org
      end
    end

    tree_html = "<ul id='organizations' class='treeview-red'>"

    datas[:root].each do |org|
      tree_html << org_tree_expand(org,datas)
    end
    tree_html << "</ul>"
    raw tree_html
  end

  def org_tree_expand(org,datas)
    tree_html = ""
    if datas[org.id].present?
      tree_html << "<li><a ref='#{org.id}' class='org' href='javascript:void(0)'>#{org[:name]}</a><ul>"
      datas[org.id].each do |sub_org|
        tree_html << org_tree_expand(sub_org,datas)
      end
      tree_html << "</ul></li>"
    else
      tree_html << "<li><a ref='#{org.id}' class='org' href='javascript:void(0)'>#{org[:name]}</a></li>"
    end
    tree_html
  end

  def org_data_accesses(org_id)
    Irm::DataAccess.prepare_for_opu
    opu_data_accesses = Irm::DataAccess.opu_data_access.list_all

    org_data_accesses = Irm::DataAccess.org_data_access(org_id).list_all

    data_accesses = []

    opu_data_accesses.each do |opu_data_access|
      current_access = opu_data_access.attributes.symbolize_keys
      current_org_access =  org_data_accesses.detect{|i| i[:business_object_id].eql?(opu_data_access[:business_object_id])}
      if current_org_access
        current_access[:org_access_level] = current_org_access[:access_level]
        current_access[:org_access_level_name] = current_org_access[:access_level_name]

      else
        current_access[:org_access_level] = nil
        current_access[:org_access_level_name] = t(:label_irm_data_access_org_not_set)

      end
      data_accesses << current_access
    end
    data_accesses
  end

  def available_org_access_level
    [[t(:label_irm_data_access_org_not_set),nil]]+lookup("IRM_DATA_ACCESS_LEVEL")
  end

end
