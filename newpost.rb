#!/usr/bin/ruby
require 'optparse'
require 'yaml'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: newpost.rb [options]"

  opts.on('-d', '--date YYYY-MM-DD', 'Post date in YYYY-MM-DD. Can also handle YYYY and YYYY-MM') { |v| options[:post_date] = v }
  opts.on('-t', '--title "Title"', 'Post Title') { |v| options[:post_title] = v }
  opts.on('-a', '--tags "tag1 tag2"', 'Tags for post - Space delimited') { |v| options[:post_tags] = v.split }	
  opts.on('-c', '--categories "cat1 cat2"', 'Categories for post - Space delimited') { |v| options[:post_categories] = v.split }
  opts.on('-p', '--postcontent "text"', 'Content for post') { |v| options[:post_contents] = v }
  opts.on('-O', '--overwrite', 'Overwrite if post exists?') { |v| options[:file_overwrite] = v }
  opts.on('-h', '--here', 'Writes to the current directory, even if there is a _posts dir available') { |v| options[:file_writehere] = v }
  opts.on('-W', '--openwith "text"', 'If defined, opens the file in the editor specified. eg: -O subl') { |v| options[:file_openwith] = v }

end.parse!

# For debugging, uncomment the next line
# puts options


if /^[[:digit:]][[:digit:]][[:digit:]][[:digit:]]$/.match(options[:post_date])
  puts "Date matches only year. Adding 06-01 as a sane default"
  options[:post_date] = options[:post_date] + "-06-01"
  estimatedDateTag = "DateEstimated_MonthDay"
  #Don't forget the manually added tag: DateEstimated_YearMonthDay for when the date is completely fuzzy

elsif /^[[:digit:]][[:digit:]][[:digit:]][[:digit:]]\-[[:digit:]][[:digit:]]$/.match(options[:post_date])
  puts "Date matches only year and month. Adding day 01"
  options[:post_date] = options[:post_date] + "-01"
  estimatedDateTag = "DateEstimated_Day"
elsif /^[[:digit:]][[:digit:]][[:digit:]][[:digit:]]\-[[:digit:]][[:digit:]]\-[[:digit:]][[:digit:]]$/.match(options[:post_date])
  # puts "Matches year, month, and day"
  estimatedDateTag = nil
else 
  puts Date invalid!
end


postFilename = (options[:post_date] + "-" + (options[:post_title]) + ".md").gsub! /\s+/, '-'

frontmatter = {
  'layout' => 'post',
  'title' => options[:post_title],
  'date' => options[:post_date],
  'tags' => options[:post_tags] << estimatedDateTag,
  'categories' => options[:post_categories]
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


if  File.file?(postFilename) && options[:file_overwrite]
  File.open(postFilename, 'w') { |file|
    file.write(YAML.dump(frontmatter))
    file.write("---")
    file.write("\n")
    file.write("\n")
    file.write(options[:post_contents])
  }
  puts "File overwritten"

elsif File.file?(postFilename)
  puts "File exists, please use a different name. Use -O to overwrite"

else
   File.open(postFilename, 'w') { |file|
    file.write(YAML.dump(frontmatter))
    file.write("---")
    file.write("\n")
    file.write("\n")
    file.write(options[:post_contents])
  }
end


puts Dir.pwd + "/" + postFilename


if options[:file_openwith] && File.file?(postFilename)
  `#{options[:file_openwith]} #{postFilename}`
  puts "-Opening with #{options[:file_openwith]}"
end
