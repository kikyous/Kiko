# = Usage
# Download to your jekyll site directory, and run it
# `ruby jekyll_image_fetcher.rb`

dir = 'assets'
Dir['_posts/*.md'].each do |path|
  content = File.open(path).read
  basename = File.basename path, '.*'

  content.gsub!(/!\[\]\((.+)\)/) do |m|
    url = $1
    `mkdir -p #{dir}/posts/#{basename}`
    if $1.start_with? 'http'
      `wget #{url} -P #{dir}/posts/#{basename}`
    else
      `mv #{url.sub(/^\//, '')} #{dir}/posts/#{basename}`
    end
    m.gsub url, "/#{dir}/posts/#{basename}/#{File.basename url}"
  end

  File.open(path, 'w') do |file|
    file.write content
  end
end
