require './src/models/web_page'

RSpec.describe WebPage, type: :model do
  let(:valid_url) { 'http://localhost:80' }
  let(:valid_instance) { described_class.new(valid_url) }

  describe 'initialize' do
    context '引数にURLが指定されている場合' do
      it 'インスタンスが生成されること' do
        expect(described_class.new(valid_url).class).to eq(WebPage)
      end
    end

    context '引数にURLが指定されていない場合' do
      it 'ArgumentErrorが発生すること' do
        expect do
          described_class.new
        end.to raise_error(ArgumentError)
      end
    end
  end

  describe 'get' do
  end

  describe 'uri' do
    it 'インスタンス生成時に設定した値を返却する' do
      expect(valid_instance.uri).to eq(valid_url)
    end
  end

  xdescribe 'header' do
    context '' do
    end
  end
end
