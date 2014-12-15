#!/home/ymrl/.rvm/rubies/ruby-1.9.2-p0/bin/ruby
# coding: utf-8
$KCODE = "UTF-8" if RUBY_VERSION < '1.9'

require 'kconv'
require 'time'
require 'net/http'

def remain deadline=Time.local(2015,1,13,14,59,59)
  sec = deadline - Time.now
  return "(締切りまであと#{(sec/(24*60*60)).to_i}日#{((sec%(24*60*60))/(60*60)).to_i}時間#{(((sec%(24*60*60))%(60*60))/60).to_i}分)"
end

username = ENV['USER']
no_message = false
no_limit = false
no_tags = false
saykana = false
debug = false
slash = false

ARGV.each do |arg|
  if arg =~ /--dir=(.*)/
    Dir.chdir(File.expand_path($1))
  elsif arg =~ /--username=(.*)/
    if $1.length == 0
      username = nil
    else
      username=$1
    end
  elsif arg == "--no-message"
    no_message = true
  elsif arg == "--no-limit"
    no_limit = true
  elsif arg == "--no-tags"
    no_tags = true
  elsif arg == "--no-user"
    username = nil
  elsif arg == "--debug"
    debug = true
  elsif arg == "--saykana"
    saykana = true
  elsif arg == "--kensaku-yoke"
    slash = true
  end
end


c = 0
Dir::glob("./markdown/*").each do |f|
  if f =~/^.*\.md$/
    File.open(f,'r') do |t|
      while l = t.gets
        m = Kconv.kconv(l,Kconv::UTF8)
        next if m =~ /^%/
        m.gsub!(/^\s*\\begin\{.*\}$/,'')
        m.gsub!(/^\s*\\end\{.*\}$/,'')
        m.gsub!(/^\s*\\label\{.*\}$/,'')
        m.gsub!(/^\s*\\usepackage\{.*\}$/,'')
        m.gsub!(/^\s*\\includegraphics(?:\[.*\])*\{.*\}$/,'')
        m.gsub!(/^\s*\\item\[(.*)\]\s?(.*)$/){$1+' '+$2}
        m.gsub!(/^\s*\\item\s(.*)$/){$1}
        m.gsub!(/^\s*\\[a-z\*]+\[(.*)\]$/){$1}
        m.gsub!(/^\s*\\[a-z\*]+(?:(?:\[.*\])|(?:\{.*\}))*\{(.*)\}$/){$1}
        m.gsub!(/\\~\{\}/,'~')
        m.gsub!(/\\slash\s?/,'/')
        m.gsub!(/\\\\/,'\\')
        m.gsub!(/\\([\#$%$&^_{}])/){$1}
        m.gsub!(/\\[a-z]+(?:\{[^}]*\})+?/,'')
        m.gsub!(/\\[a-z]+\s+/,'')
        m.gsub!(/[\t\r\n]/,'')
        puts m if debug
        # puts m
        c += m.split(//).length
      end
    end
  end
end

if no_message
  puts c
else
  message_core = "現在の"
  message_core += username+"さんの" if username
  message_core += "修論の文字数は約#{c}文字です."
  message_core += "あなたのプルリクエストをお待ちしております. http://github.com/TakumiBaba/master-thesis"
  message = message_core + " #{remain}" unless no_limit
  message += " #sfcdogeza #sfchametsu" unless no_tags
  if slash
    message = message.split(//).join('/')
  end
  puts message
  if saykana
    Net::HTTP.start('masui.sfc.keio.ac.jp',80) do |http|
      request = Net::HTTP::Post.new('/say/say')
      request.set_form_data :message=>message_core
      http.request(request)
    end
  end
end
