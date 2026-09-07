require 'rails_helper'

RSpec.describe Video, type: :model do
  subject(:video) { described_class.new }

  def attach(name, content_type)
    video.file.attach(fixture_file_upload(name, content_type))
  end

  context 'with a supported video' do
    before { attach('sample.mp4', 'video/mp4') }

    it { expect(video).to be_valid }

    it { expect { video.save! }.to change(described_class, :count).from(0).to(1) }
  end

  context 'without a file' do
    before { video.valid? }

    it { expect(video).not_to be_valid }

    it { expect(video.errors[:file]).to eq([ 'must be selected' ]) }
  end

  context 'with an unsupported format' do
    before do
      attach('sample.txt', 'text/plain')
      video.valid?
    end

    it { expect(video).not_to be_valid }

    it { expect(video.errors[:file]).to eq([ 'must be one of MP4, MOV, WebM, MKV or AVI' ]) }
  end

  context 'when the file is larger than the maximum size' do
    before do
      stub_const('Video::MAX_FILE_SIZE', 1.kilobyte)
      attach('sample.mp4', 'video/mp4')
      video.valid?
    end

    it { expect(video).not_to be_valid }

    it { expect(video.errors[:file]).to eq([ 'must be smaller than 1 KB' ]) }
  end
end
