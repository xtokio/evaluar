module Model
  class Option < Crecto::Model

      schema "options" do # table name
          field :id, Int32, primary_key: true
          field :question_id, Int32
          field :type, String
          field :label, String
          field :value, String
      end
  
      validate_required [:question_id,:type]
  end
end