module Controller
  module Questions
    extend self

    Query = Crecto::Repo::Query

    def all()
        Model::ConnDB.all(Model::Question)
    end

    def get_by_id(id : String)
      Model::ConnDB.all(Model::Question, Query.where(id: id))
    end

    def get_by_evaluation_id(evaluation_id : String)
      Model::ConnDB.all(Model::Question, Query.where(evaluation_id: evaluation_id))
    end

    def create(env)
      evaluation_id = env.params.json["evaluation_id"].as(String)
      question      = env.params.json["question"].as(String)
      active        = env.params.json["active"].as(String)
      
      table_record = Model::Question.new
      table_record.evaluation_id = evaluation_id.to_i
      table_record.question      = question
      table_record.active        = active.to_i
      changeset = Model::ConnDB.insert(table_record)

      table_record_id = changeset.instance.id

      {status: "OK",id: table_record_id, message: "Question : #{table_record_id} was created."}.to_json
    end

    def update(env)
      id       = env.params.json["id"].as(String)
      question = env.params.json["question"].as(String)
      active   = env.params.json["active"].as(String)

      table_record = Model::ConnDB.get!(Model::Question, id)
      table_record.question      = question
      table_record.active        = active.to_i
      changeset = Model::ConnDB.update(table_record)

      {status: "OK",id: id, message: "Question : #{id} was updated."}.to_json
    end

  end
end