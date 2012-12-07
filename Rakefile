task default: :spec

desc 'Run the specs'
task :spec do
  sh 'rspec --format documentation --colour'
end

namespace :spec do
  desc 'Run the specs iteratively'
  task :fail_fast do
    sh 'rspec --format documentation --colour --fail-fast'
  end
end
