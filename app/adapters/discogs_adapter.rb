class DiscogsAdapter

    def generate_album_params_from(payload, song)
      {
        "discog_id": payload["id"],
        "title": payload["title"],
        "year": payload["year"],
        "credits_attributes": generate_credits_from(payload)
      }
    end

    def generate_credits_from(payload)
      payload["extraartists"].each_with_object([]) do |credit, memo|
        credit["role"].split(', ').each do |role|
          memo << {
            "role": role,
            "personnel_attributes": {
              "name": credit["name"]
            }
          }
        end
      end
    end

end
