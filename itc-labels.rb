# Based on seed-repo found at https://github.com/deis/seed-repo
# MIT license

# Descriptions have been added to the new labels, but based on https://github.com/octokit/octokit.rb/issues/1057 this is 
# still an open issue. When fixed this script should automatically start adding labels when run, but only for new use

#!/usr/bin/env ruby

require 'octokit'

if ARGV.length != 2
  puts ""
  puts "Proper syntax is 'itc-labels organization/repository GitHub access token'"
  puts ""
  exit;
end

org_repo = ARGV[0]

if org_repo.nil?
  puts ""
  puts "Specify the organization/repository (i.e. itc-wgtools/cPP-tools) as the first argument"
  puts ""
  exit;
end

org = org_repo.split('/').first
repo = org_repo.split('/').last

accesstoken = ARGV[1]

if accesstoken.nil?
  puts ""
  puts "Specify the personal access token https://github.com/settings/tokens as the second argument"
  puts ""
  exit;
end

RMLABELS = [
  {:rmlabel => 'documentation'},
  {:rmlabel => 'good first issue'}
]

LABELS = [
  {:label => 'Awaiting Priority', :color => 'FF9B1C', :description => 'Issue waiting for prioritization'},
  {:label => 'Awaiting Review', :color => '0BFF00', :description => 'Issue waiting for review'},
  {:label => 'Parking Lot', :color => 'd876e3', :description => 'Issue parking lot for future consideration'},
  {:label => 'Interpretation', :color => 'F31606', :description => 'Request for Interpretation'},
  {:label => 'In Progress', :color => '54E261', :description => 'Issue being actively reviewed'},
  {:label => 'cPP', :color => '1E17A7', :description => 'cPP-related issue'},
  {:label => 'PP-Config', :color => '427FFE', :description => 'PP-Configuration-related issue'},
  {:label => 'SD', :color => '0414f2', :description => 'Supporting Document-related issue'},
  {:label => 'Public Review', :color => 'F2F91F', :description => 'Issue from Public Review period'},
  {:label => 'Applicability +2', :color => 'D3CBAA', :description => 'Maintenance priority +2'},
  {:label => 'Applicability +1', :color => 'D3CBAA', :description => 'Maintenance priority +1'},
  {:label => 'Agreement +1', :color => 'D3CBAA', :description => 'Maintenance priority +1'},
  {:label => 'Urgency +2', :color => 'D3CBAA', :description => 'Maintenance priority +2'},
  {:label => 'Coupling +2', :color => 'D3CBAA', :description => 'Maintenance priority +2'},
  {:label => 'Effort +2', :color => 'D3CBAA', :description => 'Maintenance priority +2'},
  {:label => 'Risk +1', :color => 'D3CBAA', :description => 'Maintenance priority +1'}
]

client = Octokit::Client.new(:access_token => accesstoken)



RMLABELS.each do |l|
  begin
    client.label(org_repo, l[:rmlabel])
  rescue Octokit::NotFound
    puts "Label '#{l[:rmlabel]}' does not exist. Skipping deletion..."
  else
    puts "Removing label '#{l[:rmlabel]}'..."
    client.delete_label!(org_repo, l[:rmlabel])
  end
end

LABELS.each do |l|
  begin
    client.label(org_repo, l[:label])
  rescue Octokit::NotFound
    puts "Creating label '#{l[:label]}'..."
    client.add_label(org_repo, l[:label], l[:color])
  else
    puts "Label '#{l[:label]}' exists. Skipping creation..."
  end
end
