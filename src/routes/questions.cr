get "/evaluation/questions/:evaluation_id" do |env|
  if Controller::Application.user_logged(env)
    is_admin = env.session.bool("is_admin")
    if is_admin
      evaluation_id = env.params.url["evaluation_id"]
      questions     = Controller::Questions.get_by_evaluation_id(evaluation_id)
      render "src/views/questions/index.ecr"
    else
      env.redirect "/"
    end
  else
    env.redirect "/login"
  end
end

get "/evaluation/questions/new/:evaluation_id" do |env|
  if Controller::Application.user_logged(env)
    is_admin = env.session.bool("is_admin")
    if is_admin
      evaluation_id = env.params.url["evaluation_id"]
      render "src/views/questions/new.ecr"
    else
      env.redirect "/"
    end
  else
    env.redirect "/login"
  end
end

post "/evaluation/questions/new/:evaluation_id" do |env|
  if Controller::Application.user_logged(env)
    is_admin = env.session.bool("is_admin")
    if is_admin
      evaluation_id = env.params.url["evaluation_id"]
      Controller::Questions.create(env)
    else
      {status: "ERROR", message: "Not allowed to use this resource"}.to_json
    end
  else
    {status: "ERROR", message: "Session expired, need to log in"}.to_json
  end
end

get "/evaluation/questions/update/:question_id" do |env|
  if Controller::Application.user_logged(env)
    question_id   = env.params.url["question_id"]
    question = Controller::Questions.get_by_id(question_id)
    render "src/views/questions/update.ecr"
  else
      env.redirect "/login"
  end
end

post "/evaluation/questions/update" do |env|
  if Controller::Application.user_logged(env)
    is_admin = env.session.bool("is_admin")
    if is_admin
      Controller::Questions.update(env)
    else
      {status: "ERROR", message: "Not allowed to use this resource"}.to_json
    end
  else
    {status: "ERROR", message: "Session expired, need to log in"}.to_json
  end
end