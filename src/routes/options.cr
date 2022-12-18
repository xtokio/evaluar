get "/question/options/:question_id" do |env|
  if Controller::Application.user_logged(env)
    is_admin = env.session.bool("is_admin")
    if is_admin
      question_id = env.params.url["question_id"]
      questions   = Controller::Questions.get_by_id(question_id)
      options     = Controller::Options.get_by_question_id(question_id)
      render "src/views/options/index.ecr"
    else
      env.redirect "/"
    end
  else
    env.redirect "/login"
  end
end

get "/question/options/new/:question_id" do |env|
  if Controller::Application.user_logged(env)
    is_admin = env.session.bool("is_admin")
    if is_admin
      question_id = env.params.url["question_id"]
      questions   = Controller::Questions.get_by_id(question_id)
      render "src/views/options/new.ecr"
    else
      env.redirect "/"
    end
  else
    env.redirect "/login"
  end
end

post "/question/options/new/:question_id" do |env|
  if Controller::Application.user_logged(env)
    is_admin = env.session.bool("is_admin")
    if is_admin
      question_id = env.params.url["question_id"]
      Controller::Options.create(env)
    else
      {status: "ERROR", message: "Not allowed to use this resource"}.to_json
    end
  else
    {status: "ERROR", message: "Session expired, need to log in"}.to_json
  end
end

get "/question/options/update/:option_id" do |env|
  if Controller::Application.user_logged(env)
    option_id = env.params.url["option_id"]
    option    = Controller::Options.get_by_id(option_id)
    questions = Controller::Questions.get_by_id(option[0].question_id.to_s)
    render "src/views/options/update.ecr"
  else
      env.redirect "/login"
  end
end

post "/question/options/update" do |env|
  if Controller::Application.user_logged(env)
    is_admin = env.session.bool("is_admin")
    if is_admin
      Controller::Options.update(env)
    else
      {status: "ERROR", message: "Not allowed to use this resource"}.to_json
    end
  else
    {status: "ERROR", message: "Session expired, need to log in"}.to_json
  end
end