#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'pathname'
require 'active_support/core_ext'
require 'active_resource'

$:.unshift File.dirname(__FILE__)

require 'socop'
require 'ontohub'

BASEDIR   = Pathname.new(File.dirname(__FILE__)).join("..")
DATADIR   = BASEDIR.join("data")
WORKSPACE = BASEDIR.join("workspace")
CONFIG    = YAML.load_file BASEDIR.join('config.yml')

Ontohub.config   = CONFIG['ontohub']
