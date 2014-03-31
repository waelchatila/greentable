# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :test, :drb => false, :all_on_start => true do
  watch(%r{^lib/greentable/(.+)\.rb$})     { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^test/.+_test\.rb$})
end


