# jekyllnewpost.rb
A quick and dirty script for creating a new Jekyll post in the current directory.

Outputs to _posts if run from the root folder.

    Usage: example.rb [options]
      -d, --date YYYY-MM-DD            Post date in YYYY-MM-DD. Can also handle YYYY and YYYY-MM
      -t, --title "Title"              Post Title
      -a, --tags "tag1 tag2"           Tags for post - Space delimited
      -c, --categories "cat1 cat2"     Categories for post - Space delimited
      -p, --postcontent "text"         Content for post
      -O, --Overwrite                  Overwrite if post exists
      -h, --here                       Writes to the current directory, even if there is a _posts dir available
      -W, --openwith "text"            If defined, opens the file the editor specified. eg: -O subl
