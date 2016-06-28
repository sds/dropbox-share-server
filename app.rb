require 'dotenv'
require 'fileutils'
require 'open-uri'
require 'sinatra'
require 'zip'

# Load any additional environment variables from file
Dotenv.load('.env')

SHARE_LINK = ENV.fetch('SHARE_LINK') do
  puts "SHARE_LINK environment variable must be defined!"
  exit 1
end
UPDATE_INTERVAL_SECONDS = ENV.fetch('UPDATE_INTERVAL_SECONDS', 30)
NO_ACTIVITY_THRESHOLD_SECONDS = ENV.fetch('NO_ACTIVITY_THRESHOLD_SECONDS', 300)
INDEX_FILE = ENV.fetch('INDEX_FILE', 'index.html')
RACK_ENV = ENV.fetch('RACK_ENV', 'development')
TMP_DIR = Dir.mktmpdir

set :environment, RACK_ENV
set :show_exceptions, RACK_ENV != 'production'
set :bind, ENV.fetch('BIND_ADDRESS', '127.0.0.1')
set :port, ENV.fetch('PORT', 4567)

$file_lock = Mutex.new
$last_request_time = Time.now

# Downloads the zip file containing the contents of the Share folder
def update_local_file_cache
  puts 'Updating local file cache...'
  zip = Zip::File.open(open("#{SHARE_LINK}?dl=1"))

  $file_lock.synchronize do
    FileUtils.rm_rf(Dir.glob(File.join(TMP_DIR, '*')))

    zip.each do |f|
      FileUtils.mkdir_p(File.join(TMP_DIR, File.dirname(f.name)))
      zip.extract(f, File.join(TMP_DIR, f.name))
    end
  end
  $last_update_time = Time.now
end

update_local_file_cache # Initial sync

Thread.new do
  loop do
    begin
      sleep UPDATE_INTERVAL_SECONDS
      unless (Time.now - $last_request_time > NO_ACTIVITY_THRESHOLD_SECONDS) &&
             (Time.now - $last_update_time > UPDATE_INTERVAL_SECONDS)
        update_local_file_cache
      end
    rescue => ex
      puts "Caught exception: #{ex.message}"
      puts ex.backtrace
    end
  end
end

def request_zip_file(path)
  begin
    if Time.now - $last_request_time > NO_ACTIVITY_THRESHOLD_SECONDS
      update_local_file_cache
    end

    $file_lock.synchronize do
      File.read(File.join(TMP_DIR, path))
    end
  rescue Errno::ENOENT
    status 404
    "File #{path} not found!"
  end
end

# Log the time of the last request
after do
  $last_request_time = Time.now
end

get '/' do
  request_zip_file(INDEX_FILE)
end

# Everything else gets redirected to a file in the Zip
get '/*' do
  request_zip_file(params['splat'])
end
