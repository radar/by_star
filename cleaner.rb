files = Dir["**/*"]
ignored_files = [
  /log\/.*/,
]

files.delete_if do |file|
  if File.directory?(file)
    true
  else
    ignored_files.any? do |condition|
      if condition.is_a?(String)
        file == condition
      else
        condition.match(file)
      end
    end || false
  end
end

for file in files - ignored_files
  if File.file?(file)
    lines = File.readlines(file).map { |line| line.gsub(/^\s+$/, "\n") }
    File.open(file, "w+") { |f| f.write(lines.join) }
  end
end