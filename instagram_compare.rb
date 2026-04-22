#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

# ── Helpers ────────────────────────────────────────────────────────────────────

def load_instagram_json(path)
  unless File.exist?(path)
    warn "Error: file not found → #{path}"
    exit 1
  end

  raw = JSON.parse(File.read(path))

  # Recursively walk any Hash/Array structure and collect every object that
  # looks like an Instagram profile entry — i.e. it contains a
  # "string_list_data" key whose first element has both "value" and "href".
  # This makes the loader immune to Instagram restructuring the top-level
  # wrapper (relationships_following, relationships_followers, bare Array, etc.)
  entries = []
  collect_entries = ->(node) do
    case node
    when Array
      node.each { |child| collect_entries.call(child) }
    when Hash
      if node.key?("string_list_data")
        entries << node
      else
        node.each_value { |child| collect_entries.call(child) }
      end
    end
  end

  collect_entries.call(raw)

  if entries.empty?
    warn "Warning: no profile entries found in #{path}. Raw structure preview:"
    warn JSON.pretty_generate(raw).lines.first(10).join
  end

  entries.each_with_object({}) do |entry, hash|
    data = entry["string_list_data"]&.first
    next unless data

    username = data["value"].to_s.strip
    href     = data["href"].to_s.strip
    hash[username] = href unless username.empty?
  end
end

def print_section(title, profiles)
  puts "\n#{"─" * 60}"
  puts " #{title} (#{profiles.size})"
  puts "─" * 60

  if profiles.empty?
    puts "  (none)"
  else
    profiles.sort_by { |name, _| name.downcase }.each do |name, link|
      puts "  @#{name}"
      puts "    #{link}" unless link.nil? || link.empty?
    end
  end
end

# ── Main ───────────────────────────────────────────────────────────────────────

following_path  = ARGV[0] || "following.json"
followers_path  = ARGV[1] || "followers_1.json"

puts "Loading: #{following_path}"
puts "Loading: #{followers_path}"

following  = load_instagram_json(following_path)
followers  = load_instagram_json(followers_path)

# Profiles you follow but who don't follow you back
not_following_back = following.reject { |name, _| followers.key?(name) }

# Profiles who follow you but whom you don't follow back
not_followed_back  = followers.reject { |name, _| following.key?(name) }

print_section("You follow them — they DON'T follow you back", not_following_back)
print_section("They follow you — you DON'T follow them back",  not_followed_back)

puts "\n#{"─" * 60}"
puts " Summary"
puts "─" * 60
puts "  Total following          : #{following.size}"
puts "  Total followers          : #{followers.size}"
puts "  Not following you back   : #{not_following_back.size}"
puts "  You don't follow back    : #{not_followed_back.size}"
puts "─" * 60
