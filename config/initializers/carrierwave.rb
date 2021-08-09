CarrierWave.configure do |config|
  if Rails.env.production?
    config.fog_provider = 'fog'
    config.fog_credentials = {
      provider:           'Rackspace',
      rackspace_username: ENV['RACKSPACE_USERNAME'],
      rackspace_api_key:  ENV['RACKSPACE_API'],
      rackspace_region:   :iad,
    }
    config.fog_directory = ENV['RACKSPACE_FOG_DIRECTORY']
    config.asset_host = ENV['RACKSPACE_ASSET_HOST']
  else Rails.env.test?
    config.storage = :file
    config.cache_dir = Rails.root.join('tmp/uploads')
    config.enable_processing = false
  end
end
