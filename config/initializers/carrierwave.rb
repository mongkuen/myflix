CarrierWave.configure do |config|
  config.aws_credentials = {
    access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region:            ENV['AWS_REGION']
  }
  config.aws_bucket = ENV['S3_BUCKET_NAME']
  config.aws_acl    = 'public-read'

  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
    config.store_dir = "#{Rails.root}/spec/cache"
    config.cache_dir = "#{Rails.root}/spec/cache"
  elsif Rails.env.development?
    config.storage = :file
    config.store_dir = "#{Rails.root}/public/uploads/tmp"
    config.cache_dir = "#{Rails.root}/public/uploads/cache"
  else
    config.storage = :aws
    config.store_dir = 'large_covers'
    config.cache_dir = "#{Rails.root}/tmp"
  end
end
