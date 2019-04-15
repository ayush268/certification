module UsersHelper

  def get_token
    tokens = ["18f9090ae22541768e5311cfa19fe96c", "403f37d1cfd74ce9ad6622e9f0a8207f"]
    num = Random.rand(tokens.size)
    tokens[num]
  end

end
