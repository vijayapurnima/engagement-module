json.extract! edo, :id, :name, :expansion

  if edo[:logo_id]
    json.logo_id edo[:logo_id]
    json.logo edo[:logo]
  end