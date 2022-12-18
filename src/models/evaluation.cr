module Model
  class Evaluation < Crecto::Model

      schema "evaluations" do # table name
          field :id, Int32, primary_key: true
          field :evaluation, String
          field :description, String
          field :start_date, String
          field :end_date, String
      end
  
      validate_required [:evaluation]
  end
end