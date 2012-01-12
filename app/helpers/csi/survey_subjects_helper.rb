module Csi::SurveySubjectsHelper
  def survey_subject_type
    Csi::SurveySubject::TYPES.map{|h| [t("label_csi_survey_subject_type_#{h[0]}"), h[1]]}
  end
end
