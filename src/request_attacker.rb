require './src/base'
require './src/models/web_page'
require './src/models/result'
class RequestAttacker < Base
  def initialize(urls_file)
    super()
    @urls = File.open(urls_file).readlines(chomp: true)
  end

  def execute
    thread_count = Settings.request_attacker.thread.count.to_i
    url_count_per_thread = @urls.size / thread_count
    url_count_remainder = @urls.size % thread_count
    thread_count +=1 unless url_count_remainder.zero?
    loop_count = thread_count -1

    threads = []
    for i in 0..loop_count
      s = i * url_count_per_thread
      e = s + (i == loop_count ? url_count_remainder : url_count_per_thread) - 1
      #p "#{i}/#{loop_count} : #{s}/#{e}"
      threads.push(Thread.new(@urls[s..e]) { | urls | load(urls) })
    end

    threads.each { | t | t.join }
    result.output
  end

  def load(urls)
    urls.each do | url |
      shot(url)
    end
  end

  def shot(url)
    start_at = Time.now
    page = WebPage.new(url)
    page.get

    end_at = Time.now
    result.append([url, page.code, start_at, end_at, end_at - start_at])
  end

  def result
    @result ||= Result.new('./tmp/results/request_attacker.csv')
  end
end

RequestAttacker.new('./config/urls.txt').execute
