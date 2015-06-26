#!/usr/bin/env ruby
# encoding: utf-8

def is_integer( string )
	return /^\d+$/.match(string) != nil
end

def str2nb( string )
	if is_integer(string)
		return string.to_i
	end
	puts "argument invalide"
	exit
end

def is_palindrome( number )
	number.to_s == number.to_s.reverse
end

def iteration( number, base )
	number + number.to_s(base).reverse.to_i
end

def make_condition(string)
	match = /^([<>]=?)(\d+)$/.match(string)
	if match == nil
		puts "argument invalide"
		exit
	end
	number = match[2].to_i
	if match[1] == '<='
		return false, lambda {|i| i <= number}
	elsif match[1] == '<'
		return false, lambda {|i| i < number}
	elsif match[1] == '>'
		return true, lambda {|i| i > number}
	else
		return true, lambda {|i| i >= number}
	end
end

class Predicat
	attr_reader :canSwitch
	def initialize(str)
		@canSwitch, @condition = make_condition(str)	
	end

	def call(i)
		@condition.call(i)
	end
end

def parsing
	if ARGV.length < 2
		puts "argument invalide"
		exit
	end
	number, base = str2nb(ARGV[0]), str2nb(ARGV[1])
	list_conditions = ARGV[2..-1].map { |cond| Predicat.new(cond) }
	return number, base, list_conditions
end

def valid_conditions( i, list_conditions )
	list_conditions.each do |predicat|
		if not predicat.call(i) and not predicat.canSwitch
			puts "pas de solution"
			exit
		end
	end
end

def main
	number, base, list_conditions = parsing
	initial = number
	i = 0

	while true
		valid_conditions(i, list_conditions)

		if is_palindrome(number)
			puts "#{initial} donne #{number} en #{i} itérations (en base #{base})"
			break
		end

		i += 1
		number = iteration(number, base)
	end
end

main
