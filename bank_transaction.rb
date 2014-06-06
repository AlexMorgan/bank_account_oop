class BankTransaction
  attr_reader :date, :amount, :description, :account
  def initialize(date, amount, description, account)
    @date = date
    @amount = amount.to_i
    @description = description
    @account = account
  end

  def self.read_from_csv
    transactions = []
    CSV.foreach('bank_data.csv', headers: true, header_converters: :symbol) do |row|
      transactions << row.to_hash
    end
    transactions
  end

  def self.transactions(account_type)
    trans_info = []
    self.read_from_csv.each do |trans|
      if trans[:account] == account_type
        trans_info << BankTransaction.new(trans[:date],trans[:amount],trans[:description],trans[:account])
      end
    end
    trans_info
  end

  def deposit?
    if @amount > 0
      "Deposit"
    else
      "Withdrawal"
    end
  end
end
