#
# Cookbook Name:: neobundle
# Recipe:: default
#
# Copyright 2013, Kuchitama
#
# All rights reserved - Do Not Redistribute
#

VIM_HOME = node["neobundle"]["vim_home"]
BUNDLE_HOME = VIM_HOME + "/bundle"
USER = node["neobundle"]["user"]
GROUP = node["neobundle"]["group"]

directory BUNDLE_HOME do
	owner USER
	group GROUP
	mode 00744
	action :create
	recursive true
end

git BUNDLE_HOME << "/neobundle.vim" do
	user USER
	group GROUP
	if (node["neobundle"]["repository"] || {})["protocol"] == "https"
		repository "https://github.com/Shougo/neobundle.vim"
	else
		repository "git://github.com/Shougo/neobundle.vim"
	end
	reference "master"
	action :sync
end

if node["neobundle"]["home_dir"]
	bash "chown" do
		cwd VIM_HOME
		code "chown -R " <<  USER << ":" << GROUP << " " << VIM_HOME << "&&" << "chmod -R 744 " << VIM_HOME
	end
else
	bash "chown" do
		cwd BUNDLE_HOME
		code "chown -R " <<  USER << ":" << GROUP << " " << BUNDLE_HOME << "&&" << "chmod -R 744 " << BUNDLE_HOME
	end
end

if not (node["neobundle"]["skip"] || {})["vimrc"]
	template ".vimrc" do
		path node["neobundle"]["vim_home"] << "/../.vimrc"
		source "vimrc.erb"
		owner USER
		group GROUP
		mode 00744
	end
end
