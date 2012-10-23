# coding: UTF-8

# path = File.dirname(__FILE__)
require './common/basic.rb'
project = './project'
# project = ARGV[0] unless ARGV[0].nil?

Dir.new(project).each do |domain|
	next if domain == '.' or domain == '..'
	next if File.exists? File.join(project,domain,'skip') #若包含skip文件,则跳过整个文件夹不处理
	Dir.new(File.join(project,domain)).each do |host|
		next if host == '.' or host == '..'
		next if File.exists? File.join(project,domain,host,'skip') #若包含skip文件,则跳过整个文件夹不处理
		next if !File.exists? File.join(project,domain,host,'regex') #不存在regex文件 跳过
		regex = File.join(project,domain,host,'regex') 
		File.open(regex).each do |line|
			line = line.split(/\s+/)
			meta = {}
			meta[:uri] = line[1]
			next if line[4].nil? || line[6].nil?
			# meta[:content] = $agent.get meta[:uri]
			# meta[:keywords] = Regexp.new line[6]
			meta[:keywords] = line[5]
			meta[:keywords] = line[5] if line[6] == '\identical' #\identical标记表示和举例的一致
			meta[:title] = Regexp.new line[4]
			meta[:title] = line[3] if line[4] == '\identical' #\identical标记表示和举例的一致
			meta[:description] = %r(.)
			describe "#{meta[:uri]}" do
				it_behaves_like "基本页面", meta
			end
		end
	end
end
