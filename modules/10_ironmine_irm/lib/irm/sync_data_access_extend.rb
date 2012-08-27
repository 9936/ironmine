class Irm::SyncDataAccessExtend
  include Singleton

  def extend_data_access_model
    Irm::Person.class_eval do
      # 新建用户
      after_create do
        Delayed::Job.enqueue(Irm::Jobs::SyncDataAccessJob.new({:type => self.class.name, :id => self.id, :operation => :create}))
      end

      # 更新用户
      before_update do
        origin_person = self.class.query(self.id).first
        # 修改了用户的组织或角色
        unless origin_person.organization_id.eql?(self.organization_id)&&origin_person.role_id.eql?(self.role_id)
          Delayed::Job.enqueue(Irm::Jobs::SyncDataAccessJob.new({:type => self.class.name, :id => self.id, :organization_id => origin_person.organization_id, :role_id => origin_person.role_id, :operation => :update}))
        end
      end
    end


    Irm::Group.class_eval do
      # 更新组
      before_update do
        origin_group = self.class.query(self.id).first
        # 修改了上级组
        unless origin_group.parent_group_id.eql?(self.parent_group_id)
          Delayed::Job.enqueue(Irm::Jobs::SyncDataAccessJob.new({:type => self.class.name, :id => self.id, :operation => :update}))
        end
      end

    end

    Irm::GroupMember.class_eval do
      # 新建组成员
      before_create do
        Delayed::Job.enqueue(Irm::Jobs::SyncDataAccessJob.new({:type => self.class.name, :id => self.id, :person_id => self.person_id, :operation => :create}))
      end
      # 删除组成员
      before_destroy do
        Delayed::Job.enqueue(Irm::Jobs::SyncDataAccessJob.new({:type => self.class.name, :id => self.id, :person_id => self.person_id, :operation => :destroy}))
      end
    end

    Irm::Organization.class_eval do
      # 更新组织
      before_update do
        origin_org = self.class.query(self.id).first
        # 修改了上级组织
        unless origin_org.parent_org_id.eql?(self.parent_org_id)
          Delayed::Job.enqueue(Irm::Jobs::SyncDataAccessJob.new({:type => self.class.name, :id => self.id, :operation => :update}))
        end
      end
    end

    Irm::Role.class_eval do
      # 更新组
      before_update do
        origin_role = self.class.query(self.id).first
        # 修改了上级角色
        unless origin_role.report_to_role_id.eql?(self.report_to_role_id)
          Delayed::Job.enqueue(Irm::Jobs::SyncDataAccessJob.new({:type => self.class.name, :id => self.id, :operation => :update}))
        end
      end
    end


    Irm::BusinessObject.class_eval do
      after_create do
        if self.data_access_flag.eql?(Irm::Constant::SYS_YES)
          Delayed::Job.enqueue(Irm::Jobs::SyncDataAccessJob.new({:type => self.class.name, :id => self.id, :operation => :create}))
        end
      end

      before_update do
        origin_bo = self.class.query(self.id).first
        unless  self.data_access_flag.eql?(origin_bo.data_access_flag)
          Delayed::Job.enqueue(Irm::Jobs::SyncDataAccessJob.new({:type => self.class.name, :id => self.id, :operation => :update}))
        end
      end


      after_destroy do
        if self.data_access_flag.eql?(Irm::Constant::SYS_YES)
          Delayed::Job.enqueue(Irm::Jobs::SyncDataAccessJob.new({:type => self.class.name, :id => self.id, :operation => :destroy}))
        end
      end
    end


    Irm::DataAccess.class_eval do
      after_create do
        Delayed::Job.enqueue(Irm::Jobs::SyncDataAccessJob.new({:type => self.class.name, :id => self.id,:organization_id=>self.organization_id,:business_object_id=>self.business_object_id, :operation => :create}))
      end

      before_update do
        origin_da = self.class.query(self.id).first
        unless self.access_level.eql?(origin_da.access_level)&&self.hierarchy_access_flag.eql?(origin_da.hierarchy_access_flag)
          Delayed::Job.enqueue(Irm::Jobs::SyncDataAccessJob.new({:type => self.class.name, :id => self.id,:organization_id=>self.organization_id,:business_object_id=>self.business_object_id, :operation => :update}))
        end
      end
    end


    Irm::DataShareRule.class_eval do
      after_create do
        Delayed::Job.enqueue(Irm::Jobs::SyncDataAccessJob.new({:type => self.class.name, :id => self.id,:rule=>{:source_type=>self.source_type,:source_id=>self.source_id,:target_type=>self.target_type,:target_id=>self.target_id}, :operation => :create}))
      end

      before_update do
        origin_dsr = self.class.query(self.id).first
        unless self.source_type.eql?(origin_dsr.source_type)&&self.source_id.eql?(origin_dsr.source_id)&&self.target_id.eql?(origin_dsr.target_id)&&self.target_type.eql?(origin_dsr.target_type)
          Delayed::Job.enqueue(Irm::Jobs::SyncDataAccessJob.new({:type => self.class.name, :id => self.id,:origin_rule=>{:source_type=>origin_dsr.source_type,:source_id=>origin_dsr.source_id,:target_type=>origin_dsr.target_type,:target_id=>origin_dsr.target_id},:rule=>{:source_type=>self.source_type,:source_id=>self.source_id,:target_type=>self.target_type,:target_id=>self.target_id}, :operation => :update}))
        end
      end


      after_destroy do
        Delayed::Job.enqueue(Irm::Jobs::SyncDataAccessJob.new({:type => self.class.name, :id => self.id,:origin_rule=>{:source_type=>self.source_type,:source_id=>self.source_id,:target_type=>self.target_type,:target_id=>self.target_id}, :operation => :destroy}))
      end
    end
  end


end

