get "/evaluations" do |env|
  if Controller::Application.user_logged(env)
    is_admin = env.session.bool("is_admin")
    if is_admin
      evaluations = Controller::Evaluations.all()
      render "src/views/evaluations/index.ecr"
    else
      env.redirect "/"
    end
  else
    env.redirect "/login"
  end
end

get "/evaluations/new" do |env|
  if Controller::Application.user_logged(env)
    is_admin = env.session.bool("is_admin")
    if is_admin
      render "src/views/evaluations/new.ecr"
    else
      env.redirect "/"
    end
  else
    env.redirect "/login"
  end
end

post "/evaluations/new" do |env|
  if Controller::Application.user_logged(env)
    is_admin = env.session.bool("is_admin")
    if is_admin
      Controller::Evaluations.create(env)
    else
      {status: "ERROR", message: "Not allowed to use this resource"}.to_json
    end
  else
    {status: "ERROR", message: "Session expired, need to log in"}.to_json
  end
end

get "/evaluations/update/:id" do |env|
  if Controller::Application.user_logged(env)
      id         = env.params.url["id"]
      evaluation = Controller::Evaluations.get_by_id(id)
      render "src/views/evaluations/update.ecr"
  else
      env.redirect "/login"
  end
end

post "/evaluations/update" do |env|
  if Controller::Application.user_logged(env)
    is_admin = env.session.bool("is_admin")
    if is_admin
      Controller::Evaluations.update(env)
    else
      {status: "ERROR", message: "Not allowed to use this resource"}.to_json
    end
  else
    {status: "ERROR", message: "Session expired, need to log in"}.to_json
  end
end