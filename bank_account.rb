require_relative 'bank_transaction'
require 'pry'
require 'csv'

class BankAccount
  attr_reader :account
  attr_accessor :balance
  def initialize(account, balance)
    @account = account
    @balance = balance.to_i
  end

  def starting_balance
    @balance
  end

  def ending_balance
    @balance
    transactions.each do |trans|
      @balance += trans.amount
    end
    @balance
  end

  def self.accounts
    accounts = []
    CSV.foreach('balances.csv', headers: true, header_converters: :symbol) do |row|
      accounts << BankAccount.new(row[:account], row[:balance])
    end
    accounts
  end

  def transactions
    # Match the transactions from a particular bank account instance
    # This instance variable will return an array of BankTransaction objects
    @transactions ||= BankTransaction.transactions(account)
  end

  def summary
    transactions.each do |trans|
      puts "#{trans.amount} #{trans.deposit?} #{trans.date} - #{trans.description}"
    end
  end
end


def account_summaries
  balances = BankAccount.accounts
  balances.each do |balance|
    puts "==== #{balance.account} ===="
    puts "Starting Balance: $#{balance.starting_balance}"
    puts "Ending Balance: $#{balance.ending_balance}"
    balance.summary
    puts
  end
end

my_accounts = account_summaries

