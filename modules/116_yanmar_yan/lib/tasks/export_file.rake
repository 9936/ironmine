# encoding: utf-8

require 'fileutils'

namespace :export_file do

 task :export => :environment do
   person = Irm::AttachmentVersion.find_by_sql(
       "SELECT
        iav.*
        FROM
        irm_attachment_versions AS iav
        LEFT JOIN irm_group_members igm ON igm.person_id = iav.created_by
        WHERE igm.group_id = '001400091nvxvi9mGSGGq8'
        AND(
        iav.created_at between '2015-11-00' AND '2016-00-00'
        )")
   person.each do |p|
     FileUtils.cp(p.data.path,'/usr/hisms/file')

   end


 end

end