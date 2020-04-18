MENU = YAML.load(File.read(Rails.root.join("config", "coronavirus", "data.yml").to_path)).with_indifferent_access
