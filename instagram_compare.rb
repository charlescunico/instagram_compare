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

  # Instagram exports differ by section:
  #   following.json    → { "relationships_following": [ { "string_list_data": [...] }, ... ] }
  #   followers_1.json  → [ { "string_list_data": [...] }, ... ]
  entries =
    case raw
    when Array then raw
    when Hash  then raw.values.first   # unwrap the single top-level key
    else
      warn "Error: unexpected JSON structure in #{path}"
      exit 1
    end

  entries.each_with_object({}) do |entry, hash|
    data = entry.dig("string_list_data")&.first
    next unless data

    username = data["value"]
    href     = data["href"]
    hash[username] = href if username && !username.empty?
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
