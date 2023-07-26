VERSION = 1

require "io/console"

puts "== STORYTIME =="
puts "Select a story"
STORIESLOCATION = File.dirname(__FILE__) +"/stories/"
storiesList = []
Dir[STORIESLOCATION+"*"].each do |f|
  storiesList.append(f)
  puts "#{storiesList.length - 1 >= 10 ? storiesList.length - 1 : " "+(storiesList.length - 1).to_s}[  #{File.basename(f)}"
end
while true
  inp = gets.to_i
  if inp >= storiesList.length || inp < 0
    puts("Index out of list.")
  else
    to_open = storiesList[inp.to_i]
    break
  end
end
file = File.open(to_open)
file_content = file.readlines.map(&:chomp)
file.close

elseActivation = 0
echoAll = false
line_num = 0
block_level = 0
vars = {}
labels = {}

def skip_block(line_num,file_content,cond_level)
  cbl = cond_level
  cln = line_num
  while true
    cln += 1
    line = file_content[cln].gsub(/[ \t](?<!\S.)/,"")
    case line[0]
    when "{" # Block in
      cbl += 1
    when "}" # Block out
      cbl -= 1
    end
    cond_level == cbl ? break : nil
  end
  cln
end

def sp_var(name)
  case name
  when "unix"
    Time.now.to_i
  when "year"
    Time.now.year
  when "month"
    Time.now.month
  when "day"
    Time.now.day
  when "hour"
    Time.now.hour
  when "version"
    VERSION
  when "random"
    rand(65536)
  end
end

def numify(val)
  val == "0" || val.to_i != 0 ? val.to_i : val
end

while true
  registered = ""
  line = file_content[line_num].gsub(/[ \t](?<!\S.)/,"")
  echoAll ? puts("[ln #{line_num}]#{line}") : nil
  case line[0]
  when ">" # Output
    to_out = line[1..-1]
    line[1..-1].scan(/(\${(.*?)})/).each do |match|
      subvar = match[1][0] == "#" ? left = sp_var(match[1][1..-1]) : vars[match[1]]
      s = to_out.index(match[0]) - 1
      e = s + match[0].length + 1
      to_out = to_out[0..s]+subvar.to_s+to_out[e..-1]
    end
    puts to_out
  when "<" # Input
    vars[line[1..-1]] = numify(gets)
  when "@" # Label
    labels[line[1..-1]] = line_num
  when "^" # Goto Label
    line_num = labels[line[1..-1]]
  when "?" # Conditional
    params = line.split
    params[0] = params[0][1..-1]
    cond = true
    case params[1]
    when "="
      cond = vars[params[0]] == numify(params[2])
    when "!"
      cond = vars[params[0]] != numify(params[2])
    when ">"
      cond = vars[params[0]] > numify(params[2])
    when "<"
      cond = vars[params[0]] < numify(params[2])
    when ">="
      cond = vars[params[0]] >= numify(params[2])
    when "<="
      cond = vars[params[0]] <= numify(arams[2])
    end
    if elseActivation != 1
      elseActivation = cond ? 1 : 2
    end
    unless cond
      line_num = skip_block(line_num,file_content,block_level)
    end
  when "!" # Else
    unless elseActivation == 1
      line_num = skip_block(line_num,file_content,block_level)
    end
    elseActivation = 0
  when "{" # Block in
    block_level += 1
  when "}" # Block out
    block_level -= 1
  when "_" # Underscore functions
    case line[1..-1]
    when "echo"
      echoAll = true
    when "cls"
      system "cls"
    when "pause"
      STDIN.getch
    when "end"
      break
    when "randomnew"
      Random.new_seed
    end
  when "$" # Variable manager
    params = line.split(" ",2)
    params[0] = params[0][1..-1]
    left = 0
    token = ""
    right = 0
    params[1].scan(/([^\w\s#"]*)([\w\s#"]*)/).each do |match|
      if match[0] != ""
        token = match[0]
        if match[1][0] == '"' && match[1][-1] == '"'
          right = match[1][1..-2]
        else
          right = vars[match[1]].nil? ? numify(match[1]) : vars[match[1]]
        end
        left = numify(left)
        case match[0]
        when "+"
          to_add = numify(right)
          left.is_a?(String) ? to_add = to_add.to_s : to_add = to_add.to_i
          left += to_add
        when "-"
          left -= right.to_i
        when "*"
          left *= right.to_i
        when "/"
          left /= right.to_i
        when "%"
          left %= right.to_i
        when "^"
          left **= right.to_i
        end
      else
        if match[1][0] == "#"
          left = sp_var(match[1][1..-1])
        elsif match[1][0] == '"' && match[1][-1] == '"'
          left = match[1][1..-2]
        else
          left = vars[match[1]].nil? ? match[1] != "" ? numify(match[1]) : left : numify(vars[match[1]])
        end
      end
    end
    vars[params[0]] = left
  end
  line_num += 1
  line_num >= file_content.length ? break : nil
  cond = true
end
puts "== THE END =="
