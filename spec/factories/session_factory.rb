FactoryGirl.define do
  factory :session, class: SkoogleDocs::Session do
    # Valid session definition
    initialize_with do
      VCR.use_cassette("valid_session") do
        new(build(:client))
      end
    end

    # Session in unauthorized (credentials are invalid).
    factory :invalid_session do
      initialize_with do
        VCR.use_cassette("invalid_session") do
          new(build(:invalid_client))
        end
      end
    end

    # Session has no credentials to authenticate.
    factory :blank_session do
      initialize_with do
        new(build(:blank_client))
      end
    end
  end
end