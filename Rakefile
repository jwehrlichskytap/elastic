require 'pathname'

subprojects = %w| elastic elastic-transport elastic-api elastic-extensions |
__current__ = Pathname( File.expand_path('..', __FILE__) )

# TODO: Figure out "bundle exec or not"
# subprojects.each { |project| $LOAD_PATH.unshift __current__.join(project, "lib").to_s }

task :default do
  system "rake --tasks"
end

desc "Display information about subprojects"
task :subprojects do
  puts '-'*80
  subprojects.each do |project|
    commit  = `git log --pretty=format:'%h %ar: %s' -1 #{project}`
    version =  Gem::Specification::load(__current__.join(project, "#{project}.gemspec").to_s).version.to_s
    puts "#{version}".ljust(10) +
         "| \e[1m#{project.ljust(subprojects.map {|s| s.length}.max)}\e[0m | #{commit[ 0..80]}..."
  end
end

desc "Setup the project"
task :setup do
  unless File.exist?('./tmp/elastic')
    sh "git clone git@github.com:elastic/elasticsearch.git tmp/elastic"
  end
end

desc "Alias for `bundle:install`"
task :bundle => 'bundle:install'

namespace :bundle do
  desc "Run `bundle install` in all subprojects"
  task :install do
    puts '-'*80
    sh "bundle install --gemfile #{__current__}/Gemfile"
    puts
    subprojects.each do |project|
      puts '-'*80
      puts "bundle install --gemfile #{__current__.join(project)}/Gemfile"
      sh "bundle install --gemfile #{__current__.join(project)}/Gemfile"
      puts
    end
  end

  desc "Remove Gemfile.lock in all subprojects"
  task :clean do
    sh "rm -f Gemfile.lock"
    subprojects.each do |project|
      sh "rm -f #{__current__.join(project)}/Gemfile.lock"
    end
  end
end

