CarrierWave.configure do |config|
  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  else
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['ACCESS_KEY_ID'],
      :aws_secret_access_key  => ENV['SECRET_ACCESS_KEY'],
    }
    config.fog_public     = true
    config.fog_directory  = "coursewareofthefuture_#{Rails.env}"
  end
end
