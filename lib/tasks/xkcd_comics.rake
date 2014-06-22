require 'thread'
require 'xkcd_api'
MAX_THREADS = 12
QUEUE = Queue.new

namespace :comics do
  def get_range(range)
    post_num_list = range.to_a
    comic_list = []

    threads = (1..MAX_THREADS).map do |i|
      Thread.new(QUEUE) do |q|
        until ( q == ( task = q.deq ) )
          # process task

          post_num = post_num_list.pop
          print "#{post_num};"
          comic = Comic.new(XkcdApi.get_number(post_num))
          # begin
          #   comic.set_dimensions
          # rescue

          # end
          comic_list << comic
        end
      end
    end

    # generate tasks
    post_num_list.length.times {|i| QUEUE.enq(i)}
    # send terminators down the queue
    threads.size.times { QUEUE.enq QUEUE }
    # wait for threads to finish
    threads.each {|t| t.join}

    comic_list
  end

  desc "Get's latest comic"
  task :record_latest => :environment do
    c = Comic.new(XkcdApi.latest)
    c.set_dimensions
    puts c.save_by_number
  end

  desc "Records all comics"
  task :record_all => :environment do
    range_to_get = (1..XkcdApi.latest[:number])
    comics = get_range(range_to_get)

    comics.each { |c| c.save_by_number }
    puts "\ntotal:#{comics.length}"
  end

  desc "Download range"
  task :record_range, [:start, :end] => :environment do |t, args|
    comics = get_range(args.start..args.end)
    comics.each { |c| c.save_by_number }
    puts "\ntotal:#{comics.length}"
  end
end
