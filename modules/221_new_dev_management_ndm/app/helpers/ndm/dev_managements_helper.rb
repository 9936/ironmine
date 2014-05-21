module Ndm::DevManagementsHelper
  def ndm_get_priority_list
    Irm::LookupValue.
        get_lookup_value("NDM_PRIORITY").
        enabled.
        collect{|lv| [lv[:meaning], lv[:lookup_code]]}
  end

  def ndm_get_dev_type_list
    Irm::LookupValue.
        get_lookup_value("NDM_TYPE").
        enabled.
        collect{|lv| [lv[:meaning], lv[:lookup_code]]}
  end

  def ndm_get_phase_list
    [["gd", "General Design"],["fd", "Functional Design"],["fdr", "Functional Design Review"],
     ["td", "Technical Design"],["co", "Coding"],["te", "Testing"],["si", "Setups&Installation"],
     ["at", "Acceptance Testing"],["go", "Golive"]]

  end

  # build the stage collapse
  def ndm_build_stage_collapse(data)

    phases = ndm_get_phase_list

    html = ""
    phases.each do |p|
      case data[(p[0] + "_status").to_sym]
        when "NDM_PHASE_STATUS_OPEN"
          html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow requested' title='#{p[1]} #{data[(p[0] + "_status_name").to_sym]}'></div></td>
                            <td><div class='name'>#{p[1]}</div></td>
                          </tr>
                        </table>
                      </div>"
        when "NDM_PHASE_STATUS_IP"
          html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow active' title='#{p[1]} #{data[(p[0] + "_status_name").to_sym]}'></div></td>
                            <td><div class='name'>#{p[1]}</div></td>
                          </tr>
                        </table>
                      </div>"
        when "NDM_PHASE_STATUS_COMPLETED"
           html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow complete' title='#{p[1]} #{data[(p[0] + "_status_name").to_sym]}'></div></td>
                            <td><div class='name'>#{p[1]}</div></td>
                          </tr>
                        </table>
                      </div>"
        when "NDM_PHASE_STATUS_CANCELLED"
           html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow closed' title='#{p[1]} #{data[(p[0] + "_status_name").to_sym]}'></div></td>
                            <td><div class='name'>#{p[1]}</div></td>
                          </tr>
                        </table>
                      </div>"
        when "NDM_PHASE_STATUS_DELAYED"
          html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow delayed' title='#{p[1]} #{data[(p[0] + "_status_name").to_sym]}'></div></td>
                            <td><div class='name'>#{p[1]}</div></td>
                          </tr>
                        </table>
                      </div>"
        else
          html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow pending' title='#{p[1]} #{data[(p[0] + "_status_name").to_sym]}'></div></td>
                            <td><div class='name'>#{p[1]}</div></td>
                          </tr>
                        </table>
                      </div>"
      end
    end
    raw html
  end

  # build the owner collapse
  def ndm_build_owner_collapse(data)
    phases = ndm_get_phase_list
    html = ""
    phases.each do |p|
      if data[(p[0] + "_owner").to_sym].present?
        html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow slim space' title='#{data[(p[0] + "_owner").to_sym]}'></div></td>
                            <td><div class='name'>#{data[(p[0] + "_owner").to_sym]}</div></td>
                          </tr>
                        </table>
                      </div>"
      else
        html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow slim space' title='#{data[(p[0] + "_owner").to_sym]}'></div></td>
                            <td><div class='name'>&nbsp;</div></td>
                          </tr>
                        </table>
                      </div>"
      end
    end
    raw html
  end

  # build the status collapse
  def ndm_build_status_collapse(data)
    phases = ndm_get_phase_list
    html = ""
    phases.each do |p|
      if data[(p[0] + "_status_name").to_sym].present?
        html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow slim space' title='#{data[(p[0] + "_status_name").to_sym]}'></div></td>
                            <td><div class='name'>#{data[(p[0] + "_status_name").to_sym]}</div></td>
                          </tr>
                        </table>
                      </div>"
      else
        html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow slim space' title='#{data[(p[0] + "_status_name").to_sym]}'></div></td>
                            <td><div class='name'>&nbsp;</div></td>
                          </tr>
                        </table>
                      </div>"
      end
    end
    raw html
  end

  # build the plan_start collapse
  def ndm_build_ps_collapse(data)
    phases = ndm_get_phase_list
    html = ""
    phases.each do |p|
      if data[(p[0] + "_plan_start").to_sym].present?
        html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow slim space' title='#{data[(p[0] + "_plan_start").to_sym]}'></div></td>
                            <td><div class='name'>#{data[(p[0] + "_plan_start").to_sym]}</div></td>
                          </tr>
                        </table>
                      </div>"
      else
        html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow slim space' title='#{data[(p[0] + "_plan_start").to_sym]}'></div></td>
                            <td><div class='name'>&nbsp;</div></td>
                          </tr>
                        </table>
                      </div>"
      end
    end
    raw html
  end

  # build the plan_end collapse
  def ndm_build_pe_collapse(data)
    phases = ndm_get_phase_list
    html = ""
    phases.each do |p|
      if data[(p[0] + "_plan_end").to_sym].present?
        html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow slim space' title='#{data[(p[0] + "_plan_end").to_sym]}'></div></td>
                            <td><div class='name'>#{data[(p[0] + "_plan_end").to_sym]}</div></td>
                          </tr>
                        </table>
                      </div>"
      else
        html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow slim space' title='#{data[(p[0] + "_plan_end").to_sym]}'></div></td>
                            <td><div class='name'>&nbsp;</div></td>
                          </tr>
                        </table>
                      </div>"
      end
    end
    raw html
  end

  # build the real_start collapse
  def ndm_build_rs_collapse(data)
    phases = ndm_get_phase_list
    html = ""
    phases.each do |p|
      if data[(p[0] + "_real_start").to_sym].present?
        html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow slim space' title='#{data[(p[0] + "_real_start").to_sym]}'></div></td>
                            <td><div class='name'>#{data[(p[0] + "_real_start").to_sym]}</div></td>
                          </tr>
                        </table>
                      </div>"
      else
        html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow slim space' title='#{data[(p[0] + "_real_start").to_sym]}'></div></td>
                            <td><div class='name'>&nbsp;</div></td>
                          </tr>
                        </table>
                      </div>"
      end
    end
    raw html
  end

  # build the real_end collapse
  def ndm_build_re_collapse(data)
    phases = ndm_get_phase_list
    html = ""
    phases.each do |p|
      if data[(p[0] + "_real_end").to_sym].present?
        html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow slim space' title='#{data[(p[0] + "_real_end").to_sym]}'></div></td>
                            <td><div class='name'>#{data[(p[0] + "_real_end").to_sym]}</div></td>
                          </tr>
                        </table>
                      </div>"
      else
        html << "<div><table cellpadding='0' cellspacing='0' style='display: inline;'>
                          <tr>
                            <td><div class='workflow slim space' title='#{data[(p[0] + "_real_end").to_sym]}'></div></td>
                            <td><div class='name'>&nbsp;</div></td>
                          </tr>
                        </table>
                      </div>"
      end
    end
    raw html
  end
end
