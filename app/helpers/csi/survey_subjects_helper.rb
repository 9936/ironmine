module Csi::SurveySubjectsHelper
  def survey_subject_type
    Csi::SurveySubject::TYPES.map{|h| [t("label_csi_survey_subject_type_#{h[0]}"), h[1]]}
  end

  def paginate_survey_subjects(survey_id)

    current_page = 1

    subject_pages = [[]]

    subjects =  Csi::SurveySubject.where(:survey_id=>survey_id)

    subjects.each_with_index do |subject,index|
      if subject.input_type.eql?("page")
        subject_pages << []
        current_page = current_page+1
        next
      else
        subject.page = current_page
        subject.number = index+1-current_page+1
        subject_pages[current_page-1]<<subject
      end
    end

    subject_pages
  end
end
