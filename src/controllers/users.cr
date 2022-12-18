module Controller
    module Users
        extend self

        Query = Crecto::Repo::Query

        def all()
            Model::ConnDB.all(Model::User)
        end

        def login(env)
            user = env.params.json["user"].as(String)
            password = env.params.json["password"].as(String)

            env.session.bool("is_admin", false)

            records = Model::ConnDB.all(Model::User, Query.where(user: user, password: password))

            if records.size > 0
                records.each do |record|
                    env.session.int("login", record.id.to_s.to_i)
                    env.session.string("user_id", record.id.to_s)
                    env.session.string("user_name", record.name.to_s)
                    env.session.string("user_email", record.email.to_s)
                    env.session.string("user_type", record.type.to_s)

                    if record.type.to_s == "Administrator"
                        env.session.bool("is_admin", true)
                    end
                end
            end
        end

        def assume_id(env, user : String)
            env.session.bool("is_admin", false)

            records = Model::ConnDB.all(Model::User, Query.where(user: user))

            if records.size > 0
                records.each do |record|
                    env.session.int("login", record.id.to_s.to_i)
                    env.session.string("user_id", record.id.to_s)
                    env.session.string("user_name", record.name.to_s)
                    env.session.string("user_email", record.photo.to_s)
                    if record.type.to_s == "Administrator"
                        env.session.bool("is_admin", true)
                    end
                end
                env.redirect "/"
            end
        end

        def get_by_id(id : String)
            Model::ConnDB.all(Model::User, Query.where(id: id))
        end

        def get_by_assigned_to(users : String)
            Model::ConnDB.all(Model::User, Query.where("id in (#{users})"))
        end

        def create(env)
            user      = env.params.json["user"].as(String)
            password  = env.params.json["password"].as(String)
            name      = env.params.json["name"].as(String)
            email     = env.params.json["email"].as(String)
            type      = env.params.json["type"].as(String)
            
            user_record = Model::User.new
            user_record.user      = user
            user_record.password  = password
            user_record.name      = name
            user_record.email     = email
            user_record.type      = type
            user_record.active    = 1
            changeset = Model::ConnDB.insert(user_record)

            user_id = changeset.instance.id

            {status: "OK",id: user_id, message: "User : #{user_id} was created."}.to_json
        end

        def update(env)
            id        = env.params.json["id"].as(String)
            user      = env.params.json["user"].as(String)
            password  = env.params.json["password"].as(String)
            name      = env.params.json["name"].as(String)
            email     = env.params.json["email"].as(String)
            type      = env.params.json["type"].as(String)
            active    = env.params.json["active"].as(String)

            user_record = Model::ConnDB.get!(Model::User, id)
            user_record.user      = user
            user_record.password  = password
            user_record.name      = name
            user_record.email     = email
            user_record.type      = type
            user_record.active    = active.to_i
            changeset = Model::ConnDB.update(user_record)

            {status: "OK",id: id, message: "User : #{id} was updated."}.to_json
        end

        def activate(id : String)
            user_record = Model::ConnDB.get!(Model::User, id)
            user_record.active = 1
            changeset = Model::ConnDB.update(user_record)

            {status: "OK",id: id, message: "User is now Active."}.to_json
        end

        def deactivate(id : String)
            user_record = Model::ConnDB.get!(Model::User, id)
            user_record.active = 0
            changeset = Model::ConnDB.update(user_record)

            {status: "OK",id: id, message: "User is now Inactive."}.to_json
        end
    end
end