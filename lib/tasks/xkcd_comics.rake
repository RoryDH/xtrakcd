require 'thread'
require 'xkcd_api'
MAX_THREADS = 3
QUEUE = Queue.new

namespace :comics do
  def get_range(range, also_add=[])
    post_num_list = range.to_a
    comic_list = also_add

    threads = (1..MAX_THREADS).map do |i|
      Thread.new(QUEUE) do |q|
        until ( q == ( task = q.deq ) )
          # process task
          post_num = post_num_list.pop
          print "#{post_num};"
          comic_hash = XkcdApi.get_number(post_num)
          comic = Comic.save_by_number(comic_hash)
        end
      end
    end

    # generate tasks
    post_num_list.length.times {|i| QUEUE.enq(i)}
    # send terminators down the queue
    threads.size.times { QUEUE.enq QUEUE }
    # wait for threads to finish
    threads.each {|t| t.join}
  end

  desc "Get's latest comic"
  task :record_latest => :environment do
    c = Comic.new(XkcdApi.latest)
    # c.set_dimensions
    puts c.save_by_number
  end

  desc "Records all comics"
  task :record_all => :environment do
    latest = XkcdApi.latest
    range_to_get = (1..(latest[:number] - 1))
    get_range(range_to_get).push(latest)
    puts "Done"
  end

  desc "Download range"
  task :record_range, [:start, :end] => :environment do |t, args|
    get_range(args.start..args.end)
    puts "Done"
  end
end
