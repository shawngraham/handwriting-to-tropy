#!/usr/bin/env ruby

require 'json'

input = ARGV[0]
items = []

def create_item(title)
  {
    'template' => 'https://tropy.org/v1/templates/generic',
    'http://purl.org/dc/elements/1.1/title' => title,
    'photo' => [{
      'template' => 'https://tropy.org/v1/templates/photo',
      'mimetype' => 'unknown',
      'checksum' => 'unknown',
      'http://purl.org/dc/elements/1.1/title' => title,
      'note' => [{
        'html' => {
        }
      }]
    }]
  }
end

File.open input do |f|
  item = nil

  f.each do |line|
    key, value = line.split(':')
    value = JSON.parse(value.strip.delete_suffix(',')) unless value.nil?

    case key
    when 'title'
      items << item unless item.nil?
      item = create_item(value)
    when 'path'
      item['photo'][0]['path'] = value
    when 'note'
      item['photo'][0]['note'][0]['html']['@value'] = value
    end
  end

  items << item unless item.nil?
end

puts JSON.pretty_generate({ '@graph' => items }, indent: '  ')