namespace :elastic do
  desc "Update the submodule with Elastic core repository"
  task :update do
    sh "git --git-dir=#{__current__.join('tmp/elastic/.git')} --work-tree=#{__current__.join('tmp/elastic')} fetch origin --verbose"
    begin
      puts %x[git --git-dir=#{__current__.join('tmp/elastic/.git')} --work-tree=#{__current__.join('tmp/elastic')} pull --verbose]
    rescue Exception => @exception
      @failed = true
    end

    if @failed || !$?.success?
      STDERR.puts "", "[!] Error while pulling -- #{@exception}"
    end

    puts "\n", "CHANGES:", '-'*80
    sh "git --git-dir=#{__current__.join('tmp/elastic/.git')} --work-tree=#{__current__.join('tmp/elastic')} log --oneline ORIG_HEAD..HEAD | cat", :verbose => false
  end

  task :gembuild do
    subprojects.each do |project|
      cmd = "cd #{__current__.join(project)} && gem build #{project}.gemspec"
      puts cmd
      sh(cmd)
      puts
    end
  end

  desc <<-DESC
    Build Elastic for the specified branch ('origin/master' by default)"

    Build a specific branch:

        $ rake elastic:build[origin/1.x]

    The task will execute `git fetch` to synchronize remote branches.
  DESC
  task :build, :branch do |task, args|
    Rake::Task['elastic:status'].invoke
    puts '-'*80

    gitref = args[:branch] || 'origin/master'
    es_version = gitref.gsub(/^v|origin\/(\d\.+)/, '\1').to_f

    current_branch = `git --git-dir=#{__current__.join('tmp/elastic/.git')} --work-tree=#{__current__.join('tmp/elastic')} branch --no-color`.split("\n").select { |b| b =~ /^\*/ }.first.gsub(/^\*\s*/, '')

    STDOUT.puts "Building version [#{es_version}] from [#{gitref}]:", ""

    case es_version
      when 0.0, 5..1000
        path_to_build   = __current__.join('tmp/elastic/distribution/tar/build/distributions/elastic-*.tar.gz')
        build_command   = "cd #{__current__.join('tmp/elastic/distribution/tar')} && gradle clean assemble;"
        extract_command = <<-CODE.gsub(/          /, '')
          build=`ls #{path_to_build} | xargs -0 basename | sed s/\.tar\.gz//`
          if [[ $build ]]; then
            rm -rf "#{__current__.join('tmp/builds')}/$build";
          else
            echo "Cannot determine build, exiting..."
            exit 1
          fi
          tar xvf #{path_to_build} -C #{__current__.join('tmp/builds')};
        CODE
      when 1.8..4
        path_to_build   = __current__.join('tmp/elastic/distribution/tar/target/releases/elastic-*.tar.gz')
        build_command = "cd #{__current__.join('tmp/elastic')} && MAVEN_OPTS=-Xmx1g mvn --projects core,distribution/tar clean package -DskipTests -Dskip.integ.tests;"
        extract_command = <<-CODE.gsub(/          /, '')
          build=`ls #{path_to_build} | xargs -0 basename | sed s/\.tar\.gz//`
          if [[ $build ]]; then
            rm -rf "#{__current__.join('tmp/builds')}/$build";
          else
            echo "Cannot determine build, exiting..."
            exit 1
          fi
          tar xvf #{path_to_build} -C #{__current__.join('tmp/builds')};
        CODE
      when 0.1..1.7
        path_to_build   = __current__.join('tmp/elastic/target/releases/elastic-*.tar.gz')
        build_command = "cd #{__current__.join('tmp/elastic')} && MAVEN_OPTS=-Xmx1g mvn clean package -DskipTests"
        extract_command = <<-CODE.gsub(/          /, '')
          build=`ls #{path_to_build} | xargs -0 basename | sed s/\.tar\.gz//`
          if [[ $build ]]; then
            rm -rf "#{__current__.join('tmp/builds')}/$build";
          else
            echo "Cannot determine build, exiting..."
            exit 1
          fi
          tar xvf #{path_to_build} -C #{__current__.join('tmp/builds')};
        CODE
      else
        STDERR.puts "", "[!] Cannot determine a compatible version of the build (gitref: #{gitref}, es_version: #{es_version})"
        exit(1)
    end

    sh <<-CODE.gsub(/      /, '')
      mkdir -p #{__current__.join('tmp/builds')};
      rm -rf '#{__current__.join('tmp/elastic/distribution/tar/target/')}';
      cd #{__current__.join('tmp/elastic')} && git fetch origin --quiet;
      cd #{__current__.join('tmp/elastic')} && git checkout #{gitref};
      #{build_command}
      #{extract_command}
      echo; echo; echo "Built: $build"
    CODE

    puts "", '-'*80, ""
    Rake::Task['elastic:builds'].invoke
  end

  desc "Display the info for all branches in the Elastic submodule"
  task :status do
    sh "git --git-dir=#{__current__.join('tmp/elastic/.git')} --work-tree=#{__current__.join('tmp/elastic')} branch -v -v", :verbose => false
  end

  desc "Display the list of builds"
  task :builds do
    system "mkdir -p #{__current__.join('tmp/builds')};"
    puts "Builds:"
      Dir.entries(__current__.join('tmp/builds')).reject { |f| f =~ /^\./ }.each do |build|
        puts "* #{build}"
      end
  end

  desc "Display the history of the 'rest-api-spec' repo"
  task :changes do
    STDERR.puts "Log: #{__current__.join('tmp/elastic')}/rest-api-spec", ""
    sh "git --git-dir=#{__current__.join('tmp/elastic/.git')} --work-tree=#{__current__.join('tmp/elastic')} log --pretty=format:'%C(yellow)%h%Creset %s \e[2m[%ar by %an]\e[0m' -- rest-api-spec", :verbose => false
  end
end

namespace :test do
  task :bundle => 'bundle:install'

  desc "Run unit tests in all subprojects"
  task :unit do
    Rake::Task['test:ci_reporter'].invoke if ENV['CI']
    subprojects.each do |project|
      puts '-'*80
      sh "cd #{__current__.join(project)} && unset BUNDLE_GEMFILE && bundle exec rake test:unit"
      puts "\n"
    end
  end

  desc "Run integration tests in all subprojects"
  task :integration do
    Rake::Task['elastic:update'].invoke
    Rake::Task['test:ci_reporter'].invoke if ENV['CI']
    subprojects.each do |project|
      puts '-'*80
      sh "cd #{__current__.join(project)} && unset BUNDLE_GEMFILE && bundle exec rake test:integration"
      puts "\n"
    end
  end

  desc "Run all tests in all subprojects"
  task :all do
    Rake::Task['test:ci_reporter'].invoke if ENV['CI']
    subprojects.each do |project|
      puts '-'*80
      sh "cd #{__current__.join(project)} && unset BUNDLE_GEMFILE && bundle exec rake test:all"
      puts "\n"
    end
  end

  task :ci_reporter do
    ENV['CI_REPORTS'] ||= 'tmp/reports'
    if defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'
      require 'ci/reporter/rake/test_unit'
      Rake::Task['ci:setup:testunit'].invoke
    else
      require 'ci/reporter/rake/minitest'
      Rake::Task['ci:setup:minitest'].invoke
    end
  end

  namespace :cluster do
    desc "Start Elastic nodes for tests"
    task :start do
      require 'elastic/extensions/test/cluster'
      Elastic::Extensions::Test::Cluster.start
    end

    desc "Stop Elastic nodes for tests"
    task :stop do
      require 'elastic/extensions/test/cluster'
      Elastic::Extensions::Test::Cluster.stop
    end

    task :status do
      require 'elastic/extensions/test/cluster'
      (puts "\e[31m[!] Test cluster not running\e[0m"; exit(1)) unless Elastic::Extensions::Test::Cluster.running?
      Elastic::Extensions::Test::Cluster.__print_cluster_info(ENV['TEST_CLUSTER_PORT'] || 9250)
    end
  end
end

desc "Generate documentation for all subprojects"
task :doc do
  subprojects.each do |project|
    sh "cd #{__current__.join(project)} && rake doc"
    puts '-'*80
  end
end

desc "Release all subprojects to Rubygems"
task :release do
  subprojects.each do |project|
    next if project == 'elastic-extensions'
    sh "cd #{__current__.join(project)} && rake release"
    puts '-'*80
  end
end
