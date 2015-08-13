#!/usr/bin/ruby
require 'optparse'
require 'yaml'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on('-d', '--date YYYY-MM-DD', 'Post date in YYYY-MM-DD') { |v| options[:post_date] = v }
  opts.on('-t', '--title "Title"', 'Post Title') { |v| options[:post_title] = v }

end.parse!

# For debugging, uncomment the next line
# puts options

postFilename = (options[:post_date] + "-" + (options[:post_title]) + ".md").gsub! /\s+/, '-'

frontmatter = {
  'layout' => 'post',
  'title' => options[:post_title],
  'date' => options[:post_date],
}

# ---
# layout:     post
# title:      Post title
# date:       2016-06-10 12:31:19
# summary:    Post summary
# categories: Category1 Category2
# sequence:   3
# ---


if Dir.pwd.end_with? "_posts" or options[:file_writehere]
  isInPostsDir = true
else
  isInPostsDir = false
  postFilename.prepend("_posts/")
end

File.open(postFilename, 'w') { |file|
    file.write(YAML.dump(frontmatter))
    file.write("---")
    file.write("\n")
    file.write("\n")
    file.write(options[:post_contents])
  }

puts Dir.pwd + "/" + postFilename