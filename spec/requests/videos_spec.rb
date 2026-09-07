require 'rails_helper'

RSpec.describe 'Videos', type: :request do
  let(:upload) { fixture_file_upload('sample.mp4', 'video/mp4') }

  describe 'GET /' do
    before { get root_path }

    it { expect(response).to have_http_status(:ok) }

    it { expect(response.body).to include('Process video') }

    # The button only becomes usable once Stimulus sees a file in the input.
    it { expect(response.body).to include('disabled="disabled"') }
  end

  describe 'POST /videos' do
    subject(:create_video) { post videos_path, params: { video: { file: file } } }

    context 'with a supported video' do
      let(:file) { upload }

      it { expect { create_video }.to change(Video, :count).from(0).to(1) }

      it do
        create_video
        expect(response).to redirect_to(video_path(Video.last))
      end
    end

    context 'with an unsupported format' do
      let(:file) { fixture_file_upload('sample.txt', 'text/plain') }

      it { expect { create_video }.not_to change(Video, :count) }

      it do
        create_video
        expect(response).to have_http_status(:unprocessable_content)
      end

      it do
        create_video
        expect(response.body).to include('must be one of MP4, MOV, WebM, MKV or AVI')
      end
    end

    context 'when no file was selected' do
      let(:file) { '' }

      it { expect { create_video }.not_to change(Video, :count) }

      it do
        create_video
        expect(response).to have_http_status(:unprocessable_content)
      end

      it do
        create_video
        expect(response.body).to include('Video must be selected')
      end
    end
  end

  describe 'GET /videos/:id' do
    let(:video) { Video.create!(file: upload) }

    before { get video_path(video) }

    it { expect(response).to have_http_status(:ok) }

    it { expect(response.body).to include('sample.mp4') }

    it { expect(response.body).to include(ActiveSupport::NumberHelper.number_to_human_size(video.file.byte_size)) }
  end
end
