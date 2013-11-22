#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'pathname'
require 'active_support/core_ext'

$:.unshift File.dirname(__FILE__)

require 'socop'

BASEDIR   = Pathname.new(File.dirname(__FILE__)).join("..")
DATADIR   = BASEDIR.join("data")
WORKSPACE = BASEDIR.join("workspace")
