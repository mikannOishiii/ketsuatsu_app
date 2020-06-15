if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Amazon S3用の設定
      :provider              => 'AWS',
      :region                => Rails.application.credentials.dig(:aws, :S3_REGION),
      :aws_access_key_id     => Rails.application.credentials.dig(:aws, :S3_ACCESS_KEY),
      :aws_secret_access_key => Rails.application.credentials.dig(:aws, :S3_SECRET_KEY)
    }
    config.fog_directory     =  Rails.application.credentials.dig(:aws, :S3_BUCKET)
  end
end