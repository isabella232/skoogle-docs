require "helper"

describe SkoogleDocs::Browser do
  subject(:browser) do
    described_class.new(session)
  end

  let(:session) do
    VCR.use_cassette("valid_session") do
      SkoogleDocs::Session.new(client)
    end
  end

  let(:client) do
    SkoogleDocs::Client.new do |config|
      config.client_id     = ENV["CLIENT_ID"]
      config.client_secret = ENV["CLIENT_SECRET"]
      config.access_token  = ENV["CLIENT_TOKEN"]
    end
  end

  let(:documents) do
    VCR.use_cassette("documents") do
      browser.documents
    end
  end

  let(:valid_document) do
    VCR.use_cassette("valid_document") do
      browser.document_by_id("1YPYsTsedEQXJztXOtPcPkdiy16ow8P4c0DXzHKcaB7A")
    end
  end

  let(:invalid_document) do
    VCR.use_cassette("invalid_document") do
      browser.document_by_id("1Af3Iaqf9_HOWt21DLa6M2Vfrgw0wmOKbKg9ywechIrw")
    end
  end

  let(:missing_document) do
    VCR.use_cassette("missing_document") do
      browser.document_by_id("fake_id")
    end
  end

  describe "#documents" do
    it "returns a list" do
      expect(documents).to_not be_nil
    end

    it "returns document types only" do
      are_documents = documents.all? do |doc|
        doc.mimeType == browser.mime_type
      end
      expect(are_documents).to be_truthy
    end
  end

  describe "#document_by_id" do
    context "when the file is not a document type" do
      it "raises an InvalidDocument error" do
        expected = expect { invalid_document }
        expected.to raise_error SkoogleDocs::Errors::InvalidDocument
      end
    end

    context "when the document does not exist" do
      it "raises a DocumentNotFound error" do
        expected = expect { missing_document }
        expected.to raise_error SkoogleDocs::Errors::DocumentNotFound
      end
    end

    context "when document id is valid" do
      it "returns a SkoogleDocs document" do
        expect(valid_document).to_not be_nil
      end
    end
  end
end