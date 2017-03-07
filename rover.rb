#!/usr/bin/env ruby

class Rover


  # items_file specifies the name of the items file.
  # The items file must contain a function/value called `items`
  # that returns an array that contains hashes. Each hash in that
  # array must contain two keys, `:source` and `:target`, which name
  # the files to link/copy/etc.
  def self.items_file
    File.expand_path("./items.rb")
  end



  def initialize
    items = self.get_items(Rover.items_file)

    if (items.size == 0)
      puts "Nothing to do."
    else
      self.check_items(items)
    end
  end



  # get_items receives the name of the items file and checks if that
  # file exists. If it does, its contents are read and the `items`
  # are returned. Else, an empty array.
  def get_items(items_file = '')
    if File.file?(items_file)
      require(items_file)
      return items
    end

    return [ ]
  end



  # check_items receives an array of items (as read from the items
  # file) and makes sure that the file names in each are readable
  # and writable. And then it acts on each actionable item.
  def check_items(items = [ ])
    items.each do |item|
      if (item.has_key?(:source) && item.has_key?(:target))
        _source = self.check_local_source(item[:source])
        _target = self.check_target(item[:target])

        if (_source.nil? || _target.nil?)
          puts "Couldn't link #{item[:source]} to #{item[:target]}."
        else
          self.link_item(_source, _target)
        end
      else
        puts "Error: an item needs a :source (#{item[:source]}) and a :target (#{item[:target]})."
      end
    end
  end



  # check_local_source receives the name of a local file and returns
  # the absolute pathname of that file if it exists and is readable,
  # else nil.
  def check_local_source(file_name = '')
    full_name = File.expand_path(file_name)

    if (File.exist?(full_name) && File.readable?(full_name))
      return full_name
    else
      return nil
    end
  end



  # check_target receives the name of a local file and returns the
  # absolute pathname of that file if it is writable, else nil.
  def check_target(file_name = '')
    full_name = File.expand_path(file_name)

    if ((File.exist?(full_name) && File.writable?(full_name)) ||
        (File.writable?(File.dirname(full_name))))
      return full_name
    else
      return nil
    end
  end



  # link_item receives the absolute pathnames of both the source and
  # target files. It tries to symlink the target to the source but,
  # if the system doesn't support symlinks, will resort to copying.
  def link_item(source = '', target = '')
    begin
      if (File.exist?(target) && File.symlink?(target))
        puts "A link from #{target} to #{source} already exists."
      else
        puts "Symlinking #{target} to #{source}."
        File.symlink(source, target)
      end

      return File.symlink?(target)

    rescue
      puts "System doesn't support symlinks, will try copying."
      return self.copy_item(source, target)
    end
  end



  # copy_item receives the absolute pathnames of both the source and
  # target files. It copies the source to the target and returns
  # true. That's it.
  def copy_item(source = '', target = '')
    puts "Copying from #{source} to #{target}."

    read = IO.new(source, 'r')
    write = IO.new(target, 'w')

    read.each_line { |line| write.puts(line) }

    read.close
    write.close

    return true
  end


end


Rover.new
