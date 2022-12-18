module Model
  class Question < Crecto::Model

      schema "questions" do # table name
          field :id, Int32, primary_key: true
          field :evaluation_id, Int32
          field :question, String
          field :active, Int32
      end
  
      validate_required [:evaluation_id,:question]
  end
end