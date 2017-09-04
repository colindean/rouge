# -*- coding: utf-8 -*- #

describe Rouge::Lexers::Ledger do
  let(:subject) { Rouge::Lexers::Ledger.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => 'foo.ledger'
    end
  end
end
