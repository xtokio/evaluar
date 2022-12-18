module Controller
  module Options
    extend self

    Query = Crecto::Repo::Query

    def all()
        Model::ConnDB.all(Model::Option)
    end

    def get_by_id(id : String)
      Model::ConnDB.all(Model::Option, Query.where(id: id))
    end

    def get_by_question_id(question_id : String)
      Model::ConnDB.all(Model::Option, Query.where(question_id: question_id))
    end

    def create(env)
      question_id = env.params.json["question_id"].as(String)
      type        = env.params.json["type"].as(String)
      label       = env.params.json["label"].as(String)
      value       = env.params.json["value"].as(String)
      
      table_record = Model::Option.new
      table_record.question_id = question_id.to_i
      table_record.type        = type
      table_record.label       = label
      table_record.value       = value
      changeset = Model::ConnDB.insert(table_record)

      table_record_id = changeset.instance.id

      {status: "OK",id: table_record_id, message: "Option : #{table_record_id} was created."}.to_json
    end

    def update(env)
      id    = env.params.json["id"].as(String)
      type  = env.params.json["type"].as(String)
      label = env.params.json["label"].as(String)
      value = env.params.json["value"].as(String)

      table_record = Model::ConnDB.get!(Model::Option, id)
      table_record.type        = type
      table_record.label       = label
      table_record.value       = value
      changeset = Model::ConnDB.update(table_record)

      {status: "OK",id: id, message: "Option : #{id} was updated."}.to_json
    end

  end
end