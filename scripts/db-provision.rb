require 'yaml'
data = YAML.load_file "../farmbot-web-app/config/database.yml"
    data["development"]["database"] = "farmbot_api_dev"
    data["development"]["password"] = "password"
    File.open("../farmbot-web-app/config/database.yml", 'w') { |f| YAML.dump(data, f) }
