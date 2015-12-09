$base_dir = File.dirname(__FILE__)
$src_dir = File.join($base_dir, 'build')
$dst_dir = "#{$base_dir}.gh-pages"

task default: [:build]

desc 'Build and copy to gh-pages'
task :build do
  sh "bundle exec middleman build"

  puts $src_dir, $dst_dir
  sh "cp -r #{$src_dir}/* #{$dst_dir}"

  Dir.chdir $dst_dir do
    sh "git add ."
    sh "git commit -m 'updated.'"
  end
end
