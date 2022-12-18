module Controller
  module Evaluations
    extend self

    Query = Crecto::Repo::Query

    def all()
        Model::ConnDB.all(Model::Evaluation)
    end

    def get_by_id(id : String)
      Model::ConnDB.all(Model::Evaluation, Query.where(id: id))
    end

    def create(env)
      evaluation  = env.params.json["evaluation"].as(String)
      description = env.params.json["description"].as(String)
      start_date  = env.params.json["start_date"].as(String)
      end_date    = env.params.json["end_date"].as(String)
      
      table_record = Model::Evaluation.new
      table_record.evaluation  = evaluation
      table_record.description = description
      table_record.start_date  = start_date
      table_record.end_date    = end_date
      changeset = Model::ConnDB.insert(table_record)

      table_record_id = changeset.instance.id

      {status: "OK",id: table_record_id, message: "Evaluation : #{table_record_id} was created."}.to_json
    end

    def update(env)
      id          = env.params.json["id"].as(String)
      evaluation  = env.params.json["evaluation"].as(String)
      description = env.params.json["description"].as(String)
      start_date  = env.params.json["start_date"].as(String)
      end_date    = env.params.json["end_date"].as(String)

      table_record = Model::ConnDB.get!(Model::Evaluation, id)
      table_record.evaluation  = evaluation
      table_record.description = description
      table_record.start_date  = start_date
      table_record.end_date    = end_date
      changeset = Model::ConnDB.update(table_record)

      {status: "OK",id: id, message: "Evaluation : #{id} was updated."}.to_json
    end

  end
end