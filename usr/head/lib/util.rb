ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../../Gemfile', __FILE__)

require 'bundler/setup'
require 'highline/import'
require 'parallel'

def read_gear_registry
  gears = []
  File.open(File.join(ENV['OPENSHIFT_HAPROXY_DIR'], 'conf', 'gear-registry.db')).each do |line|
    # eade013180c842af98947e5728e88c1e@10.7.14.215:ruby-1.9;eade013180-andy.ose.rhc.redhat.com
    if line =~ /([^@]+@[^:]+):/
      gears << $~[1]
    end
  end
  gears
end

def parallel(array, threads=5, &block)
  Parallel.map(array, :in_threads => threads, &block)
end

HEAD_BIN_DIR = "#{ENV['OPENSHIFT_BINARYDEPLOY_DIR']}/usr/head/bin"
CHILD_BIN_DIR = "#{ENV['OPENSHIFT_BINARYDEPLOY_DIR']}/usr/child/bin"