require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'open-uri'
require 'mechanize'

PAGE_URL = "http://class.likelion.net/home/mypage/"
GOAL = 100
MAX = 1365
KONKUK_BEGIN = 54
KONKUK_END = 96

# Designates the starting/ending point of the parsing process
GO = 1
STOP = 1227

class HomeController < ApplicationController

    def parse
        
        # Classlion Login module using Mechanize
        a = Mechanize.new
        a.get('http://class.likelion.net/users/sign_in') 
        a.page.forms[0]["user[email]"] = "grit0614@gmail.com"
        a.page.forms[0]["user[password]"] = "rmfldns1"
        a.page.forms[0].submit
        
        # Array declaration for data storage
        @arr_name = Array.new
        @arr_univ = Array.new
        @arr_pic = Array.new
        
        
        ################################################################
        #                                                              #
        #              Beginning of Parsing Componenent                #
        #                                                              #
        ################################################################
        
        # Parse the desired data
        for i in GO..STOP
            a.get(PAGE_URL + i.to_s)
            @arr_name[i] = a.page.parser.css('div.user-profile a')[0].text
            @arr_univ[i] = a.page.parser.css('div.user-profile span.univ')[0].text.delete "| "
            
            if a.page.parser.css('div.user-photo img')[0].attr('src').chr != "/"
                @arr_pic[i] = a.page.parser.css('div.user-photo img')[0].attr('src')
            end
            
            # output test
            # puts @arr_name[i] + "   " + @arr_univ[i] + "     " + @arr_pic[i].to_s
        
            c = Contact.new
            c.id = i
            c.name = @arr_name[i].to_s
            c.univ = @arr_univ[i].to_s
            c.pic = @arr_pic[i].to_s
            c.save
            
        end
        
        ################################################################
        #                                                              #
        #                 End of Parsing Componenent                   #
        #                                                              #
        ################################################################
        
        # batch operation test
        # @arr_name.map {|x| to_s}
        # @arr_univ.map {|x| to_s}
        # @arr_pic.map {|x| to_s}
        
        # puts Contact.all
        
    end
end
