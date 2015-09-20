class Yan::WorkloadAuthoritiesController < ApplicationController
  def index

  end

  def add_workload_authority
    puts "~~~~&&&&&&~~~~~"
    puts params[:yiss_people]
    puts "``````````"
    puts params[:hand_people]
    puts "=============="
    # 勾选了 yiss
    if params[:yiss_people]
      puts "==="
      puts Yan::WorkloadAuthority.with_object_type_and_id("ORG", "001q00091nQ3qKZLDIeYoi").any?
      puts "==="
      if !Yan::WorkloadAuthority.with_object_type_and_id("ORG", "001q00091nQ3qKZLDIeYoi").any?
        puts "----------"

        puts "----------"
        Yan::WorkloadAuthority.create(:ob_type => "ORG", :ob_id => "001q00091nQ3qKZLDIeYoi")
        Irm::Person.where("organization_id = '001q00091nQ3qKZLDIeYoi'").update_all(:workload_flag => 'Y' )
        # ActiveRecord::Base.connection.execute(%Q(UPDATE irm_people ip SET ip.workload_flag = 'Y' WHERE ip.organization_id = '001q00091nQ3qKZLDIeYoi'))
      end
    else
      if Yan::WorkloadAuthority.with_object_type_and_id("ORG", "001q00091nQ3qKZLDIeYoi").any?
        Yan::WorkloadAuthority.delete_all(:ob_id => "001q00091nQ3qKZLDIeYoi")
        ActiveRecord::Base.connection.execute(%Q(UPDATE irm_people ip SET ip.workload_flag = 'N' WHERE ip.organization_id = '001q00091nQ3qKZLDIeYoi'))
      end
    end

    # 勾选了 hand
    if params[:hand_people]
      puts "======== ok ========="
      if !Yan::WorkloadAuthority.with_object_type_and_id("ORG", "001q00091nQ3qKZLEmXAdE").any?
        Yan::WorkloadAuthority.create(:ob_type => "ORG", :ob_id => "001q00091nQ3qKZLEmXAdE")
        ActiveRecord::Base.connection.execute(%Q(UPDATE irm_people ip SET ip.workload_flag = 'Y' WHERE ip.organization_id = '001q00091nQ3qKZLEmXAdE'))
      end
    else
      if Yan::WorkloadAuthority.with_object_type_and_id("ORG", "001q00091nQ3qKZLEmXAdE").any?
        Yan::WorkloadAuthority.delete_all(:ob_id => "001q00091nQ3qKZLEmXAdE")
        ActiveRecord::Base.connection.execute(%Q(UPDATE irm_people ip SET ip.workload_flag = 'N' WHERE ip.organization_id = '001q00091nQ3qKZLEmXAdE'))
      end
    end

    # 勾选了sd group
    if params[:sd_people]
      # 如果表中没有对应纪录，则新建，并更新irm_people表中相应人员的workload_flag字段
      if !Yan::WorkloadAuthority.with_object_type_and_id("GROUP", "001400091nvxvi9mGSGGq8").any?
        Yan::WorkloadAuthority.create(:ob_type => "GROUP", :ob_id => "001400091nvxvi9mGSGGq8")
        ActiveRecord::Base.connection.execute(%Q(UPDATE irm_people ip1
                                                    SET ip1.workload_flag = 'Y'
                                                    WHERE
                                                      ip1.id IN (
                                                        SELECT
                                                          ip_tmp.id
                                                        FROM
                                                          (
                                                            SELECT
                                                              ip.*
                                                            FROM
                                                              irm_people ip,
                                                              irm_group_members igm
                                                            WHERE
                                                              ip.id = igm.person_id
                                                            AND igm.group_id = '001400091nvxvi9mGSGGq8'
                                                          ) ip_tmp
                                                      )))
      end
    else
      if Yan::WorkloadAuthority.with_object_type_and_id("GROUP", "001400091nvxvi9mGSGGq8").any?
        Yan::WorkloadAuthority.delete_all(:ob_id => "001400091nvxvi9mGSGGq8")
        ActiveRecord::Base.connection.execute(%Q(UPDATE irm_people ip1
                                                    SET ip1.workload_flag = 'N'
                                                    WHERE
                                                      ip1.id IN (
                                                        SELECT
                                                          ip_tmp.id
                                                        FROM
                                                          (
                                                            SELECT
                                                              ip.*
                                                            FROM
                                                              irm_people ip,
                                                              irm_group_members igm
                                                            WHERE
                                                              ip.id = igm.person_id
                                                            AND igm.group_id = '001400091nvxvi9mGSGGq8'
                                                          ) ip_tmp
                                                      )))
      end
    end

    respond_to do |format|
      format.html { redirect_to({:action => "index"}, :notice => t(:successfully_updated)) }
      format.xml  { head :ok }
    end
  end

end