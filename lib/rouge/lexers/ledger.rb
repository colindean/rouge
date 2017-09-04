# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Ledger < RegexLexer
      title "Ledger"
      desc %q(<desc for="this-lexer">Ledger</desc>)
      tag 'ledger'
      filenames *%w(*.ledger)

      # Valid dates:
      #   2017-09-03
      #   2017-9-03
      #   2017-9-3
      #   2017-09-3
      # and with / separator
      date_format = /\d{4}[\/-]{1}\d{1,2}[\/-]{1}\d{1,2}/
      effective_date = /\=#{date_format}/
      # payee contains anything to the end of the line
      payee = /.*$/
      # Expenses:House:Utilities    150.00 USD
      comment = /\;.*$/
      top_level_comment = /^#{comment}/
      transaction_comment = /\s+#{comment}/

      account = /^\s+[\w\:]*\s+/
      currency = /[\$\£\€]?/
      amount = /\d*(\.\d*)?/
      commodity = /\s[A-Za-z]+/

      budget = /^~\s*/

      state :root do
        rule date_format, Literal::Date, :transaction
        rule budget, Keyword::Namespace, :budget
        rule top_level_comment, Comment::Single
      end

      state :transaction do
        rule effective_date, Literal::String::Char
        rule payee, Name::Attribute, :items
      end

      state :budget do
        rule payee, Name::Attribute, :items
      end

      state :items do
        rule transaction_comment, Comment::Single
        rule account, Text, :need_amount
      end

      state :need_amount do
        rule currency, Name::Label, :need_amount
        rule amount, Operator, :need_commodity
        rule comment, Comment::Special, :pop!
      end

      state :need_amount do
        rule amount, Literal::Number
      end

      state :need_commodity do
        #rule /\s?/, Text
        rule commodity, Name::Label
      end
    end
  end
end
